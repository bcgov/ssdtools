#' @export
print.fitdists <- function(x, ...) {
  walk(x, print)
}
