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

#' Burr Distribution
#'
#' Density, distribution function, quantile function and random generation
#' for the Burr distribution with \code{shape1}, \code{shape2} and \code{scale} parameters.
#'
#' The functions are wrappers to export the identical functions from the actuar package.
#'
#' @param x,q	vector of quantiles.
#' @param p	vector of probabilities.
#' @param n	number of observations.
#' @param shape1,shape2,scale parameter. Must be strictly positive.
#' @param rate an alternative way to specify the scale.
#' @param log,log.p logical; if TRUE, probabilities p are given as log(p).
#' @param lower.tail	logical; if TRUE (default), probabilities are P[X <= x],otherwise, P[X > x].
#' @param order order of the moment.
#' @return
#' dburr gives the density, pburr gives the distribution function,
#' qburr gives the quantile function, rburr generates random deviates and mburr
#' gives the kth raw moment.
#' @name burr
#' @seealso \code{\link[actuar]{dburr}}
#' @examples
#' x <- rburr(1000,10,10)
#' hist(x,freq=FALSE,col='gray',border='white')
#' curve(dburr(x,10,10),add=TRUE,col='red4',lwd=2)
NULL

#' @rdname burr
#' @export
dburr <- function(x, shape1, shape2, rate = 1, scale = 1/rate, log = FALSE){
  actuar::dburr(x = x, shape1 = shape1, shape2 = shape2, rate = rate,
                scale = scale, log = log)
}

#' @rdname burr
#' @export
qburr <- function(p, shape1, shape2, rate = 1, scale = 1/rate, lower.tail = TRUE, log.p = FALSE){
  actuar::qburr(p = p, shape1 = shape1, shape2 = shape2, rate = rate,
                scale = scale, lower.tail = lower.tail, log.p = log.p)
}

#' @rdname burr
#' @export
pburr <- function(q, shape1, shape2, rate = 1, scale = 1/rate, lower.tail = TRUE, log.p = FALSE){
  actuar::pburr(q = q, shape1 = shape1, shape2 = shape2, rate = rate,
                scale = scale, lower.tail = lower.tail, log.p = log.p)
}

#' @rdname burr
#' @export
rburr <- function(n, shape1, shape2, rate = 1, scale = 1/rate){
  actuar::rburr(n = n, shape1 = shape1, shape2 = shape2, rate = rate)
}

#' @rdname burr
#' @export
mburr <- function(order, shape1, shape2, rate = 1, scale = 1/rate){
  actuar::mburr(order = order, shape1 = shape1, shape2 = shape2, rate = rate)
}

