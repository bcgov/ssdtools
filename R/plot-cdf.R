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

#' Plot Cumulative Distribution Function (CDF)
#'
#' Generic function to plots the cumulative distribution function (CDF).
#'
#' @inheritParams params
#' @seealso [ssd_plot()]
#' @export
ssd_plot_cdf <- function(x, ...) {
  UseMethod("ssd_plot_cdf")
}

#' @describeIn ssd_plot_cdf Plot CDF for fitdists object
#' @inheritParams params
#' @param ... Additional arguments passed to [ssd_plot()].
#' @export
#' @examples
#' ssd_plot_cdf(boron_dists)
ssd_plot_cdf.fitdists <- function(x, average = FALSE, ...) {
  data <- ssd_data(x)
  pred <- ssd_hc(x, average = average, percent = 1:99)
  cols <- .cols_fitdists(x)
  
  linetype <- if(length(unique(pred$dist)) > 1) "dist" else NULL
  linecolor <- linetype
  pred$percent <- round(pred$percent) # not sure why needed
  ssd_plot(data = data, pred = pred, left = cols$left, right = cols$right,
           ci = FALSE, hc = NULL, linetype = linetype, linecolor = linecolor, ...) +
    labs(linetype = "Distribution", color = "Distribution")
}

#' @describeIn ssd_plot_cdf Plot CDF for named list of distributional parameter values
#' @inheritParams params
#' @param ... Unused.
#' @export
#' @examples
#' 
#' ssd_plot_cdf(list(
#'   llogis = c(locationlog = 2, scalelog = 1),
#'   lnorm = c(meanlog = 2, sdlog = 2))
#' )
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