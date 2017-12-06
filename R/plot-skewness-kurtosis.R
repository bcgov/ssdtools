#' Plot Skewness-Kurtosis Graph
#'
#' Plots a skewness-kurtosis graph similar to the one proposed by Cullen and Frey with 100 bootstrapped values.
#' @param x A numeric vector.
#' @return An invisible TRUE.
#' @seealso \code{\link[fitdistrplus]{descdist}}
#' @export
#'
#' @examples
#' ssd_plot_skewness_kurtosis(ccme_data$Conc[ccme_data$Chemical == "Cadmium"])
ssd_plot_skewness_kurtosis <- function(x) {
  x %<>% fitdistrplus::descdist(boot=100L)
  invisible(TRUE)
}
