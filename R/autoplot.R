#' Autoplot
#'
#' @param object The object to plot.
#' @param ci A flag indicating wether to plot confidence intervals
#' @param hc5 A flag indicating whether to plot the HC5 (not yet implemented)
#' @param xlab A string of the x-axis label.
#' @param ylab A string of the x-axis label.
#' @param ... Unused.
#' @export
autoplot.fitdist <- function(object, ci = FALSE, hc5 = FALSE,
                             xlab = "Concentration", ylab = "Density",
                             ...) {
  check_flag(ci)
  check_flag(hc5)
  check_string(xlab)
  check_string(ylab)

  data <- predict(object, nboot = if(ci) 1001 else 10)

  gp <- ggplot(data, aes_string(x = "est"))

  if(ci) gp <- gp + geom_xribbon(aes_string(xmin = "lcl", xmax = "ucl", y = "prob"), alpha = 0.3)

  gp <- gp + geom_line(aes_string(y = "prob")) +
    coord_trans(x = "log10") +
    geom_ssd(data = data.frame(x = object$data), aes_string(x = "x")) +
    scale_x_continuous(breaks = scales::trans_breaks("log10", function(x) 10^x),
                       labels = comma_signif) +
    scale_y_continuous(labels = percent, limits = c(0, 1),
                       breaks = seq(0,1,by = 0.25), expand = c(0,0)) +
    xlab(xlab) +
    ylab(ylab)

  if(hc5) gp <- gp + geom_loghline(yintercept = 0.05, linetype = "dotted")
  gp
}

#' Autoplot
#'
#' @inheritParams autoplot.fitdist
#' @export
autoplot.fitdists <- function(object, xlab = "Concentration", ylab = "Density", ...) {
  check_string(xlab)
  check_string(ylab)

  data <- predict(object, nboot = 10, average = FALSE)
  data$Distribution <- data$dist

  gp <- ggplot(data, aes_string(x = "est")) +
    coord_trans(x = "log10") +
    geom_line(aes_string(y = "prob", color = "Distribution",
                         linetype = "Distribution")) +
    geom_ssd(data = data.frame(x = object[[1]]$data), aes_string(x = "x")) +
    scale_x_continuous(breaks = scales::trans_breaks("log10", function(x) 10^x),
                       labels = comma_signif) +
    scale_y_continuous(labels = percent, limits = c(0, 1),
                       breaks = seq(0,1,by = 0.25), expand = c(0,0)) +
    xlab(xlab) +
    ylab(ylab)
  gp
}
