#' Subset fitdists
#'
#' @param x The object to subset.
#' @param select A character vector of the distributions to select.
#' @param ... Unused
#' @export
#' @examples
#' subset(boron_dists, c("gamma", "weibull"))
subset.fitdists <- function(x, select = names(x), ...) {
  check_vector(select, "", unique = TRUE)
  check_names(x, select)
  class <- class(x)
  x <- x[names(x) %in% select]
  class(x) <- class
  x
}
