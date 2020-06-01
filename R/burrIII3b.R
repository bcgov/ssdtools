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
#' The Burr III distribution is the distribution of 1/x where 
#' x has the Burr Type 12 distribution 
#' refer to 
#' https://www.itl.nist.gov/div898/software/dataplot/refman2/auxillar/bu3pdf.htm 
#' for details.
#'
#' @param x A numeric vector of values.
#' @inheritParams params
#' @return A numeric vector.
#' @name burrIII3b
NULL

#' @rdname burrIII3b
#' @export
dburrIII3b <- function(x, lshape1 = 0, lshape2 = 0, lscale = 0, log = FALSE) {
  d <- ddist("burrXII", 1/x,  shape1 = exp(lshape1), shape2 = exp(lshape2), scale = exp(lscale), 
        log = log)
  d <- d / (x + (x == 0))^2 # avoid dividing by 0. Can only occur if d is 0.
  d
}

#' @rdname burrIII3b
#' @export
pburrIII3b <- function(q, lshape1 = 0, lshape2 = 0, lscale = 0, lower.tail = TRUE, log.p = FALSE) {
  p <- pdist("burrXII", 1/q,  shape1 = exp(lshape1), shape2 = exp(lshape2), scale = exp(lscale), 
        lower.tail = !lower.tail, log.p = log.p)
  p[!is.na(q) & q <= 0] <- 0
  p
}

#' @rdname burrIII3b
#' @export
qburrIII3b <- function(p, lshape1 = 0, lshape2 = 0, lscale = 0, lower.tail = TRUE, log.p = FALSE) {
  if(isTRUE(log.p)) p <- exp(p)
  q <- qdist("burrXII", p = 1 - p,  shape1 = exp(lshape1), shape2 = exp(lshape2), 
        scale = exp(lscale),
        lower.tail = lower.tail)
  q <- 1 / q
  q[!is.na(p) & p == 0] <- 0
  q[!is.na(p) & p == 1] <- Inf
  q
}

#' @rdname burrIII3b
#' @export
rburrIII3b <- function(n, lshape1 = 0, lshape2 = 0, lscale = 0) {
  r <- rdist("burrXII", n = n, shape1 = exp(lshape1), shape2 = exp(lshape2), scale = exp(lscale))
  1 / r
}

#' @rdname burrIII3b
#' @export
sburrIII3b <- function(x) {
  list(start = list(lshape1 = 0, lshape2 = 0, lscale = 1))
}
