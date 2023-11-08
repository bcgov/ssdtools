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

#' BCANZ Distributions
#'
#' Gets a character vector of the names of the distributions
#' adopted by BC, Canada, Australia and New Zealand for official guidelines.
#'
#' @return A unique, sorted character vector of the distributions.
#' @seealso [`ssd_dists()`]
#' @family dists BCANZ
#' @export
#'
#' @examples
#' ssd_dists_bcanz()
ssd_dists_bcanz <- function() {
  ssd_dists(bcanz = TRUE)
}

#' Fit BCANZ Distributions
#'
#' Fits distributions using settings adopted by
#' BC, Canada, Australia and New Zealand for official guidelines.
#'
#' @inheritParams params
#' @return An object of class fitdists.
#' @seealso [`ssd_fit_dists()`]
#' @family BCANZ
#' @export
#' @examples
#' ssd_fit_bcanz(ssddata::ccme_boron)
ssd_fit_bcanz <- function(data, left = "Conc") {
  ssd_fit_dists(data,
    left = left,
    dists = ssd_dists_bcanz(),
    nrow = 6L,
    rescale = TRUE,
    reweight = FALSE,
    computable = TRUE,
    at_boundary_ok = FALSE,
    min_pmix = 0
  )
}

#' BCANZ Hazard Concentrations
#'
#' Gets hazard concentrations with confidence intervals that protect
#' 1, 5, 10 and 20% of species using settings adopted by
#' BC, Canada, Australia and New Zealand for official guidelines.
#' This function can take several minutes to run with required 10,000 iterations.
#'
#' @inheritParams params
#' @return A tibble of corresponding hazard concentrations.
#' @seealso [`ssd_hc()`].
#' @family BCANZ
#' @export
#' @examples
#' fits <- ssd_fit_bcanz(ssddata::ccme_boron)
#' ssd_hc_bcanz(fits, nboot = 100)
ssd_hc_bcanz <- function(x, nboot = 10000, delta = 10, min_pboot = 0.9) {
  ssd_hc(x,
    percent = c(1, 5, 10, 20),
    ci = TRUE,
    level = 0.95,
    nboot = nboot,
    average = TRUE,
    delta = delta,
    min_pboot = min_pboot,
    parametric = TRUE
  )
}
