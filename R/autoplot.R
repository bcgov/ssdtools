#' @export
autoplot.fitdist <- function(object, ci = FALSE, hc5 = FALSE, log_x = TRUE,
                             xlab = "Concentration", ylab = "Distribution (%)",
                             ...) {
  check_flag(ci)
  check_flag(hc5)
  check_flag(log_x)
  check_string(xlab)
  check_string(ylab)

  data <- predict(object, nboot = if(ci) 1001 else 10)

  gp <- ggplot(data, aes_string(x = "est"))

  if(ci) gp <- gp + geom_xribbon(aes_string(xmin = "lcl", xmax = "ucl", y = "prob"), alpha = 0.3)

  gp <- gp + geom_line(aes_string(y = "prob")) +
    geom_ssd(data = data.frame(x = object$data), aes_string(x = "x")) +
    scale_y_continuous(labels = percent, limits = c(0, 1),
                       breaks = seq(0,1,by = 0.25), expand = c(0,0)) +
    xlab(xlab) +
    ylab(ylab)

  if(log_x) {
    if(hc5) gp <- gp + geom_loghline(yintercept = 0.05, linetype = "dotted")
    gp <- gp + coord_trans(x = "log10") +
      scale_x_continuous(breaks = scales::trans_breaks("log10", function(x) 10^x),
                         labels = comma_round)
  } else {
    if(hc5) gp <- gp + geom_hline(yintercept = 0.05, linetype = "dotted")
    # range <- c(first(data$lcl), last(data$ucl))
    gp <- gp + scale_x_continuous(labels = scales::comma)
  }
  gp
}

