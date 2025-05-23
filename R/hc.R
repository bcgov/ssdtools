# Copyright 2015-2023 Province of British Columbia
# Copyright 2021 Environment and Climate Change Canada
# Copyright 2023-2024 Australian Government Department of Climate Change,
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

#' Hazard Concentrations for Species Sensitivity Distributions
#'
#' Calculates concentration(s) with bootstrap confidence intervals
#' that protect specified proportion(s) of species for
#' individual or model-averaged distributions
#' using parametric or non-parametric bootstrapping.
#'
#' Model-averaged estimates and/or confidence intervals (including standard error)
#' can be calculated  by treating the distributions as
#' constituting a single mixture distribution
#' versus 'taking the mean'.
#' When calculating the model averaged estimates treating the
#' distributions as constituting a single mixture distribution
#' ensures that `ssd_hc()` is the inverse of `ssd_hp()`.
#'
#' If treating the distributions as constituting a single mixture distribution
#' when calculating model average confidence intervals then
#' `weighted` specifies whether to use the original model weights versus
#' re-estimating for each bootstrap sample unless 'taking the mean' in which case
#' `weighted` specifies
#' whether to take bootstrap samples from each distribution proportional to
#' its weight (so that they sum to `nboot`) versus
#' calculating the weighted arithmetic means of the lower
#' and upper confidence limits based on `nboot` samples for each distribution.
#'
#' Distributions with an absolute AIC difference greater
#' than a delta of by default 7 have considerably less support (weight < 0.01)
#' and are excluded
#' prior to calculation of the hazard concentrations to reduce the run time.
#'
#' @references
#'
#' Burnham, K.P., and Anderson, D.R. 2002. Model Selection and Multimodel Inference. Springer New York, New York, NY. doi:10.1007/b97636.
#'
#' @inheritParams params
#' @return A tibble of corresponding hazard concentrations.
#' @seealso [`predict.fitdists()`] and [`ssd_hp()`].
#' @export
ssd_hc <- function(x, ...) {
  UseMethod("ssd_hc")
}

.ssd_hc_dist <- function(x, dist, proportion) {
  fun <- paste0("ssd_q", dist)
  args <- list(p = proportion)
  args <- c(as.list(x), args)
  est <- do.call(fun, args)
  tibble(
    dist = dist,
    proportion = proportion, est = est,
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
ssd_hc.list <- function(
    x,
    percent,
    proportion = 0.05,
    ...) {
  chk_list(x)
  chk_named(x)
  chk_unique(names(x))
  chk_unused(...)
  
  if (lifecycle::is_present(percent)) {
    lifecycle::deprecate_soft("2.0.0", "ssd_hc(percent)", with = "ssd_hc(proportion)", id = "hc")
    chk_vector(percent)
    chk_numeric(percent)
    chk_range(percent, c(0, 100))
    proportion <- percent / 100
  }
  
  chk_vector(proportion)
  chk_numeric(proportion)
  chk_range(proportion)
  
  if (!length(x)) {
    hc <- no_hcp()
    hc <- dplyr::rename(hc, proportion = "value")
    return(hc)
  }
  hc <- mapply(.ssd_hc_dist, x, names(x),
               MoreArgs = list(proportion = proportion),
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
    percent,
    proportion = 0.05,
    average = TRUE,
    ci = FALSE,
    level = 0.95,
    nboot = 1000,
    min_pboot = 0.95,
    multi_est = TRUE,
    ci_method = "weighted_samples",
    parametric = TRUE,
    delta = 9.21,
    samples = FALSE,
    save_to = NULL,
    control = NULL,
    ...) {
  chk_unused(...)
  
  if (lifecycle::is_present(percent)) {
    lifecycle::deprecate_soft("2.0.0", "ssd_hc(percent)", "ssd_hc(proportion)", id = "hc")
    chk_vector(percent)
    chk_numeric(percent)
    chk_range(percent, c(0, 100))
    proportion <- percent / 100
  }
  
  chk_vector(proportion)
  chk_numeric(proportion)
  chk_range(proportion)
  chk_string(ci_method)
  chk_subset(ci_method, c("weighted_samples", "weighted_arithmetic", "multi_free", "multi_fixed"))

  fix_weights <- ci_method %in% c("weighted_samples", "multi_fixed")
  multi_ci <- ci_method %in% c("multi_free", "multi_fixed")
  
  if(length(x) == 1L) {
    average <- FALSE
  }
  
  hcp <- ssd_hcp_fitdists(
    x = x,
    value = proportion,
    ci = ci,
    level = level,
    nboot = nboot,
    average = average,
    multi_est = multi_est,
    delta = delta,
    min_pboot = min_pboot,
    parametric = parametric,
    multi_ci = multi_ci,
    fix_weights = fix_weights,
    control = control,
    samples = samples,
    save_to = save_to,
    hc = TRUE
  )
  
  hcp <- dplyr::rename(hcp, proportion = "value")
  hcp
}

#' @describeIn ssd_hc Hazard Concentrations for fitburrlioz Object
#' @export
#' @examples
#'
#' fit <- ssd_fit_burrlioz(ssddata::ccme_boron)
#' ssd_hc(fit)
ssd_hc.fitburrlioz <- function(
    x,
    percent,
    proportion = 0.05,
    ci = FALSE,
    level = 0.95,
    nboot = 1000,
    min_pboot = 0.95,
    parametric = FALSE,
    samples = FALSE,
    save_to = NULL,
    ...) {
  chk_length(x, upper = 1L)
  chk_named(x)
  chk_subset(names(x), c("burrIII3", "invpareto", "llogis", "lgumbel"))
  chk_unused(...)
  
  if (lifecycle::is_present(percent)) {
    lifecycle::deprecate_soft("2.0.0", "ssd_hc(percent)", "ssd_hc(proportion)", id = "hc")
    chk_vector(percent)
    chk_numeric(percent)
    chk_range(percent, c(0, 100))
    proportion <- percent / 100
  }
  
  chk_vector(proportion)
  chk_numeric(proportion)
  chk_range(proportion)
  
  fun <- if (names(x) == "burrIII3") fit_burrlioz else fit_tmb
  
  hcp <- ssd_hcp_fitdists(
    x = x,
    value = proportion,
    ci = ci,
    level = level,
    nboot = nboot,
    average = FALSE,
    multi_est = "invertible",
    delta = Inf,
    min_pboot = min_pboot,
    parametric = parametric,
    multi_ci = TRUE,
    save_to = save_to,
    samples = samples,
    control = NULL,
    hc = TRUE,
    fix_weights = FALSE,
    fun = fun
  )
  
  hcp <- dplyr::rename(hcp, proportion = "value")
  hcp
}
