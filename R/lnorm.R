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

#' Log-Normal Distribution
#'
#' Probability density, cumulative distribution, 
#' inverse cumulative distribution, random sample and starting values functions.
#'
#' @param x A numeric vector of values.
#' @inheritParams params
#' @return A numeric vector.
#' @name lnorm
#' @seealso [stats::dlnorm()]
#' @examples
#' x <- seq(0.01, 5, by = 0.01)
#' plot(x, dlnorm(x), type = "l")
NULL

#' @rdname lnorm
#' @export
dlnorm <- function(x, meanlog = 0, sdlog = 1, log = FALSE) {
  ddist("lnorm", x,  meanlog = meanlog, sdlog = sdlog, 
        log = log)
}

#' @rdname lnorm
#' @export
plnorm <- function(q, meanlog = 0, sdlog = 1, lower.tail = TRUE, log.p = FALSE) {
  pdist("lnorm", q = q, meanlog = meanlog, sdlog = sdlog, 
        lower.tail = lower.tail, log.p = log.p)
}

#' @rdname lnorm
#' @export
qlnorm <- function(p, meanlog = 0, sdlog = 1, lower.tail = TRUE, log.p = FALSE) {
  qdist("lnorm", p = p, meanlog = meanlog, sdlog = sdlog, 
        lower.tail = lower.tail, log.p = log.p)
}

#' @rdname lnorm
#' @export
rlnorm <- function(n, meanlog = 0, sdlog = 1) {
  rdist("lnorm", n = n, meanlog = meanlog, sdlog = sdlog)
}

#' @rdname lnorm
#' @export
slnorm <- function(x) {
  list(start = list(
    meanlog = mean(log(x), na.rm = TRUE),
    sdlog = sd(log(x), na.rm = TRUE)
  ))
}
