#' @importFrom universals npars
#' @export
universals::npars

#' @export
npars.fitdist <- function(x, ...) length(x$estimate)

#' @export
npars.fitdistcens <- function(x, ...) length(x$estimate)

#' @export
npars.fitdists <- function(x, ...) {
  x <- vapply(x, npars, 1L)
  x <- x[order(names(x))]
  x
}

#' @export
npars.tmbfit <- function(x, ...) length(x$model$par)