#' @importFrom stats logLik
#' @export
stats::logLik

#' @export
logLik.tmbfit <- function(object, ...) {
  .objective_tmbfit(object) * -1
}

#' @export
logLik.fitdists <- function(object, ...) {
  object <- vapply(object, logLik, 1)
  object <- object[order(names(object))]
  object
}
