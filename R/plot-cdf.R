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

#' Plot Cumulative Distribution Function (CDF)
#'
#' Generic function to plots the cumulative distribution function (CDF).
#'
#' @inheritParams params
#' @seealso [`ssd_plot()`]
#' @export
ssd_plot_cdf <- function(x, ...) {
  UseMethod("ssd_plot_cdf")
}

#' @describeIn ssd_plot_cdf Plot CDF for fitdists object
#' @inheritParams params
#' @param ... Additional arguments passed to [ssd_plot()].
#' @export
#' @examples
#' fits <- ssd_fit_dists(ssddata::ccme_boron)
#' ssd_plot_cdf(fits)
ssd_plot_cdf.fitdists <- function(x, average = FALSE, delta = 7, ...) {
  pred <- ssd_hc(x, percent = 1:99, average = average, delta = delta)
  data <- ssd_data(x)
  cols <- .cols_fitdists(x)

  linetype <- if (length(unique(pred$dist)) > 1) "dist" else NULL
  linecolor <- linetype
  pred$percent <- round(pred$percent) # not sure why needed

  ssd_plot(
    data = data, pred = pred, left = cols$left, right = cols$right,
    ci = FALSE, hc = NULL, linetype = linetype, linecolor = linecolor, ...
  ) +
    labs(linetype = "Distribution", color = "Distribution")
}

#' @describeIn ssd_plot_cdf Plot CDF for named list of distributional parameter values
#' @inheritParams params
#' @export
#' @seealso [`estimates.fitdists()`] and [`ssd_match_moments()`]
#' @examples
#'
#' ssd_plot_cdf(list(
#'   llogis = c(locationlog = 2, scalelog = 1),
#'   lnorm = c(meanlog = 2, sdlog = 2)
#' ))
ssd_plot_cdf.list <- function(x, ...) {
  pred <- ssd_hc(x, percent = 1:99)
  data <- data.frame(Conc = numeric(0))

  linetype <- if (length(unique(pred$dist)) > 1) "dist" else NULL
  linecolor <- linetype
  pred$percent <- round(pred$percent) # not sure why needed

  ssd_plot(
    data = data, pred = pred,
    ci = FALSE, hc = NULL, linetype = linetype, linecolor = linecolor, ...
  ) +
    labs(color = "Distribution", linetype = "Distribution")
}
