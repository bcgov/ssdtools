as_conditional_tibble <- function(x) {
  if(requireNamespace("tibble", quietly = TRUE))
    x <- tibble::as_tibble(x)
  x
}