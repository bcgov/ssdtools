#' @importFrom universals estimates
#' @export
universals::estimates

#' @export
estimates.tmbfit <- function(x, all = FALSE, ...) {
  x <- tidy(x, all = all)
  names <- as.character(x$term)
  x <- as.list(x$est)
  names(x) <- names
  x
}
