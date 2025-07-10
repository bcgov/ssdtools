# Copyright 2015-2023 Province of British Columbia
# Copyright 2021 Environment and Climate Change Canada
# Copyright 2023-2025 Australian Government Department of Climate Change,
# Energy, the Environment and Water
#
#    Licensed under the Apache License, Version 2.0 (the "License");
#    you may not use this file except in compliance with the License.
#    You may obtain a copy of the License at
#
#       https://www.apache.org/licenses/LICENSE-2.0
#
#    Unless required by applicable law or agreed to in writing, software
#    distributed under the License is distributed on an "AS IS" BASIS,
#    WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
#    See the License for the specific language governing permissions and
#    limitations under the License.

## required to pass dist as not available for dists that didn't fit
nullify_nonfit <- function(fit, dist, data, rescale, computable,
                           min_pmix, range_shape1, range_shape2, at_boundary_ok, silent) {
  error <- fit$error
  fit <- fit$result
  
  rescale <- if (rescale == 1) " (try rescaling data)" else NULL
  
  if (!is.null(error)) {
    if (!silent) {
      wrn(
        "Distribution '", dist, "' failed to fit",
        rescale, ": ", error
      )
    }
    return(NULL)
  }
  
  fit$flags$at_boundary <- is_at_boundary(
    fit, data, min_pmix, range_shape1, range_shape2
  )
  if (!at_boundary_ok && fit$flags$at_boundary) {
    if (!silent) {
      wrn(
        "Distribution '", dist, "' failed to fit",
        rescale, ": one or more parameters at boundary."
      )
    }
    return(NULL)
  }
  
  if (!optimizer_converged(fit)) {
    message <- optimizer_message(fit)
    if (!silent) {
      wrn(
        "Distribution '", dist, "' failed to converge",
        rescale, ": ", message
      )
    }
    return(NULL)
  }
  fit$flags$computable <- !any(is.na(tidy(fit)$se))
  if (computable && !fit$flags$computable) {
    if (!silent) {
      wrn(
        "Distribution '", dist,
        "' failed to compute standard errors", rescale, "."
      )
    }
    return(NULL)
  }
  fit
}

remove_nonfits <- function(fits, data, rescale, computable, min_pmix, range_shape1, range_shape2, at_boundary_ok, silent) {
  fits <- mapply(nullify_nonfit, fits, names(fits),
                 MoreArgs = list(
                   data = data, rescale = rescale, computable = computable,
                   min_pmix = min_pmix,
                   range_shape1 = range_shape1, range_shape2 = range_shape2,
                   at_boundary_ok = at_boundary_ok, silent = silent
                 ), SIMPLIFY = FALSE
  )
  fits <- fits[!vapply(fits, is.null, TRUE)]
  fits
}

fit_dists <- function(data, dists, min_pmix, range_shape1, range_shape2, control, at_boundary_ok = TRUE, silent = TRUE, rescale = FALSE, computable = FALSE, pars = NULL, hessian = TRUE) {
  data <- data[c("left", "right", "weight")]
  safe_fit_dist <- safely(fit_tmb)
  names(dists) <- dists
  if (!is.null(pars)) {
    pars <- pars[dists]
  } else {
    pars <- rep(list(NULL), length(dists))
  }
  
  fits <- purrr::map2(dists, pars,
                      .f = safe_fit_dist,
                      data = data, min_pmix = min_pmix,
                      range_shape1 = range_shape1, range_shape2 = range_shape2, control = control,
                      hessian = hessian
  )
  fits <- remove_nonfits(fits,
                         data = data, rescale = rescale,
                         computable = computable, min_pmix = min_pmix,
                         range_shape1 = range_shape1, range_shape2 = range_shape2,
                         at_boundary_ok = at_boundary_ok, silent = silent
  )
  
  class(fits) <- "fitdists"
  fits
}

fits_dists <- function(data, dists, min_pmix, range_shape1, range_shape2, control,
                       censoring, weighted, all_dists = TRUE,
                       at_boundary_ok = TRUE, silent = TRUE, rescale = FALSE, computable = FALSE, pars = NULL, hessian = TRUE) {
  fits <- fit_dists(data, dists,
                    min_pmix = min_pmix, range_shape1 = range_shape1,
                    range_shape2 = range_shape2,
                    at_boundary_ok = at_boundary_ok,
                    control = control, silent = silent,
                    rescale = rescale, computable = computable
  )
  if (!length(fits)) {
    err("All distributions failed to fit.")
  }
  if (all_dists && length(fits) != length(dists)) {
    err("One or more distributions failed to fit.")
  }
  
  attrs <- list()
  attrs$data <- data
  attrs$control <- control
  attrs$rescale <- rescale
  attrs$censoring <- censoring
  attrs$weighted <- weighted
  attrs$min_pmix <- min_pmix
  attrs$range_shape1 <- range_shape1
  attrs$range_shape2 <- range_shape2
  
  .attrs_fitdists(fits) <- attrs
  fits
}

