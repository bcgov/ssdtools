#' Log-Gumbel Distribution
#'
#' Density, distribution function, quantile function and random generation
#' for the log-Gumbel distribution with scale and location parameters
#' equal to \code{scale} and \code{location}, respectively.
#'
#' @param x,q	vector of quantiles.
#' @param p	vector of probabilities.
#' @param n	number of observations.
#' @param scale	scale parameter.
#' @param location location parameter.
#' @param log,log.p logical; if TRUE, probabilities p are given as log(p).
#' @param lower.tail	logical; if TRUE (default), probabilities are P[X <= x],otherwise, P[X > x].
#' @return
#' dlgumbel gives the density, plgumbel gives the distribution function,
#' qlgumbel gives the quantile function, and rlgumbel generates random deviates.
#' @name lgumbel
#' @examples
#' x <- rlgumbel(1000,1,0.1)
#' hist(log(x),freq=FALSE,col='gray',border='white')
#' hist(x,freq=FALSE,col='gray',border='white')
#' curve(dlgumbel(x,1,0.1),add=TRUE,col='red4',lwd=2)
NULL

#' @rdname lgumbel
#' @export
dlgumbel <- function(x, location = 0, scale = 0, log = FALSE){
  x %<>% log()
  fx <- 1/scale * exp(-(x - location)/scale - exp(-(x - location)/scale))
  if (log) return(log(fx))
  fx
}

#' @rdname lgumbel
#' @export
qlgumbel <- function(p, location = 0, scale = 0, lower.tail = TRUE, log.p = FALSE){
  if (log.p) p %<>% exp()
  if (!lower.tail) p <- 1 - p
  xF <- location - scale * log(-log(p))
  exp(xF)
}

#' @rdname lgumbel
#' @export
plgumbel <- function(q, location = 0, scale = 0, lower.tail = TRUE, log.p = FALSE){
  q %<>% log()
  Fx <- exp(-exp(-(q - location)/scale))
  if (!lower.tail) Fx <- 1 - Fx
  if (log.p) Fx %<>% log()
  Fx
}

#' @rdname lgumbel
#' @export
rlgumbel <- function(n, location = 0, scale = 0){
  qlgumbel(stats::runif(n), location = location, scale = scale)
}
