#' Calculate Moments
#'
#' A wrapper on \code{\link[fitdistrplus]{descdist}}.
#'
#' @param x A numeric vector.
#' @return A tbl data frame of the min, max, median, mean and unbiased estimates of the first four moments.
#' @export
#'
#' @examples
#' ssd_moments(ccme_data$Conc)
ssd_moments <- function(x) {
  checkor(check_vector(x, 1), check_vector(x, 1L))

  x %<>% fitdistrplus::descdist(graph = FALSE)
  attr(x, "class") <- NULL
  x %<>% tibble::as_tibble()
  x$method <- NULL
  x
}
