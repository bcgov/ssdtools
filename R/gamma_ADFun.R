#' Create a \code{TMB::ADFun} object for the gamma likelihood.
#'
#' @param x Vector of observations.
#' @return A list as returned by \code{TMB::MakeADFun} representing the negative loglikelihood of a gamma distribution.
#' @export
gamma_ADFun <- function(x) {
  TMB::MakeADFun(data = list(model = "GammaNLL", x = x),
                 parameters = list(alpha = 1, beta = 1),
                 DLL = "TMBTest3_TMBExports", silent = TRUE)
}
