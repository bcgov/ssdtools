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

#' Burr Type III Three-Parameter Distribution
#'
#' Density, distribution function, quantile function, random generation
#' and starting values for the
#' Burr Type III Three-Parameter distribution
#' with \code{lshape} and \code{lscale} parameters.
#'
#' The Burr 12 distribution from the actuar package is used as a base.
#' The Burr III distribution is the distribution of 1/x where x has the Burr Type 12 distribution.
#' refer to https://www.itl.nist.gov/div898/software/dataplot/refman2/auxillar/bu3pdf.htm for details.
#' The shape1, shape2, and scale parameters are on the log(scale) as these must be positive.
#'
#' @param x A numeric vector of values.
#' @inheritParams params
#' @return A numeric vector.
#' @name burrIII3
#' @seealso \code{\link[actuar]{dburr}} and \code{\link{burrIII2}}
#' @examples
#' x <- seq(0.01, 5, by = 0.01)
#' plot(x, dburrIII3(x), type = "l")
NULL

dburrXII <- function(x, shape1, shape2, scale, log = FALSE) {
  fx <- (shape1 * shape2 * (x/scale)^shape2)/(x * (1 + (x/scale)^shape2)^(shape1 + 1))
  if(log) return(log(fx))
  fx
}

#' @rdname burrIII3
#' @export
dburrIII3 <- function(x, lshape1 = 0, lshape2 = 0, lscale = 1, log = FALSE) {
  if (!length(x)) {
    return(numeric(0))
  }
  fx <- dburrXII(1 / x,
    shape1 = exp(lshape1), shape2 = exp(lshape2),
    scale = exp(lscale), log = FALSE
  )
  fx <- fx / (x + (x == 0))^2 # avoid dividing by 0. Can only occur if fx is 0.
  if (log) {
    return(log(fx))
  }
  fx
}

#' @rdname burrIII3
#' @export
qburrIII3 <- function(p, lshape1 = 0, lshape2 = 0, lscale = 1, lower.tail = TRUE, log.p = FALSE) {
  if (!length(q)) {
    return(numeric(0))
  }
  q <- actuar::qburr(1 - p,
    shape1 = exp(lshape1), shape2 = exp(lshape2), scale = exp(lscale),
    lower.tail = lower.tail, log.p = log.p
  )
  1 / q
}

#' @rdname burrIII3
#' @export
pburrIII3 <- function(q, lshape1 = 0, lshape2 = 0, lscale = 1, lower.tail = TRUE, log.p = FALSE) {
  if (!length(q)) {
    return(numeric(0))
  }
  actuar::pburr(1 / q,
    shape1 = exp(lshape1), shape2 = exp(lshape2), scale = exp(lscale),
    lower.tail = !lower.tail, log.p = log.p
  )
}

#' @rdname burrIII3
#' @export
rburrIII3 <- function(n, lshape1 = 0, lshape2 = 0, lscale = 1) {
  r <- actuar::rburr(n, shape1 = exp(lshape1), shape2 = exp(lshape2), scale = exp(lscale))
  1 / r
}

#' @rdname burrIII3
#' @export
sburrIII3 <- function(x) {
  list(start = list(lshape1 = 0, lshape2 = 0, lscale = 1))
}
