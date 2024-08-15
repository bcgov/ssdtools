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

#' Hazard Proportion
#'
#' Calculates proportion of species affected at specified concentration(s)
#' with quantile based bootstrap confidence intervals for
#' individual or model-averaged distributions
#' using parametric or non-parametric bootstrapping.
#' For more information see the inverse function [`ssd_hc()`].
#'
#' @inheritParams params
#' @return A tibble of corresponding hazard proportions.
#' @seealso [`ssd_hc()`]
#' @export
#' @examples
#' fits <- ssd_fit_dists(ssddata::ccme_boron)
#' ssd_hp(fits, conc = 1)
ssd_hp <- function(x, ...) {
  UseMethod("ssd_hp")
}

#' @describeIn ssd_hp Hazard Proportions for fitdists Object
#' @export
ssd_hp.fitdists <- function(
    x,
    conc = 1,
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
  chk_vector(conc)
  chk_numeric(conc)
  chk_subset(ci_method, c("weighted_samples", "weighted_arithmetic", "multi_free", "multi_fixed"))

  chk_unused(...)


  fix_weights <- ci_method %in% c("weighted_samples", "multi_fixed")
  multi_ci <- ci_method %in% c("multi_free", "multi_fixed")

  hcp <- ssd_hcp_fitdists(
    x = x,
    value = conc,
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
    save_to = save_to,
    samples = samples,
    hc = FALSE
  )
  hcp <- dplyr::rename(hcp, conc = "value")
  hcp
}


#' @describeIn ssd_hp Hazard Proportions for fitburrlioz Object
#' @export
#' @examples
#'
#' fit <- ssd_fit_burrlioz(ssddata::ccme_boron)
#' ssd_hp(fit)
ssd_hp.fitburrlioz <- function(
    x,
    conc = 1,
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
  chk_vector(conc)
  chk_numeric(conc)
  chk_flag(ci)
  chk_unused(...)

  fun <- if (names(x) == "burrIII3") fit_burrlioz else fit_tmb

  hcp <- ssd_hcp_fitdists(
    x = x,
    value = conc,
    ci = ci,
    level = level,
    nboot = nboot,
    average = FALSE,
    multi_est = TRUE,
    delta = Inf,
    min_pboot = min_pboot,
    parametric = parametric,
    multi_ci = TRUE,
    control = NULL,
    save_to = save_to,
    samples = samples,
    hc = FALSE,
    fix_weights = FALSE,
    fun = fun
  )

  hcp <- dplyr::rename(hcp, conc = "value")
  hcp
}
