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
#' library(ggplot2)
#' autoplot(boron_lnorm)
autoplot.fitdist <- function(object, ci = FALSE, hc5 = TRUE,
                             xlab = "Concentration", ylab = "Percent of Species Affected",
                             ...) {
  check_flag(ci)
  check_flag(hc5)
  check_string(xlab)
  check_string(ylab)

  data <- data.frame(x = object$data)

  pred <- predict(object, nboot = if(ci) 1001 else 10)

  gp <- ggplot(pred, aes_string(x = "est"))

  if(ci) gp <- gp + geom_xribbon(aes_string(xmin = "lcl", xmax = "ucl", y = "prob"), alpha = 0.3)

  gp <- gp + geom_line(aes_string(y = "prob")) +
    geom_ssd(data = data, aes_string(x = "x")) +
    plot_coord_scale(data, xlab = xlab, ylab = ylab)

  if(hc5) gp <- gp + geom_p5(xintercept = pred$est[pred$prob == 0.05], linetype = "dotted")
  gp
}

#' Autoplot
#'
#' @inheritParams autoplot.fitdist
#' @export
#' @examples
#' \dontrun{
#' library(ggplot2)
#' autoplot(boron_dists)
#' }
autoplot.fitdists <- function(object, xlab = "Concentration", ylab = "Percent of Species Affected", ...) {
  check_string(xlab)
  check_string(ylab)

  pred <- predict(object, nboot = 10, average = FALSE)
  pred$Distribution <- pred$dist

  data <- data.frame(x = object[[1]]$data)

  gp <- ggplot(pred, aes_string(x = "est")) +
    geom_line(aes_string(y = "prob", color = "Distribution",
                         linetype = "Distribution")) +
    geom_ssd(data = data, aes_string(x = "x")) +
    plot_coord_scale(data, xlab = xlab, ylab = ylab)

  gp
}
