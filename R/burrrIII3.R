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
#' Density, distribution function, quantile function and random generation
#' for the Burr Type III Three-Parameter distribution with 
#' \code{lshape} and \code{lscale} parameters.
#' 
#' The Burr 12 distribution from the actuar package is used as a base.
#' The Burr III distribution is the distribution of 1/x where x has the Burr Type 12 distribution.
#' refer to https://www.itl.nist.gov/div898/software/dataplot/refman2/auxillar/bu3pdf.htm for details.
#' The shape1, shape2, and scale paramters are on the log(scale) as these must be positive.
#'
#' @inheritParams params
#' @return
#' dburrIII3 gives the density, pburrIII3 gives the distribution function,
#' qburrIII3 gives the quantile function, and rburrIII3 generates random samples.
#' @name burrIII3
#' @seealso \code{\link[actuar]{dburr}}
#' @examples
#' x <- rburrIII3(1000)
#' hist(x, freq = FALSE, col = "gray", border = "white")
#' curve(dburrIII3(x), add = TRUE, col = "red4", lwd = 2)
NULL

#' @rdname burrIII3
#' @export
dburrIII3 <- function(x, lshape1 = 0, lshape2 = 0, lscale = 0, log = FALSE) {
  if(!length(x))return(numeric(0))
  fx <- actuar::dburr(1/x, shape1 = exp(lshape1), shape2 = exp(lshape2), 
                      scale = exp(lscale), log = FALSE)
  fx <- fx / (x+(x==0))^2  # avoid dividing by 0. Can only occur if fx is 0.
  if(log) return(log(fx))
  fx
}

#' @rdname burrIII3
#' @export
qburrIII3 <- function(p, lshape1 = 0, lshape2 = 0, lscale = 0, lower.tail = TRUE, log.p = FALSE) {
  if(!length(q)) return(numeric(0))
  if(log.p) p <- exp(p)
  q <- suppressWarnings(actuar::qburr(1-p, shape1=exp(lshape1), shape2=exp(lshape2), scale=exp(lscale), 
                     lower.tail=lower.tail))
  1/q
}

#' @rdname burrIII3
#' @export
pburrIII3 <- function (q, lshape1 = 0, lshape2 = 0, lscale=0, lower.tail=TRUE, log.p=FALSE) {
  if(!length(q)) return(numeric(0))
  actuar::pburr(1/q, shape1=exp(lshape1), shape2=exp(lshape2), scale=exp(lscale), 
                lower.tail=!lower.tail, log.p=log.p)
}

#' @rdname burrIII3
#' @export
rburrIII3 <- function(n, lshape1 = 0, lshape2 = 0, lscale=0) {
  chk_scalar(lshape1)
  chk_scalar(lshape2)
  chk_scalar(lscale)
  
  r <- suppressWarnings(actuar::rburr(n, shape1=exp(lshape1), shape2=exp(lshape2), scale=exp(lscale)))
  1/r
}

#' @rdname burrIII3
#' @export
sburrIII3 <- function(x) {
  list(start = list(lshape1 = 0, lshape2 = 0, lscale = 1))
}

