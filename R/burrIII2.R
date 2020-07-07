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
#' Probability density, cumulative distribution, 
#' inverse cumulative distribution, random sample and starting values functions.
#'
#' The burrIII2 distribution has been deprecated for the identical llogis distribution.
#'
#' @param x A numeric vector of values.
#' @inheritParams params
#' @return A numeric vector.
#' @name burrIII2
#' @seealso [llogis()]
#' @examples
#' x <- seq(0.01, 5, by = 0.01)
#' plot(x, dburrIII2(x), type = "l")
NULL

#' @rdname burrIII2
#' @export
dburrIII2 <- function(x, locationlog = 0, scalelog = 1, log = FALSE) {
  deprecate_soft("0.1.2", "dburrIII2()", "dllogis()", id = "xburrIII2",
                 details = "The 'burrIII2' distribution has been deprecated for the identical 'llogis' distribution.")
  dllogis(x, locationlog = locationlog, scalelog = scalelog, log = log)
}

#' @rdname burrIII2
#' @export
pburrIII2 <- function(q, locationlog = 0, scalelog = 1, lower.tail = TRUE, log.p = FALSE) {
  deprecate_soft("0.1.2", "pburrIII2()", "pllogis()", id = "xburrIII2",
                 details = "The 'burrIII2' distribution has been deprecated for the identical 'llogis' distribution.")
  pllogis(q, locationlog = locationlog, scalelog = scalelog,
            lower.tail = lower.tail,
            log.p = log.p)
}

#' @rdname burrIII2
#' @export
qburrIII2 <- function(p, locationlog = 0, scalelog = 1, lower.tail = TRUE, log.p = FALSE) {
  deprecate_soft("0.1.2", "qburrIII2()", "qllogis()", id = "xburrIII2",
                 details = "The 'burrIII2' distribution has been deprecated for the identical 'llogis' distribution.")
  qllogis(p, locationlog = locationlog,scalelog = scalelog,
          lower.tail = lower.tail,
          log.p = log.p)
}

#' @rdname burrIII2
#' @export
rburrIII2 <- function(n, locationlog = 0, scalelog = 1) {
  deprecate_soft("0.1.2", "rburrIII2()", "rllogis()", id = "xburrIII2",
                 details = "The 'burrIII2' distribution has been deprecated for the identical 'llogis' distribution.")
  rllogis(n, locationlog = locationlog, scalelog = scalelog)
}

#' @rdname llogis
#' @export
sburrIII2 <- function(x) {
  deprecate_soft("0.1.2", "sburrIII2()", "sllogis()", id = "xburrIII2",
                 details = "The 'burrIII2' distribution has been deprecated for the identical 'llogis' distribution.")
  sllogis(x)
}
