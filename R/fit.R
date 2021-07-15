#    Copyright 2015 Province of British Columbia
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

# required to pass dist as not available for dists that didn't fit
nullify_nonfit <- function(fit, dist, data, rescale, computable, silent) {
  error <- fit$error
  fit <- fit$result
  
  rescale <- if(rescale == 1) " (try rescaling data)" else NULL
  
  if (!is.null(error)) {
    if (!silent) wrn("Distribution '", dist, "' failed to fit", 
                     rescale, ": ", error)
    return(NULL)
  }
  if(is_at_boundary(fit, data)) {
    if (!silent) wrn("Distribution '", dist, "' failed to fit",
                     rescale, ": one or more parameters at boundary.")
    return(NULL)
  }
  if(!optimizer_converged(fit)) {
    message <- optimizer_message(fit)
    if (!silent) wrn("Distribution '", dist, "' failed to converge",
                     rescale, ": ", message)
    return(NULL)
  }
  if (computable) {
    tidy <- tidy(fit)
    if (any(is.na(tidy$se))) {
      if (!silent) wrn("Distribution '", dist, 
                       "' failed to compute standard errors", rescale, ".")
      return(NULL)
    }
  }
  fit
}

remove_nonfits <- function(fits, data, rescale, computable, silent) {
  fits <- mapply(nullify_nonfit, fits, names(fits),
                 MoreArgs = list(data = data, rescale = rescale, computable = computable, silent = silent), SIMPLIFY = FALSE
  )
  fits <- fits[!vapply(fits, is.null, TRUE)]
  fits
}

fit_dists <- function(data, dists, rescale, computable, control, silent) {
  data <- data[c("left", "right", "weight")]
  safe_fit_dist <- safely(fit_tmb)
  names(dists) <- dists
  fits <- lapply(dists, safe_fit_dist, data = data, control = control)
  fits <- remove_nonfits(fits, data = data, rescale = rescale, computable = computable, silent = silent)
  fits
}

#' Fit Distributions
#'
#' Fits one or more distributions to species sensitivity data.
#'
#' By default the 'llogis', 'gamma' and 'lnorm'
#' distributions are fitted to the data.
#' The ssd_fit_dists function has also been
#' tested with the 'gompertz', 'lgumbel' and 'weibull' distributions.
#'
#' If weight specifies a column in the data frame with positive numbers,
#' weighted estimation occurs.
#' However, currently only the resultant parameter estimates are available (via coef).
#'
#' If the `right` argument is different to the `left` argument then the data are considered to be censored.
#'
#' @inheritParams params
#' @return An object of class fitdists.
#'
#' @export
#' @examples
#' ssd_fit_dists(boron_data)
ssd_fit_dists <- function(
  data, left = "Conc", right = left, weight = NULL,
  dists = ssd_dists("bc"),
  nrow = 6L,
  rescale = FALSE,
  reweight = FALSE,
  computable = TRUE,
  control = list(),
  silent = FALSE) {
  
  chk_character_or_factor(dists)
  chk_vector(dists)
  check_dim(dists, values = TRUE)
  chk_not_any_na(dists)
  chk_unique(dists)
  
  if ("llog" %in% dists) {
    deprecate_stop("0.1.0", "dllog()", "dllogis()",
                   details = "The 'llog' distribution has been deprecated for the identical 'llogis' distribution.")
  }
  if ("burrIII2" %in% dists) {
    deprecate_stop("0.1.2", "xburrIII2()",
                   details = "The 'burrIII2' distribution has been deprecated for the identical 'llogis' distribution.")
  }
  chk_subset(dists, ssd_dists("all"))
  
  chk_whole_number(nrow)
  chk_gte(nrow, 4L)
  .chk_data(data, left, right, weight, nrow)
  
  chk_flag(rescale)
  chk_flag(reweight)
  chk_flag(computable)
  chk_list(control)
  chk_flag(silent)
  
  org_data <- as_tibble(data)
  data <- process_data(data, left, right, weight)
  attrs <- adjust_data(data, rescale = rescale, reweight = reweight, silent = silent)
  
  if(any(is.infinite(attrs$data$right))) {
    err("Distributions cannot currently be fitted to right censored data.")
  }
  fits <- fit_dists(attrs$data, dists, attrs$rescale, computable, control, silent)
  
  if (!length(fits)) err("All distributions failed to fit.")
  class(fits) <- "fitdists"
  
  attrs$cols <- list(left = left, right = right, weight = weight)
  attrs$control <- control
  attrs$org_data <- org_data
  
  .attrs_fitdists(fits) <- attrs
  fits
}
