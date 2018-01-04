check_dists <- function(x, x_name = substitute(x)) {
  x_name %<>% deparse()
  check_vector(x, ssd_dists(all = TRUE), length = c(1,length(ssd_dists(all = TRUE))),
               unique = TRUE, named = FALSE)
}
