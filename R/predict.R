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
predict.fitdists <- function(object, percent = 1:99, ci = FALSE,
                             level = 0.95, nboot = 1000,
                             average = TRUE, delta = 7,
                             min_pboot = 0.99,
                             parametric = TRUE,
                             root = FALSE,
                             control = NULL,
                             ...) {
  chk_unused(...)
  ssd_hc(object,
    percent = percent, ci = ci, level = level,
    nboot = nboot, min_pboot = min_pboot,
    average = average, delta = delta, parametric = parametric,
    root = root, control = control
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
predict.fitburrlioz <- function(object, percent = 1:99, ci = FALSE,
                                level = 0.95, nboot = 1000,
                                min_pboot = 0.99,
                                parametric = TRUE,
                                ...) {
  chk_unused(...)
  ssd_hc(object,
    percent = percent, ci = ci, level = level,
    nboot = nboot, min_pboot = min_pboot,
    parametric = parametric
  )
}
