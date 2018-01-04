remove_errors <- function(dist_fit, name, silent) {
  if(!is.null(dist_fit$error)) {
    if(!silent) warning(name, ": ", dist_fit$error, call. = FALSE)
    return(NULL)
  }
  dist_fit$result
}

#' Fit Distributions
#'
#' By default fits xx distributions.
#'
#' @param x A numeric vector of the data.
#' @param dists A character vector of the distributions to fit.
#' @param silent A flag indicating whether fits should fail without issuing errors.
#' @return An object of class fitdists.
#'
#' @export
#' @examples
#' ssd_fit_dists(ccme_data$Conc[ccme_data$Chemical == "Boron"])
ssd_fit_dists <- function(x, dists = c("lnorm", "llog", "gompertz", "lgumbel", "gamma", "weibull"), silent = FALSE) {
  check_vector(x, 1)
  check_dists(dists)

  safe_fit_dist <- safely(ssd_fit_dist)
  names(dists) <- dists
  dists %<>% map(safe_fit_dist, x = x)
  dists %<>% imap(remove_errors, silent = silent)
  dists <- dists[!vapply(dists, is.null, TRUE)]
  class(dists) <- "fitdists"
  dists
}
