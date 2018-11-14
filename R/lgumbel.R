#    Copyright 2015 Province of British Columbia
#
#    Licensed under the Apache License, Version 2.0 (the "License");
#    you may not use this file except in compliance with the License.
#    You may obtain a copy of the License at
#
#       http://www.apache.org/licenses/LICENSE-2.0
#
#    Unless required by applicable law or agreed to in writing, software
#    distributed under the License is distributed on an "AS IS" BASIS,
#    WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
#    See the License for the specific language governing permissions and
#    limitations under the License.

#' Log-Gumbel Distribution
#'
#' Density, distribution function, quantile function and random generation
#' for the Log-Gumbel distribution with \code{scale} and \code{location} parameters.
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
  fx <- VGAM::dgumbel(log(x), location=location, scale=scale, log=FALSE)/x
  if(log) fx <- log(fx)
  fx
}

#' @rdname lgumbel
#' @export
qlgumbel <- function(p, location = 0, scale = 0, lower.tail = TRUE, log.p = FALSE){
  if(log.p) p<- exp(p)
  if(!lower.tail) p <- 1-p
  exp(VGAM::qgumbel(p, location=location, scale=scale))
}

#' @rdname lgumbel
#' @export
plgumbel <- function(q, location = 0, scale = 0, lower.tail = TRUE, log.p = FALSE){
  if(!length(q)) return(numeric(0))
  Fq <- VGAM::pgumbel(log(q), location=location, scale=scale)
  if(!lower.tail) Fq <- 1-Fq
  if(log.p) Fq <- log(Fq)
  Fq
}

#' @rdname lgumbel
#' @export
rlgumbel <- function(n, location = 0, scale = 0){
  exp(VGAM::rgumbel(n, location=location, scale=scale))
}
