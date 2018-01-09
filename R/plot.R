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

#' SSD Plot
#' @inheritParams autoplot.fitdist
#' @param data A data frame.
#' @param pred A data frame of the predictions.
#' @param conc A string of the column in data with the concentrations.
#' @param label A string of the column in data with the labels.
#' @param shape A string of the column in data for the shape aesthetic.
#' @export
#' @examples
#' ssd_plot(boron_data, boron_pred, label = "Species", shape = "Group")
ssd_plot <- function(data, pred, conc = "Concentration",
                     label = NULL, shape = NULL,
                     xlab = "Concentration", ylab = "Percent of Species Affected",
                     ci = TRUE, hc5 = TRUE) {
  check_data(data)
  check_data(pred,
             values = list(
               prob = c(0,1),
               est = 1,
               lcl = 1,
               ucl = 1))

  check_string(conc)
  checkor(check_string(label), check_null(label))
  checkor(check_string(shape), check_null(shape))
  check_flag(ci)
  check_flag(hc5)

  check_colnames(data, conc)

  gp <- ggplot(pred, aes_string(x = "est"))

  if(ci) gp <- gp + geom_xribbon(aes_string(xmin = "lcl", xmax = "ucl", y = "prob"), alpha = 0.3)

  gp <- gp +  geom_line(aes_string(y = "prob")) +
    geom_ssd(data = data, aes_string(x = conc, shape = shape)) +
    plot_coord_scale(data, xlab = xlab, ylab = ylab)
  gp
}
