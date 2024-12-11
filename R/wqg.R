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

#' Water Quality Guideline for British Columbia
#' `r lifecycle::badge("deprecated")`
#'
#' Calculates the 5% Hazard Concentration using `ssd_fit_bcanz()`
#' and `ssd_hc()`.
#'
#' @inheritParams params
#'
#' @return A tibble of the 5% hazard concentration with 95% confidence intervals.
#' @family wqg
#' @seealso [`ssd_fit_bcanz()`] and [`ssd_hc()`]
#' @export
#'
#' @examples
#' \dontrun{
#' ssd_wqg_bc(ssddata::ccme_boron)
#' }
ssd_wqg_bc <- function(data, left = "Conc") {
  lifecycle::deprecate_warn(
    "2.0.0", "ssd_wqg_bc()", 
    details = "Please use `ssd_fit_bcanz()` and `ssd_hc()` instead."
  )
  fits <- ssd_fit_bcanz(data, left = left)
  ssd_hc(fits, ci = TRUE, nboot = 10000)
}


#' Water Quality Guideline for Burrlioz
#' `r lifecycle::badge("deprecated")`
#'
#' Calculates the 5% Hazard Concentration using `ssd_fit_burrlioz()`
#' and `ssd_hc()`.
#'
#' @inheritParams params
#'
#' @return A tibble of the 5% hazard concentration with 95% confidence intervals.
#' @family wqg
#' @seealso [`ssd_fit_burrlioz()`] and [`ssd_hc()`]
#' @export
#'
#' @examples
#' \dontrun{
#' ssd_wqg_burrlioz(ssddata::ccme_boron)
#' }
ssd_wqg_burrlioz <- function(data, left = "Conc") {
  lifecycle::deprecate_warn(
    "2.0.0", "ssd_wqg_burrlioz()",
    details = "Please use `ssd_fit_burrlioz()` and `ssd_hc()` instead."
  )
  fit <- ssd_fit_burrlioz(data, left = left, rescale = FALSE)
  ssd_hc(fit, ci = TRUE, nboot = 10000)
}
