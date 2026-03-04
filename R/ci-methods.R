#' Confidence Interval Methods for SSDs
#'
#' Returns a character vector of the available non-deprecated
#' methods for getting the model averaged confidence limits for two or more
#' distributions.
#'
#' @returns A character vector of the available methods.
#' @keywords internal
#' @export
#'
#' @examples
#' ssd_ci_methods()
ssd_ci_methods <- function() {
  sort(c(
    "MACL", "GMACL", "MAW1", "MAW2", "GMAW1", "GMAW2",
    "multi_fixed", "multi_free", "arithmetic_samples", "geometric_samples", "weighted_samples"
  ))
  ## TODO: add "MATA" method?
}
