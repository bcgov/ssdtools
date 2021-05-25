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
#' Probability density, cumulative distribution, 
#' inverse cumulative distribution, random sample and starting values functions.
#' 
#' The llog distribution has been deprecated for the identical llogis distribution.
#'
#' @param x A numeric vector of values.
#' @inheritParams params
#' @return A numeric vector.
#' @name llogis
#' @seealso [stats::dlogis()]
#' @examples
#' x <- seq(0.01, 5, by = 0.01)
#' plot(x, dllogis(x), type = "l")
NULL

#' @rdname llogis
#' @export
dllogis <- function(x, locationlog = 0, scalelog = 1, log = FALSE) {
  ddist("logis", x = x,  location = locationlog, scale = scalelog, 
        log = log, .lgt = TRUE)
}

#' @rdname llogis
#' @export
pllogis <- function(q, locationlog = 0, scalelog = 1, lower.tail = TRUE, log.p = FALSE) {
  pdist("logis", q = q,  location = locationlog, scale = scalelog, 
        lower.tail = lower.tail, log.p = log.p, .lgt = TRUE)
}

#' @rdname llogis
#' @export
qllogis <- function(p, locationlog = 0, scalelog = 1, lower.tail = TRUE, log.p = FALSE) {
  qdist("logis", p = p,  location = locationlog, scale = scalelog,
        lower.tail = lower.tail, log.p = log.p, .lgt = TRUE)
}

#' @rdname llogis
#' @export
rllogis <- function(n, locationlog = 0, scalelog = 1) {
  rdist("logis", n = n,  location = locationlog, scale = scalelog, .lgt = TRUE)
}

#' @rdname llogis
#' @export
sllogis <- function(x) {
  list(
    locationlog = mean(log(x), na.rm = TRUE),
    log_scalelog = log(pi * sd(log(x), na.rm = TRUE) / sqrt(3))
  )
}
