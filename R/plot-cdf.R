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

#' Plot Cumulative Distribution Function
#'
#' Plots the cumulative distribution function (cdf).
#'
#' @inheritParams params
#' @export
ssd_plot_cdf <- function(x, ...) {
  UseMethod("ssd_plot_cdf")
}

#' @describeIn ssd_plot_cdf Plot list
#' @export
ssd_plot_cdf.list <- function(x,
                              xlab = "Concentration", ylab = "Species Affected",
                              ...) {
  chk_string(xlab)
  chk_string(ylab)
  chk_unused(...)
  
  pred <- ssd_hc(x, percent = 1:99)
  
  pred$Distribution <- pred$dist
  
  ggplot(pred, aes_string(x = "est")) +
    geom_line(aes_string(
      y = "percent/100", color = "Distribution",
      linetype = "Distribution"
    )) +
    plot_coord_scale(pred, xlab = xlab, ylab = ylab)
}

#' @describeIn ssd_plot_cdf Plot CDF fitdists
#' @export
ssd_plot_cdf.fitdists <- function(x, xlab = "Concentration", ylab = "Species Affected", ...) {
  chk_null_or(xlab, chk_string)
  chk_null_or(ylab, chk_string)
  
  pred <- ssd_hc(x, average = FALSE, percent = 1:99)
  pred$Distribution <- pred$dist
  
  data <- data.frame(x = .data_fitdists(x)$left * .rescale_fitdists(x))
  
  ggplot(pred, aes_string(x = "est")) +
    geom_line(aes_string(
      y = "percent/100", color = "Distribution",
      linetype = "Distribution"
    )) +
    geom_ssd(data = data, aes_string(x = "x")) +
    plot_coord_scale(data, xlab = xlab, ylab = ylab)
}
