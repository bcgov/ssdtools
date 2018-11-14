as_conditional_tibble <- function(x) {
  if(requireNamespace("tibble", quietly = TRUE))
    x <- tibble::as_tibble(x)
  x
}

safely <- function(.f) {
  function(...) {
    x <- try(.f(...), silent = TRUE)
    if(inherits(x, "try-error")) return(list(result = NULL, error = as.character(x)))
    list(result = x, error = NULL)
  }
}
