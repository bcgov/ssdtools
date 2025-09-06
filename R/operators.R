#' @export
`[.fitdists` <- function(x, i) {
  attr <- attributes(x)
  x <- NextMethod()
  attr$names <- names(x)
  attributes(x) <- attr
  class(x) <- "fitdists"
  x
}

#' @export
`[[.fitdists` <- function(x, i) {
  x <- NextMethod()
  stopifnot(inherits(x, "tmbfit"))
  x
}
