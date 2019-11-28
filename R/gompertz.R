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

#' Gompertz Distribution
#'
#' Density, distribution function, quantile function and random generation
#' for the Gompertz distribution.
#' The functions are wrappers on the equivalent VGAM functions that
#' return a zero length numeric vector if x, q or p are zero length.
#'
#' @param x,q	vector of quantiles.
#' @param p	vector of probabilities.
#' @param n	number of observations.
#' @param scale	scale parameter.
#' @param shape shape parameter.
#' @param log,log.p logical; if TRUE, probabilities p are given as log(p).
#' @param lower.tail	logical; if TRUE (default), probabilities are P[X <= x],otherwise, P[X > x].
#' @return
#' dgompertz gives the density, pgompertz gives the distribution function,
#' qgompertz gives the quantile function, and rgompertz generates random deviates.
#' @seealso \code{\link[VGAM]{dgompertz}}
#' @name gompertz
#' @examples
#' x <- rgompertz(1000, 1, 0.1)
#' hist(log(x), freq = FALSE, col = "gray", border = "white")
#' hist(x, freq = FALSE, col = "gray", border = "white")
#' curve(dgompertz(x, 1, 0.1), add = TRUE, col = "red4", lwd = 2)
NULL

#' @rdname gompertz
#' @export
dgompertz <- function(x, scale = 1, shape = 1, log = FALSE) {
  if (!length(x)) return(numeric(0))
  VGAM::dgompertz(x, scale = scale, shape = shape, log = log)
}

#' @rdname gompertz
#' @export
qgompertz <- function(q, scale = 1, shape = 1, lower.tail = TRUE, log.p = FALSE) {
  if (!length(q)) return(numeric(0))
  VGAM::qgompertz(q, scale = scale, shape = shape, lower.tail = lower.tail, log.p = log.p)
}

#' @rdname gompertz
#' @export
pgompertz <- function(p, scale = 1, shape = 1, lower.tail = TRUE, log.p = FALSE) {
  if (!length(p)) return(numeric(0))
  VGAM::pgompertz(p, scale = scale, shape = shape, lower.tail = lower.tail, log.p = log.p)
}

#' @rdname gompertz
#' @export
rgompertz <- function(n, scale = 1, shape = 1) {
  VGAM::rgompertz(n, scale = scale, shape = shape)
}
