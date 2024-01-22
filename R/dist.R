dist <- function(x, ...) UseMethod("dist")

#' @export
dist.tmbfit <- function(x, ...) {
  .dist_tmbfit(x)
}
