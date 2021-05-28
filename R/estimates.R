#' @importFrom universals estimates
#' @export
universals::estimates

#' @export
estimates.tmbfit <- function(x, all = FALSE, ...) {
  x <- tidy(x, all = all)
  names <- x$term
  x <- as.list(x$est)
  names(x) <- names
  x
}

#' @export
estimates.fitdists <- function(x, all = FALSE, ...) {
  y <- lapply(x, estimates, all = all)
  names(y) <- names(x)
  y
}

