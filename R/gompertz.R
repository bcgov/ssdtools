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

#' gompertz Distribution
#'
#' Density, distribution function, quantile function and random generation for 
#' the gompertz distribution with parameters shape and scale.
#'
#' @inheritParams params
#' @param x A numeric vector of values.
#' @return A numeric vector.
#' @seealso \code{\link[stats]{dgompertz}}
#' @name gompertz
#' @examples
#' x <- seq(0.01, 5, by = 0.01)
#' plot(x, dgompertz(x), type = "l")
NULL

#' @rdname gompertz
#' @export
dgompertz <- function(x, shape = 1, scale = 1, log = FALSE) {
  ddist("gompertz", x,  shape = shape, scale = scale, 
        log = log)
}

#' @rdname gompertz
#' @export
pgompertz <- function(q, shape = 1, scale = 1, lower.tail = TRUE, log.p = FALSE) {
  pdist("gompertz", q = q, shape = shape, scale = scale, 
        lower.tail = lower.tail, log.p = log.p)
}

#' @rdname gompertz
#' @export
qgompertz <- function(p, shape = 1, scale = 1, lower.tail = TRUE, log.p = FALSE) {
  qdist("gompertz", p = p, shape = shape, scale = scale, 
        lower.tail = lower.tail, log.p = log.p)
}

#' @rdname gompertz
#' @export
rgompertz <- function(n, shape = 1, scale = 1) {
  rdist("gompertz", n = n, shape = shape, scale = scale)
}

#' @rdname gompertz
#' @export
sgompertz <- function(x) {
  fit <- vglm(x ~ 1, VGAM::gompertz)
  list(start = list(
    shape = exp(unname(coef(fit)[2])), scale = exp(unname(coef(fit)[1]))
  ))
}
