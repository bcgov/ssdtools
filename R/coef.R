#' @export
coef.fitdists <- function(object, ...) {
  coef <- lapply(object, coef, ...)
  coef
}
