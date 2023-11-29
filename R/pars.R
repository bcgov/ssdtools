pars_fitdists <- function(x) {
  purrr::map(x, .pars_tmbfit)
}
