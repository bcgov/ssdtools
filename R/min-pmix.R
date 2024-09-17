#' Calculate Minimum Proportion in Mixture Models
#'
#' @inheritParams params
#'
#' @return A number between 0 and 0.5 of the minimum proportion in mixture models.
#' @seealso [ssd_fit_dists()]
#' @export
#'
#' @examples
#' ssd_min_pmix(6)
#' ssd_min_pmix(50)
ssd_min_pmix <- function(n) {
  chk_whole_number(n)
  chk_gt(n)
  max(min(3 / n, 0.5), 0.1)
}