#' Fit Distributions
#'
#' Fits one or more distributions to species sensitivity data.
#'
#' By default the 'gamma', 'lgumbel', 'llogis', 'lnorm', 'lnorm_lnorm' and
#' 'weibull' distributions are fitted to the data.
#' For a complete list of the distributions that are currently implemented in
#' `ssdtools` see [`ssd_dists_all()`].
#'
#' If weight specifies a column in the data frame with positive numbers,
#' weighted estimation occurs.
#' However, currently only the resultant parameter estimates are available.
#'
#' If the `right` argument is different to the `left` argument
#' then the data are considered to be censored.
#'
#'
#' @inheritParams params
#' @return An object of class fitdists.
#' @seealso [`ssd_plot_cdf()`] and [`ssd_hc()`]
#'
#' @export
#' @examples
#' fits <- ssd_fit_dists(ssddata::ccme_boron)
#' fits
#' ssd_plot_cdf(fits)
#' ssd_hc(fits)
ssd_fit_dists <- function(
    data, 
    left = "Conc",
    ...,
    right = left, 
    weight = NULL,
    dists = ssd_dists_bcanz(),
    nrow = 6L,
    rescale = FALSE,
    odds_max = 0.999,
    reweight = FALSE,
    computable = FALSE,
    at_boundary_ok = TRUE,
    all_dists = FALSE,
    min_pmix = ssd_min_pmix(nrow(data)),
    range_shape1 = c(0.05, 20),
    range_shape2 = range_shape1,
    control = list(),
    silent = FALSE) {
  chk_unused(...)
  chk_character_or_factor(dists)
  chk_vector(dists)
  check_dim(dists, values = TRUE)
  chk_not_any_na(dists)
  chk_unique(dists)
  
  chk_subset(dists, ssd_dists_all(valid = NULL))
  if(length(dists) > 1 && any(dists %in% ssd_dists_all(valid = FALSE))) {
    err("distributions with invalid likelihoods must be fitted in isolation.")
  }
  
  chk_whole_number(nrow)
  chk_gte(nrow, 4L)
  
  chkor_vld(vld_flag(rescale), vld_string(rescale))
  chk_number(odds_max)
  chk_range(odds_max, inclusive = FALSE)
  chk_flag(reweight)
  chk_flag(computable)
  chk_flag(at_boundary_ok)
  chk_flag(all_dists)
  chk_number(min_pmix)
  chk_range(min_pmix, c(0, 0.5))
  chk_numeric(range_shape1)
  chk_vector(range_shape1)
  check_dim(range_shape1, values = 2)
  chk_not_any_na(range_shape1)
  chk_gte(range_shape1)
  chk_sorted(range_shape1)
  chk_numeric(range_shape2)
  chk_vector(range_shape2)
  check_dim(range_shape2, values = 2)
  chk_not_any_na(range_shape2)
  chk_gte(range_shape2)
  chk_sorted(range_shape2)
  chk_list(control)
  chk_flag(silent)
  
  if(isTRUE(rescale)) {
    rescale <- "geomean"
  } else if(isFALSE(rescale)) {
    rescale <- "no"
  }
  chk_subset(rescale, c("no", "geomean", "odds"))
  .chk_data(data, left, right, weight, odds = rescale == "odds", nrow)
  
  org_data <- as_tibble(data)
  data <- process_data(data, left, right, weight)
  attrs <- adjust_data(data, rescale = rescale, reweight = reweight, odds_max = odds_max, silent = silent)
  
  fits <- fits_dists(attrs$data, dists,
                     min_pmix = min_pmix, range_shape1 = range_shape1,
                     range_shape2 = range_shape2,
                     all_dists = all_dists,
                     at_boundary_ok = at_boundary_ok,
                     control = control, silent = silent,
                     rescale = attrs$rescale, computable = computable,
                     censoring = attrs$censoring,
                     weighted = attrs$weighted
  )
  
  .org_data_fitdists(fits) <- org_data
  .cols_fitdists(fits) <- list(left = left, right = right, weight = weight)
  .unequal_fitdists(fits) <- attrs$unequal
  fits
}
