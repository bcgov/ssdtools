dist <- function(x, ...) UseMethod("dist")

#' @export
dist.tmbfit <- function(x, ...) {
  chk_unused(...)
  .dist_tmbfit(x)
}
