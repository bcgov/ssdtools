#' @export
universals::npars

#' @export
npars.fitdists <- function(x, ...) {
  x <- vapply(x, npars, 1L)
  x <- x[order(names(x))]
  x
}

#' @export
npars.tmbfit <- function(x, ...) length(estimates(x))