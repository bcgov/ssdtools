#' Estimate Methods for SSDs
#'
#' Returns a character vector of the available non-deprecated
#' methods for getting the model averaged estimates for two or more
#' distributions.
#' 
#' @returns A character vector of the available methods.
#' @keywords internal
#' @export
#'
#' @examples
#' ssd_est_methods()
ssd_est_methods <- function() {
  c("arithmetic", "geometric", "multi")
}
