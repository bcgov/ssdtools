#' @export
logLik.tmbfit <- function(object, ...) {
  object$optim$objective
}

#' @export
logLik.fitdists <- function(object, ...) {
  object <- vapply(object, logLik, 1)
  object <- object[order(names(object))]
  object
}
