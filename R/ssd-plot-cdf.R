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

#' Plot Cumulative Distribution Function
#' 
#' Plots the cdf.
#'
#' @param object The object to plot.
#' @param ci A flag indicating whether to plot confidence intervals
#' @param hc A count between 1 and 99 indicating the percent hazard concentration to plot (or NULL).
#' @param xlab A string of the x-axis label.
#' @param ylab A string of the x-axis label.
#' @param ic A string of the information-theoretic criterion to use.
#' @param ... Unused.
#' @export
ssd_plot_cdf <- function(object, ...) {
  UseMethod("ssd_plot_cdf")
}

#' @describeIn ssd_plot_cdf Plot CDF fitdist
#' @export
#' @examples
#' ssd_plot_cdf(boron_lnorm)
ssd_plot_cdf.fitdist <- function(object, ci = FALSE, hc = 5L,
                             xlab = "Concentration", ylab = "Species Affected",
                             ...) {
  chk_flag(ci)
  if(!is.null(hc)) {
    chk_number(hc)
    chk_range(hc, c(1, 99))
  }
  chk_string(xlab)
  chk_string(ylab)
  chk_unused(...)
  
  data <- data.frame(x = object$data)
  
  pred <- predict(object, nboot = if (ci) 1001 else 10)
  
  gp <- ggplot(pred, aes_string(x = "est"))
  
  if (ci) gp <- gp + geom_xribbon(aes_string(xmin = "lcl", xmax = "ucl", y = "percent"), alpha = 0.3)
  
  gp <- gp + geom_line(aes_string(y = "percent")) +
    geom_ssd(data = data, aes_string(x = "x")) +
    plot_coord_scale(data, xlab = xlab, ylab = ylab)
  
  if (!is.null(hc)) gp <- gp + geom_hcintersect(xintercept = pred$est[pred$percent == hc], yintercept = hc / 100, linetype = "dotted")
  gp
}

#' @describeIn ssd_plot_cdf Plot CDF fitdistcens
#' @export
#' @examples
#' fluazinam_lnorm$censdata$right[3] <- fluazinam_lnorm$censdata$left[3] * 1.5
#' fluazinam_lnorm$censdata$left[5] <- NA
#' ssd_plot_cdf(fluazinam_lnorm)
ssd_plot_cdf.fitdistcens <- function(object, ci = FALSE, hc = 5L,
                                 xlab = "Concentration", ylab = "Species Affected",
                                 ...) {
  chk_flag(ci)
  if(!is.null(hc)) {
    chk_number(hc)
    chk_range(hc, c(1, 99))
  }
  chk_string(xlab)
  chk_string(ylab)
  chk_unused(...)
  
  data <- object$censdata
  
  data$xmin <- pmin(data$left, data$right, na.rm = TRUE)
  data$xmax <- pmax(data$left, data$right, na.rm = TRUE)
  data$xmean <- rowMeans(data[c("left", "right")], na.rm = TRUE)
  data$arrowleft <- data$right / 2
  data$arrowright <- data$left * 2
  data$y <- ssd_ecd(data$xmean)
  
  pred <- predict(object, nboot = if (ci) 1001 else 10)
  
  gp <- ggplot(pred, aes_string(x = "est"))
  
  if (ci) gp <- gp + geom_xribbon(aes_string(xmin = "lcl", xmax = "ucl", y = "percent"), alpha = 0.3)
  
  arrow <- arrow(length = unit(0.1, "inches"))
  
  gp <- gp + geom_line(aes_string(y = "percent")) +
    geom_segment(
      data = data[data$xmin != data$xmax, ],
      aes_string(x = "xmin", xend = "xmax", y = "y", yend = "y")
    ) +
    geom_segment(
      data = data[is.na(data$left), ],
      aes_string(x = "right", xend = "arrowleft", y = "y", yend = "y"),
      arrow = arrow
    ) +
    geom_segment(
      data = data[is.na(data$right), ],
      aes_string(x = "left", xend = "arrowright", y = "y", yend = "y"),
      arrow = arrow
    ) +
    geom_point(data = data, aes_string(x = "xmin", y = "y")) +
    geom_point(
      data = data[data$xmin != data$xmax, ],
      aes_string(x = "xmax", y = "y")
    ) +
    plot_coord_scale(data, xlab = xlab, ylab = ylab)
  
  if (!is.null(hc)) gp <- gp + geom_hcintersect(xintercept = pred$est[pred$percent == hc], yintercept = hc / 100, linetype = "dotted")
  gp
}

#' @describeIn ssd_plot_cdf Plot CDF fitdists
#' @export
#' @examples
#' ssd_plot_cdf(boron_dists)
ssd_plot_cdf.fitdists <- function(object, xlab = "Concentration", ylab = "Species Affected", ic = "aicc", ...) {
  chk_string(xlab)
  chk_string(ylab)

  pred <- predict(object, ic = ic, nboot = 10, average = FALSE)
  pred$Distribution <- pred$dist
  
  data <- data.frame(x = object[[1]]$data)
  
  gp <- ggplot(pred, aes_string(x = "est")) +
    geom_line(aes_string(
      y = "percent/100", color = "Distribution",
      linetype = "Distribution"
    )) +
    geom_ssd(data = data, aes_string(x = "x")) +
    plot_coord_scale(data, xlab = xlab, ylab = ylab)
  
  gp
}

#' @describeIn ssd_plot_cdf Plot CDF fitdistscens
#' @export
ssd_plot_cdf.fitdistscens <- function(object, xlab = "Concentration", ylab = "Species Affected",
                                  ic = "aic", ...) {
  chk_string(ic)
  chk_subset(ic, c("aic", "bic"))
  
  NextMethod(object = object, xlab = xlab, ylab = ylab, ic = ic, ...)
}
