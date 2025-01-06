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

#' Hazard Concentrations for Burrlioz Fit
#' `r lifecycle::badge('deprecated')`
#'
#' Deprecated for [`ssd_hc()`].
#'
#' @inheritParams params
#' @return A tibble of corresponding hazard concentrations.
#' @export
ssd_hc_burrlioz <- function(x, percent, proportion = 0.05, ci = FALSE, level = 0.95, nboot = 1000,
                            min_pboot = 0.95, parametric = FALSE) {
  lifecycle::deprecate_stop("0.3.5", "ssd_hc_burrlioz()", "ssd_hc()")
}
