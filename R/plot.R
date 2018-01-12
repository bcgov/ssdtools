#    Copyright 2015 Province of British Columbia
#
#    Licensed under the Apache License, Version 2.0 (the "License");
#    you may not use this file except in compliance with the License.
#    You may obtain a copy of the License at
#
#       http://www.apache.org/licenses/LICENSE-2.0
#
#    Unless required by applicable law or agreed to in writing, software
#    distributed under the License is distributed on an "AS IS" BASIS,
#    WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
#    See the License for the specific language governing permissions and
#    limitations under the License.

plot_fitdist <- function(x, breaks = "default", ...) {
  par(oma=c(0,0,2,0))
  plot(x, breaks = breaks, ...)
  title(paste("Distribution:", x$distname), outer = TRUE)
}

#' @export
plot.fitdists <- function(x, breaks = "default", ...) {
  walk(x, plot_fitdist, breaks = breaks, ...)
  invisible()
}

#' Autoplot
#'
#' @param object The object to plot.
#' @param ci A flag indicating wether to plot confidence intervals
#' @param hc5 A flag indicating whether to plot the HC5.
#' @param xlab A string of the x-axis label.
#' @param ylab A string of the x-axis label.
#' @param ... Unused.
#' @export
#' @examples
#' autoplot(boron_lnorm)
autoplot.fitdist <- function(object, ci = FALSE, hc5 = TRUE,
                             xlab = "Concentration", ylab = "Species Affected",
                             ...) {
  check_flag(ci)
  check_flag(hc5)
  check_string(xlab)
  check_string(ylab)

  data <- data.frame(x = object$data)

  pred <- predict(object, nboot = if(ci) 1001 else 10)

  gp <- ggplot(pred, aes_string(x = "est"))

  if(ci) gp <- gp + geom_xribbon(aes_string(xmin = "lcl", xmax = "ucl", y = "prop"), alpha = 0.3)

  gp <- gp + geom_line(aes_string(y = "prop")) +
    geom_ssd(data = data, aes_string(x = "x")) +
    plot_coord_scale(data, xlab = xlab, ylab = ylab)

  if(hc5) gp <- gp + geom_hc5(xintercept = pred$est[pred$prop == 0.05], linetype = "dotted")
  gp
}

#' Autoplot
#'
#' @inheritParams autoplot.fitdist
#' @export
#' @examples
#' \dontrun{
#' autoplot(boron_dists)
#' }
autoplot.fitdists <- function(object, xlab = "Concentration", ylab = "Species Affected", ...) {
  check_string(xlab)
  check_string(ylab)

  pred <- predict(object, nboot = 10, average = FALSE)
  pred$Distribution <- pred$dist

  data <- data.frame(x = object[[1]]$data)

  gp <- ggplot(pred, aes_string(x = "est")) +
    geom_line(aes_string(y = "prop", color = "Distribution",
                         linetype = "Distribution")) +
    geom_ssd(data = data, aes_string(x = "x")) +
    plot_coord_scale(data, xlab = xlab, ylab = ylab)

  gp
}

#' SSD Plot
#' @inheritParams autoplot.fitdist
#' @param data A data frame.
#' @param pred A data frame of the predictions.
#' @param left A string of the column in data with the concentrations.
#' @param label A string of the column in data with the labels.
#' @param shape A string of the column in data for the shape aesthetic.
#' @param color A string of the column in data for the color aesthetic.
#' @param size A number for the size of the labels.
#' @param shift_x The value to multiply the label x values by.
#' @export
#' @examples
#' ssd_plot(boron_data, boron_pred, label = "Species", shape = "Group")
ssd_plot <- function(data, pred, left = "Conc",
                     label = NULL, shape = NULL, color = NULL, size = 2.5,
                     xlab = "Concentration", ylab = "Percent of Species Affected",
                     ci = TRUE, hc5 = TRUE, shift_x = 3) {
  check_data(data)
  check_data(pred,
             values = list(
               prop = c(0,1),
               est = 1,
               lcl = 1,
               ucl = 1))

  check_vector(shift_x, values = c(1, 1000))

  check_string(left)
  checkor(check_string(label), check_null(label))
  checkor(check_string(shape), check_null(shape))
  check_flag(ci)
  check_flag(hc5)

  check_colnames(data, left)

  gp <- ggplot(pred, aes_string(x = "est"))

  if(ci) gp <- gp + geom_xribbon(aes_string(xmin = "lcl", xmax = "ucl", y = "prop"), alpha = 0.2)

  if(!is.null(label)) {
    check_colnames(data, label)
    data <- data[order(data[[label]]),]
  }
  gp <- gp + geom_line(aes_string(y = "prop")) +
    geom_hc5(data = data, xintercept = pred$est[pred$prop == 0.05]) +
    geom_ssd(data = data, aes_string(x = left, shape = shape, color = color)) +
    plot_coord_scale(data, xlab = xlab, ylab = ylab)

  if(!is.null(label)) {
    data$prop <- ssd_ecd(data[[left]])
    data[[left]] %<>% magrittr::multiply_by(shift_x)
    gp <- gp + geom_text(data = data, aes_string(x = left, y = "prop", label = label),
                         color = "grey50", hjust = 0, size = size)
  }

  gp
}

#' Cullen and Frey Plot
#'
#' Plots a Cullen and Frey graph of the skewness and kurtosis
#'
#' @inheritParams ssd_fit_dist
#' @seealso \code{\link[fitdistrplus]{descdist}}
#' @export
#'
#' @examples
#' ssd_cfplot(boron_data)
ssd_cfplot <- function(data, left = "Conc") {
  check_data(data)
  check_string(left)
  check_colnames(data, left)

  fitdistrplus::descdist(data[[left]], boot = 100L)
  invisible()
}
