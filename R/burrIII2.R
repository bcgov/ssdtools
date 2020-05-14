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

#' Burr Type III Two-Parameter Distribution
#'
#' Density, distribution function, quantile function, random generation
#' and starting values for the
#' Burr Type III two-parameter distribution
#' with \code{lshape} and \code{lscale} parameters.
#'
#' The Burr 12 distribution from the actuar package is used as a base.
#' The Burr III distribution is the distribution of 1/x where x has the Burr Type 12 distribution.
#' refer to
#' \url{https://www.itl.nist.gov/div898/software/dataplot/refman2/auxillar/bu3pdf.htm } for details.
#' The shape1, shape2, and scale parameters are on the log(scale) as these must be positive.
#' The two shape parameters are set to be equal to produce a two-parameter model.
#'
#' @param x A numeric vector of values.
#' @inheritParams params
#' @return A numeric vector.
#' @name burrIII2
#' @seealso \code{\link[actuar]{dburr}} and \code{\link{burrIII3}}
#' @examples
#' x <- seq(0.01, 5, by = 0.01)
#' plot(x, dburrIII2(x), type = "l")
NULL

#' @rdname burrIII2
#' @export
dburrIII2 <- function(x, lshape = 0, lscale = 1, log = FALSE) {
  deprecate_soft("0.1.2", "xburrIII2()",
    details = "The 'burrIII2' distribution has been deprecated for the identical 'llogis' distribution.", id = "xburrIII2"
  )
  dburrIII3(x, lshape1 = lshape, lshape2 = lshape, lscale = lscale, 
                   log = log)
}

#' @rdname burrIII2
#' @export
qburrIII2 <- function(p, lshape = 0, lscale = 1, lower.tail = TRUE, log.p = FALSE) {
  deprecate_soft("0.1.2", "xburrIII2()",
    details = "The 'burrIII2' distribution has been deprecated for the identical 'llogis' distribution.", id = "xburrIII2"
  )
  qburrIII3(p, lshape1 = lshape, lshape2 = lshape, lscale = lscale, 
            lower.tail = lower.tail,
            log.p = log.p)
}

#' @rdname burrIII2
#' @export
pburrIII2 <- function(q, lshape = 0, lscale = 1, lower.tail = TRUE, log.p = FALSE) {
  deprecate_soft("0.1.2", "xburrIII2()",
    details = "The 'burrIII2' distribution has been deprecated for the identical 'llogis' distribution.", id = "xburrIII2"
  )
  pburrIII3(q, lshape1 = lshape, lshape2 = lshape, lscale = lscale, 
            lower.tail = lower.tail,
            log.p = log.p)
}

#' @rdname burrIII2
#' @export
rburrIII2 <- function(n, lshape = 0, lscale = 1) {
  deprecate_soft("0.1.2", "xburrIII2()",
    details = "The 'burrIII2' distribution has been deprecated for the identical 'llogis' distribution.", id = "xburrIII2"
  )
  rburrIII3(n, lshape1 = lshape, lshape2 = lshape, lscale = lscale)
}

#' @rdname burrIII2
#' @export
sburrIII2 <- function(x) {
  deprecate_soft("0.1.2", "xburrIII2()",
    details = "The 'burrIII2' distribution has been deprecated for the identical 'llogis' distribution.", id = "xburrIII2"
  )
  s <- sburrIII3(x)
  list(start = list(lshape = s$lshape1, lscale = s$lscale))
}
