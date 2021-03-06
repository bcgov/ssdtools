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

#' Gamma Distribution
#'
#' Probability density, cumulative distribution, 
#' inverse cumulative distribution, random sample and starting values functions.
#'
#' @param x A numeric vector of values.
#' @inheritParams params
#' @return A numeric vector.
#' @name gamma
#' @seealso [stats::dgamma()]
#' @examples
#' x <- seq(0.01, 5, by = 0.01)
#' plot(x, dgamma(x), type = "l")
NULL

#' @rdname gamma
#' @export
dgamma <- function(x, shape = 1, scale = 1, log = FALSE) {
  ddist("gamma", x,  shape = shape, scale = scale, 
        log = log)
}

#' @rdname gamma
#' @export
pgamma <- function(q, shape = 1, scale = 1, lower.tail = TRUE, log.p = FALSE) {
  pdist("gamma", q = q, shape = shape, scale = scale, 
             lower.tail = lower.tail, log.p = log.p)
}

#' @rdname gamma
#' @export
qgamma <- function(p, shape = 1, scale = 1, lower.tail = TRUE, log.p = FALSE) {
  qdist("gamma", p = p, shape = shape, scale = scale, 
        lower.tail = lower.tail, log.p = log.p)
}

#' @rdname gamma
#' @export
rgamma <- function(n, shape = 1, scale = 1) {
  rdist("gamma", n = n, shape = shape, scale = scale)
}

#' @rdname gamma
#' @export
sgamma <- function(x) {
  var <- var(x, na.rm = TRUE)
  mean <- mean(x, na.rm = TRUE)
  list(start = list(
    scale = var / mean,
    shape = mean^2 / var
  ))
}
