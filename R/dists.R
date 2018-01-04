#' Distribution Names
#'
#' Returns a sorted character vector of the recognized distribution names.
#'
#' @param all A flag indicating whether to return all the distribution names.
#' @return A sorted character vector of the distribution names.
#' @export
#'
#' @examples
#' ssd_dists()
#' ssd_dists(all = TRUE)
ssd_dists <- function(all = FALSE) {
  check_flag(all)
  if(!all) {
    return(c("gamma", "gompertz", "lgumbel",
             "llog", "lnorm", "weibull"))
  }
  return(c("burr", "gamma", "gompertz", "lgumbel",
           "llog", "lnorm", "pareto", "weibull"))
}
