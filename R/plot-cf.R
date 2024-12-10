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

#' Cullen and Frey Plot
#' `r lifecycle::badge('deprecated')`
#'
#' Plots a Cullen and Frey graph of the skewness and kurtosis
#' for non-censored data.
#'
#' Deprecated for [fitdistrplus::descdist()].
#'
#' @inheritParams ssd_fit_dists
#' @export
ssd_plot_cf <- function(data, left = "Conc") {
  lifecycle::deprecate_stop("0.3.5", "ssd_plot_cf()", "fitdistrplus::descdist()",
    details = "Please use fitdistrplus::descdist(data$Conc, boot = 100L)."
  )
}
