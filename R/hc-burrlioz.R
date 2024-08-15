# Copyright 2023 Environment and Climate Change Canada
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
#' @examples
#' fit <- ssd_fit_burrlioz(ssddata::ccme_boron)
#' ssd_hc_burrlioz(fit)
#'
#' @export
ssd_hc_burrlioz <- function(x, percent, proportion = 0.05, ci = FALSE, level = 0.95, nboot = 1000,
                            min_pboot = 0.95, parametric = FALSE) {
  lifecycle::deprecate_warn("0.3.5", "ssd_hc_burrlioz()", "ssd_hc()")
  chk_s3_class(x, "fitburrlioz")

  if (lifecycle::is_present(percent)) {
    lifecycle::deprecate_soft("1.0.6.9009", "ssd_hc(percent)", "ssd_hc(proportion)", id = "hc")
    chk_vector(percent)
    chk_numeric(percent)
    chk_range(percent, c(0, 100))
    proportion <- percent / 100
  }

  chk_vector(proportion)
  chk_numeric(proportion)
  chk_range(proportion)

  ssd_hc(x,
    proportion = proportion, ci = ci, level = level,
    nboot = nboot, min_pboot = min_pboot, parametric = parametric
  )
}
