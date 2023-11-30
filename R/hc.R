# Copyright 2023 Province of British Columbia
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

#' Hazard Concentrations for Species Sensitivity Distributions
#'
#' Gets concentration(s) that protect specified percentage(s) of species.
#'
#' If `ci = TRUE` uses parameteric bootstrapping to get confidence intervals on the
#' hazard concentrations(s).
#'
#' @inheritParams params
#' @return A tibble of corresponding hazard concentrations.
#' @seealso [`predict.fitdists()`] and [`ssd_hp()`].
#' @export
ssd_hc <- function(x, ...) {
  UseMethod("ssd_hc")
}

.ssd_hc_burrlioz_tmbfit <- function(x, value, level, nboot, min_pboot,
                                    data, rescale, weighted, censoring, min_pmix,
                                    range_shape1, range_shape2, parametric, control) {
  args <- estimates(x)
  args$p <- value
  dist <- .dist_tmbfit(x)
  stopifnot(identical(dist, "burrIII3"))
  
  what <- paste0("ssd_q", dist)
  
  est <- do.call(what, args)
  censoring <- censoring / rescale
  
  fun <- fit_burrlioz
  estimates <- estimates(x)
  pars <- .pars_tmbfit(x)
  
  estimates <- boot_estimates(fun = fun, dist = dist, estimates = estimates, 
                              pars = pars,
                              nboot = nboot, data = data, weighted = weighted,
                              censoring = censoring, min_pmix = min_pmix,
                              range_shape1 = range_shape1,
                              range_shape2 = range_shape2,
                              parametric = parametric,
                              control = control
  )
  
  cis <- cis_estimates(estimates,
                       what = "ssd_qburrlioz", level = level, x = value,
                       .names = c("scale", "shape", "shape1", "shape2", "locationlog", "scalelog")
  )
  
  method <- if (parametric) "parametric" else "non-parametric"
  
  hc <- tibble(
    dist = dist,
    value = value, est = est * rescale,
    se = cis$se * rescale, lcl = cis$lcl * rescale, ucl = cis$ucl * rescale,
    method = method,
    nboot = nboot, pboot = length(estimates) / nboot
  )
  replace_min_pboot_na(hc, min_pboot)
}

.ssd_hc_burrlioz_fitdists <- function(x, value, level, nboot, min_pboot, parametric) {
  control <- .control_fitdists(x)
  data <- .data_fitdists(x)
  rescale <- .rescale_fitdists(x)
  censoring <- .censoring_fitdists(x)
  min_pmix <- .min_pmix_fitdists(x)
  range_shape1 <- .range_shape1_fitdists(x)
  range_shape2 <- .range_shape2_fitdists(x)
  weighted <- .weighted_fitdists(x)
  unequal <- .unequal_fitdists(x)
  
  if (parametric && identical(censoring, c(NA_real_, NA_real_))) {
    err("Parametric CIs cannot be calculated for inconsistently censored data.")
  }
  
  if (parametric && unequal) {
    err("Parametric CIs cannot be calculated for unequally weighted data.")
  }
  
  hc <- purrr::map(x, .ssd_hc_burrlioz_tmbfit,
                   value = value,
                   level = level, nboot = nboot, min_pboot = min_pboot,
                   data = data, rescale = rescale, weighted = weighted, censoring = censoring,
                   min_pmix = min_pmix, range_shape1 = range_shape1, range_shape2 = range_shape2,
                   parametric = parametric,
                   control = control
  )$burrIII3
  warn_min_pboot(hc, min_pboot)
}

.ssd_hc_dist <- function(x, dist, proportion) {
  fun <- paste0("ssd_q", dist)
  args <- list(p = proportion)
  args <- c(as.list(x), args)
  est <- do.call(fun, args)
  tibble(
    dist = dist,
    percent = proportion * 100, est = est,
    se = NA_real_, lcl = NA_real_, ucl = NA_real_,
    wt = 1,
    nboot = 0L, pboot = NA_real_
  )
}

#' @describeIn ssd_hc Hazard Concentrations for Distributional Estimates
#' @export
#' @examples
#' 
#' ssd_hc(ssd_match_moments())
ssd_hc.list <- function(x, percent = 5, ...) {
  chk_list(x)
  chk_named(x)
  chk_unique(names(x))
  chk_unused(...)
  
  if (!length(x)) {
    hc <- no_hcp()
    hc <- dplyr::rename(hc, percent = "value")
    return(hc)
  }
  hc <- mapply(.ssd_hc_dist, x, names(x),
               MoreArgs = list(proportion = percent / 100),
               SIMPLIFY = FALSE
  )
  bind_rows(hc)
}

#' @describeIn ssd_hc Hazard Concentrations for fitdists Object
#' @export
#' @examples
#' 
#' fits <- ssd_fit_dists(ssddata::ccme_boron)
#' ssd_hc(fits)
ssd_hc.fitdists <- function(
    x, 
    percent = 5, 
    ci = FALSE, 
    level = 0.95, 
    nboot = 1000,
    average = TRUE, 
    delta = 7, 
    min_pboot = 0.99,
    parametric = TRUE, 
    multi = FALSE,
    control = NULL, 
    ...) {
  
  chk_vector(percent)
  chk_numeric(percent)
  chk_range(percent, c(0, 100))
  chk_unused(...)
  
  proportion <- percent / 100
  
  hcp <- ssd_hcp_fitdists(
    x = x, 
    value = proportion,
    ci = ci,
    level = level,
    nboot = nboot,
    average = average,
    delta = delta,
    min_pboot = min_pboot,
    parametric = parametric,
    multi = multi,
    control = control,
    hc = TRUE)
  
  hcp <- dplyr::rename(hcp, percent = "value")
  hcp <- dplyr::mutate(hcp, percent = .data$percent * 100)
  hcp
}

#' @describeIn ssd_hc Hazard Concentrations for fitburrlioz Object
#' @export
#' @examples
#' 
#' fit <- ssd_fit_burrlioz(ssddata::ccme_boron)
#' ssd_hc(fit)
ssd_hc.fitburrlioz <- function(x, percent = 5, ci = FALSE, level = 0.95, nboot = 1000,
                               min_pboot = 0.99, parametric = FALSE, ...) {
  chk_length(x, upper = 1L)
  chk_named(x)
  chk_subset(names(x), c("burrIII3", "invpareto", "llogis", "lgumbel"))
  chk_vector(percent)
  chk_numeric(percent)
  chk_range(percent, c(0, 100))
  chk_flag(ci)
  
  if (names(x) != "burrIII3" || !ci || !length(percent)) {
    class(x) <- class(x)[-1]
    return(ssd_hc(x,
                  percent = percent, ci = ci, level = level,
                  nboot = nboot, min_pboot = min_pboot,
                  average = FALSE, parametric = parametric
    ))
  }
  chk_number(level)
  chk_range(level)
  chk_whole_number(nboot)
  chk_gt(nboot)
  chk_number(min_pboot)
  chk_range(min_pboot)
  chk_flag(parametric)
  chk_unused(...)
  
  proportion <- percent / 100
  hcp <- .ssd_hc_burrlioz_fitdists(x,
                                  value = proportion, level = level, nboot = nboot,
                                  min_pboot = min_pboot, parametric = parametric
  )
  hcp <- dplyr::rename(hcp, percent = "value")
  hcp <- dplyr::mutate(hcp, percent = .data$percent * 100)
  hcp
}
