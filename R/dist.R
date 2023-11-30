dist <- function(x, ...) UseMethod("dist")

dist.tmbfit <- function(x, ...) {
  .dist_tmbfit(x)
}
