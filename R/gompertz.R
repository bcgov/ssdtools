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
#' Density, distribution function, quantile function, random generation
#' and starting values for the
#' Gompertz distribution.
#'
#' The functions are wrappers on the equivalent VGAM functions that
#' return a zero length numeric vector if x, q or p are zero length.
#'
#' @param x A numeric vector of values.
#' @inheritParams params
#' @return A numeric vector.
#' @seealso \code{\link[VGAM]{dgompertz}}
#' @name gompertz
#' @examples
#' x <- seq(0.01, 5, by = 0.01)
#' plot(x, dgompertz(x), type = "l")
NULL

#' @rdname gompertz
#' @export
dgompertz <- function(x, lscale = 0, lshape = 0, log = FALSE) {
  if (!length(x)) {
    return(numeric(0))
  }
  VGAM::dgompertz(x, scale = exp(lscale), shape = exp(lshape), log = log)
}

#' @rdname gompertz
#' @export
qgompertz <- function(p, lscale = 0, lshape = 0, lower.tail = TRUE, log.p = FALSE) {
  if (!length(p)) {
    return(numeric(0))
  }
  VGAM::qgompertz(p, scale = exp(lscale), shape = exp(lshape), lower.tail = lower.tail, log.p = log.p)
}

#' @rdname gompertz
#' @export
pgompertz <- function(q, lscale = 0, lshape = 0, lower.tail = TRUE, log.p = FALSE) {
  if (!length(q)) {
    return(numeric(0))
  }
  VGAM::pgompertz(q, scale = exp(lscale), shape = exp(lshape), lower.tail = lower.tail, log.p = log.p)
}

#' @rdname gompertz
#' @export
rgompertz <- function(n, lscale = 0, lshape = 0) {
  VGAM::rgompertz(n, scale = exp(lscale), shape = exp(lshape))
}

#' @rdname gompertz
#' @export
sgompertz <- function(x) {
  fit <- vglm(x ~ 1, VGAM::gompertz)
  list(start = list(
    lshape = unname(coef(fit)[2]), lscale = unname(coef(fit)[1])))
}
