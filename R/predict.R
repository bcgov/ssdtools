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

#' @export
stats::predict

#' Predict Hazard Concentrations of fitdists Object
#'
#' A wrapper on [`ssd_hc()`] that by default calculates
#' all hazard concentrations from 1 to 99%.
#'
#' It is useful for plotting purposes.
#'
#' @inheritParams params
#' @export
#' @seealso [`ssd_hc()`] and [`ssd_plot()`]
#' @examples
#' fits <- ssd_fit_dists(ssddata::ccme_boron)
#' predict(fits)
predict.fitdists <- function(
    object,
    percent,
    proportion = 1:99 / 100,
    ...,
    average = TRUE,
    ci = FALSE,
    level = 0.95,
    nboot = 1000,
    min_pboot = 0.95,
    est_method = "multi",
    ci_method = "weighted_samples",
    parametric = TRUE,
    delta = 9.21,
    control = NULL) {
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

  ssd_hc(
    object,
    proportion = proportion,
    ci = ci,
    level = level,
    nboot = nboot,
    min_pboot = min_pboot,
    est_method = est_method,
    average = average,
    delta = delta,
    parametric = parametric,
    ci_method = ci_method,
    control = control
  )
}

#' Predict Hazard Concentrations of fitburrlioz Object
#'
#' A wrapper on [`ssd_hc()`] that by default calculates
#' all hazard concentrations from 1 to 99%.
#'
#' It is useful for plotting purposes.
#'
#' @inheritParams params
#' @export
#' @seealso [`ssd_hc()`] and [`ssd_plot()`]
#' @examples
#' fits <- ssd_fit_burrlioz(ssddata::ccme_boron)
#' predict(fits)
predict.fitburrlioz <- function(
    object,
    percent,
    proportion = 1:99 / 100,
    ...,
    ci = FALSE,
    level = 0.95,
    nboot = 1000,
    min_pboot = 0.95,
    parametric = TRUE) {
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

  ssd_hc(object,
    proportion = proportion,
    ci = ci,
    level = level,
    nboot = nboot,
    min_pboot = min_pboot,
    parametric = parametric
  )
}
