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
#' @param color A string of the column in data for the color aesthetic.
#' @param size A number for the size of the labels.
#' @param shift_x The value to multiply the label x values by.
#' @export
#' @examples
#' ssd_plot(boron_data, boron_pred, label = "Species", shape = "Group")
ssd_plot <- function(data, pred, conc = "Concentration",
                     label = NULL, shape = NULL, color = NULL, size = 2.5,
                     xlab = "Concentration", ylab = "Percent of Species Affected",
                     ci = TRUE, hc5 = TRUE, shift_x = 3) {
  check_data(data)
  check_data(pred,
             values = list(
               prob = c(0,1),
               est = 1,
               lcl = 1,
               ucl = 1))

  check_vector(shift_x, values = c(1, 1000))

  check_string(conc)
  checkor(check_string(label), check_null(label))
  checkor(check_string(shape), check_null(shape))
  check_flag(ci)
  check_flag(hc5)

  check_colnames(data, conc)

  gp <- ggplot(pred, aes_string(x = "est"))

  if(ci) gp <- gp + geom_xribbon(aes_string(xmin = "lcl", xmax = "ucl", y = "prob"), alpha = 0.2)


  gp <- gp +  geom_line(aes_string(y = "prob")) +
    geom_p5(data = data, xintercept = pred$est[pred$prob == 0.05]) +
    geom_ssd(data = data, aes_string(x = conc, shape = shape, color = color)) +
    plot_coord_scale(data, xlab = xlab, ylab = ylab)

  if(!is.null(label)) {
    data$prob <- ssd_ecd(data[[conc]])
    data[[conc]] %<>% magrittr::multiply_by(shift_x)
    gp <- gp + geom_text(data = data, aes_string(x = conc, y = "prob", label = label),
                         color = "grey50", hjust = 0, size = size)
  }

  gp
}
