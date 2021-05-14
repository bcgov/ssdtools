#' Create a \code{TMB::ADFun} object for the normal likelihood.
#'
#' @param x Vector of observations.
#' @return A list as returned by \code{TMB::MakeADFun} representing the negative loglikelihood of a univariate normal.
#' @export
norm_ADFun <- function(x) {
  TMB::MakeADFun(data = list(model = "NormalNLL", x = x),
                 parameters = list(mu = 0, sigma = 1),
                 DLL = "ssdtools_TMBExports", silent = TRUE)
}
