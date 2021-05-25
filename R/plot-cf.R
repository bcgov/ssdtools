#    Copyright 2015 Province of British Columbia
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
#' @inheritParams ssd_fit_dists
#' @seealso [fitdistrplus::descdist()]
#' @export
#'
#' @examples
#' ssd_plot_cf(boron_data)
ssd_plot_cf <- function(data, left = "Conc") {
  deprecate_soft("0.3.5", "ssd_plot_cf()", "fitdistrplus::descdist()",
                 details = "Please use fitdistrplus::descdist(data$Conc, boot = 100L).")
  
  chk_s3_class(data, "data.frame")
  chk_string(left)
  chk_superset(colnames(data), left)

  fitdistrplus::descdist(data[[left]], boot = 100L)
  invisible()
}

#' @describeIn ssd_plot_cf Deprecated Cullen and Frey Plot
#' @export
ssd_cfplot <- function(data, left = "Conc") {
  deprecate_soft("0.1.0", "ssd_cfplot()", "ssd_plot_cf()")
  ssd_plot_cf(data, left)
}

