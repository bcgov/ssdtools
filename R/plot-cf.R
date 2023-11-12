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

#' Cullen and Frey Plot
#'
#' Plots a Cullen and Frey graph of the skewness and kurtosis
#' for non-censored data.
#'
#' Soft deprecated for direct call to [fitdistrplus::descdist()].
#'
#' @inheritParams ssd_fit_dists
#' @export
#'
#' @examples
#' ssd_plot_cf(ssddata::ccme_boron)
ssd_plot_cf <- function(data, left = "Conc") {
  if (!requireNamespace("fitdistrplus", quietly = TRUE)) {
    err("Package 'fitdistrplus' is required to produce Cullen and Frey plots.")
  }

  lifecycle::deprecate_warn("0.3.5", "ssd_plot_cf()", "fitdistrplus::descdist()",
    details = "Please use fitdistrplus::descdist(data$Conc, boot = 100L)."
  )

  chk_s3_class(data, "data.frame")
  chk_string(left)
  chk_superset(colnames(data), left)

  fitdistrplus::descdist(data[[left]], boot = 100L)
  invisible()
}
