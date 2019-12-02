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

#' Log-Logistic Distribution
#'
#' Density, distribution function, quantile function and random generation
#' for the log-logistic distribution with \code{shape} and \code{scale} parameters.
#'
#' The functions are wrappers to export the identical functions from the FAdist package.
#'
#' @inheritParams params
#' @return
#' dllog gives the density, pllog gives the distribution function,
#' qllog gives the quantile function, and rllog generates random deviates.
#' @name llog
#' @seealso \code{\link[FAdist]{dllog}}
#' @examples
#' x <- rllog(1000)
#' hist(x, freq = FALSE, col = "gray", border = "white")
#' curve(dllog(x), add = TRUE, col = "red4", lwd = 2)
NULL

#' @rdname llog
#' @export
dllog <- function(x, shape = 1, scale = 1, log = FALSE) {
  FAdist::dllog(x = x, shape = shape, scale = scale, log = log)
}

#' @rdname llog
#' @export
qllog <- function(p, shape = 1, scale = 1, lower.tail = TRUE, log.p = FALSE) {
  FAdist::qllog(p = p, shape = shape, scale = scale, lower.tail = lower.tail, log.p = log.p)
}

#' @rdname llog
#' @export
pllog <- function(q, shape = 1, scale = 1, lower.tail = TRUE, log.p = FALSE) {
  FAdist::pllog(q = q, shape = shape, scale = scale, lower.tail = lower.tail, log.p = log.p)
}

#' @rdname llog
#' @export
rllog <- function(n, shape = 1, scale = 1) {
  FAdist::rllog(n = n, shape = shape, scale = scale)
}
