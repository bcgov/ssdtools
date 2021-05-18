#    Copyright 2015 Province of British Columbia
#
#    Licensed under the Apache License, Version 2.0 (the "License");
#    you may not use this file except in compliance with the License.
#    You may obtain a copy of the License at
#
#       https://www.apache.org/licenses/LICENSE-2.0
#
#    Unless required by applicable law or agreed to in writing, software
#    distributed under the License is distributed on an "AS IS" BASIS,
#    WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
#    See the License for the specific language governing permissions and
#    limitations under the License.

#' Weibull Distribution
#'
#' Density, distribution function, quantile function and random generation for 
#' the weibull distribution with parameters shape and scale.
#'
#' @inheritParams params
#' @param x A numeric vector of values.
#' @return A numeric vector.
#' @seealso [stats::dweibull()]
#' @name weibull
#' @examples
#' x <- seq(0.01, 5, by = 0.01)
#' plot(x, dweibull(x), type = "l")
NULL

#' @rdname weibull
#' @export
dweibull <- function(x, shape = 1, scale = 1, log = FALSE) {
  ddist("weibull", x,  shape = shape, scale = scale, 
        log = log)
}

#' @rdname weibull
#' @export
pweibull <- function(q, shape = 1, scale = 1, lower.tail = TRUE, log.p = FALSE) {
  pdist("weibull", q = q, shape = shape, scale = scale, 
        lower.tail = lower.tail, log.p = log.p)
}

#' @rdname weibull
#' @export
qweibull <- function(p, shape = 1, scale = 1, lower.tail = TRUE, log.p = FALSE) {
  qdist("weibull", p = p, shape = shape, scale = scale, 
        lower.tail = lower.tail, log.p = log.p)
}

#' @rdname weibull
#' @export
rweibull <- function(n, shape = 1, scale = 1) {
  rdist("weibull", n = n, shape = shape, scale = scale)
}

# this needs better starting values
sweibull_tmb <- function(x) {
  list(
    log_scale = log(mean(x, na.rm = TRUE)),
    log_shape = log(sd(x, na.rm = TRUE))
  )
}
