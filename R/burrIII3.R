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
#' Probability density, cumulative distribution, 
#' inverse cumulative distribution, random sample and starting values functions.
#'
#' @param x A numeric vector of values.
#' @inheritParams params
#' @return A numeric vector.
#' @name burrIII3
#' @examples
#' x <- seq(0.01, 5, by = 0.01)
#' plot(x, dburrIII3(x), type = "l")
NULL

#' @rdname burrIII3
#' @export
dburrIII3 <- function(x, lshape1 = 0, lshape2 = 0, lscale = 0, log = FALSE) {
  ddist("burrIII3", x,  shape1 = exp(lshape1), shape2 = exp(lshape2), scale = exp(lscale), 
        log = log)
}

#' @rdname burrIII3
#' @export
pburrIII3 <- function(q, lshape1 = 0, lshape2 = 0, lscale = 0, lower.tail = TRUE, log.p = FALSE) {
  pdist("burrIII3", q = q, shape1 = exp(lshape1), shape2 = exp(lshape2), scale = exp(lscale), 
        lower.tail = lower.tail, log.p = log.p)
}

#' @rdname burrIII3
#' @export
qburrIII3 <- function(p, lshape1 = 0, lshape2 = 0, lscale = 0, lower.tail = TRUE, log.p = FALSE) {
  qdist("burrIII3", p = p, shape1 = exp(lshape1), shape2 = exp(lshape2), scale = exp(lscale), 
        lower.tail = lower.tail, log.p = log.p)
}

#' @rdname burrIII3
#' @export
rburrIII3 <- function(n, lshape1 = 0, lshape2 = 0, lscale = 0) {
  rdist("burrIII3", n = n, shape1 = exp(lshape1), shape2 = exp(lshape2), scale = exp(lscale))
}

#' @rdname burrIII3
#' @export
sburrIII3 <- function(x) {
  list(start = list(lshape1 = 0, lshape2 = 0, lscale = 1))
}
  