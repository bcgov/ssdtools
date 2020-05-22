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
#' Probability density, cumulative distribution, 
#' inverse cumulative distribution, random sample and starting values functions.
#'
#' @param x A numeric vector of values.
#' @inheritParams params
#' @return A numeric vector.
#' @name gompertz
#' @seealso \code{\link[stats]{dgamma}}
#' @examples
#' x <- seq(0.01, 5, by = 0.01)
#' plot(x, dgompertz(x), type = "l")
NULL

#' @rdname gompertz
#' @export
dgompertz <- function(x, llocation = 0, lshape = 0, log = FALSE) {
  ddist("gompertz", x,  location = exp(llocation), shape = exp(lshape), 
        log = log)
}

#' @rdname gompertz
#' @export
pgompertz <- function(q, llocation = 0, lshape = 0, lower.tail = TRUE, log.p = FALSE) {
  pdist("gompertz", q = q, location = exp(llocation), shape = exp(lshape), 
        lower.tail = lower.tail, log.p = log.p)
}

#' @rdname gompertz
#' @export
qgompertz <- function(p, llocation = 0, lshape = 0, lower.tail = TRUE, log.p = FALSE) {
  qdist("gompertz", p = p, location = exp(llocation), shape = exp(lshape), 
        lower.tail = lower.tail, log.p = log.p)
}

#' @rdname gompertz
#' @export
rgompertz <- function(n, llocation = 0, lshape = 0) {
  rdist("gompertz", n = n, location = exp(llocation), shape = exp(lshape))
}

#' @rdname gompertz
#' @export
sgompertz <- function(x) {
  fit <- vglm(x ~ 1, VGAM::gompertz)
  list(start = list(
    llocation = unname(coef(fit)[2]), lshape = unname(coef(fit)[1])
  ))
}
