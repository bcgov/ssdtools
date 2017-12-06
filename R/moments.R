#' Calculate Moments
#'
#' Calculates the min, max, median and unbiased estimates of the first four moments.
#'
#' @param x A numeric vector.
#' @return A tbl data frame with 1 row and the columns min, max, median, mean, sd, skewness, kurtosis.
#' @seealso \code{\link[fitdistrplus]{descdist}}
#' @export
#'
#' @examples
#' ssd_moments(ccme_data$Conc[ccme_data$Chemical == "Cadmium"])
ssd_moments <- function(x) {
  x %<>% fitdistrplus::descdist(graph = FALSE)
  attr(x, "class") <- NULL
  x %<>% tibble::as_tibble()
  x$method <- NULL
  x
}
