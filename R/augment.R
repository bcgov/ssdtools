#' @importFrom generics augment
#' @export
generics::augment

#' Construct a single row tibble::tibble() "glance" of a tmbfit model.
#' 
#' @param x A tmbfit object to be converted into a single row tibble::tibble.
#' @param ... Unused.
#'  
#' @export
augment.tmbfit <- function(x, ...) {
  dist <- .dist_tmbfit(x)
  data <- .data_tmbfit(x)
  data
}
