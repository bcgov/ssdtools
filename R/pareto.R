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

#' Pareto Distribution
#'
#' Density, distribution function, quantile function and random generation
#' for the Pareto distribution with parameters scale and shape.
#' The functions are wrappers on the equivalent VGAM functions.
#'
#' @param x,q	vector of quantiles.
#' @param p	vector of probabilities.
#' @param n	number of observations.
#' @param scale	alpha parameter.
#' @param shape k parameter.
#' @param log,log.p logical; if TRUE, probabilities p are given as log(p).
#' @param lower.tail	logical; if TRUE (default), probabilities are P[X <= x],otherwise, P[X > x].
#' @return
#' dpareto gives the density, ppareto gives the distribution function,
#' qpareto gives the quantile function, and rpareto generates random deviates.
#' @seealso \code{\link[VGAM]{dpareto}}
#' @name pareto
#' @examples
#' x <- rpareto(1000, 1, 0.1)
#' hist(log(x), freq = FALSE, col = "gray", border = "white")
#' hist(x, freq = FALSE, col = "gray", border = "white")
#' curve(dpareto(x, 1, 0.1), add = TRUE, col = "red4", lwd = 2)
NULL

#' @rdname pareto
#' @export
dpareto <- function(x, scale = 1, shape = 1, log = FALSE) {
  if (!length(x)) {
    return(numeric(0))
  }
  VGAM::dpareto(x, scale = scale, shape = shape, log = log)
}

#' @rdname pareto
#' @export
qpareto <- function(q, scale = 1, shape = 1, lower.tail = TRUE, log.p = FALSE) {
  if (!length(q)) {
    return(numeric(0))
  }
  VGAM::qpareto(q, scale = scale, shape = shape, lower.tail = lower.tail, log.p = log.p)
}

#' @rdname pareto
#' @export
ppareto <- function(p, scale = 1, shape = 1, lower.tail = TRUE, log.p = FALSE) {
  if (!length(p)) {
    return(numeric(0))
  }
  VGAM::ppareto(p, scale = scale, shape = shape, lower.tail = lower.tail, log.p = log.p)
}

#' @rdname pareto
#' @export
rpareto <- function(n, scale = 1, shape = 1) {
  VGAM::rpareto(n, scale = scale, shape = shape)
}
