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

#' Log-Gumbel Distribution
#'
#' Density, distribution function, quantile function, random generation
#' and starting values for the
#' Log-Gumbel distribution
#' with \code{lscale} and \code{llocation} parameters.
#'
#' @param x A numeric vector of values.
#' @inheritParams params
#' @return A numeric vector.
#' @name lgumbel
NULL

#' @rdname lgumbel
#' @export
dlgumbel <- function(x, llocation = 0, lscale = 1, log = FALSE) {
  if(!length(x)) return(numeric(0))
  d <-  mapply(dgumbel_cpp, x = log(x), location = llocation, scale = lscale)
  d <- d / x
  if (log) return(log(d))
  d
}

#' @rdname lgumbel
#' @export
qlgumbel <- function(p, llocation = 0, lscale = 1, lower.tail = TRUE, log.p = FALSE) {
  if(!length(p)) return(numeric(0))
  if (log.p) p <- exp(p)
  if (!lower.tail) p <- 1 - p
  q <- mapply(qgumbel_cpp, p = p, location = llocation, scale = lscale)
  exp(q)
}

#' @rdname lgumbel
#' @export
plgumbel <- function(q, llocation = 0, lscale = 1, lower.tail = TRUE, log.p = FALSE) {
  if (!length(q)) {
    return(numeric(0))
  }
  Fq <- VGAM::pgumbel(log(q), location = llocation, scale = lscale)
  if (!lower.tail) Fq <- 1 - Fq
  if (log.p) Fq <- log(Fq)
  Fq
}

#' @rdname lgumbel
#' @export
rlgumbel <- function(n, llocation = 0, lscale = 1) {
  exp(VGAM::rgumbel(n, location = llocation, scale = lscale))
}

#' @rdname lgumbel
#' @export
slgumbel <- function(x) {
  list(start = list(
    llocation = mean(log(x), na.rm = TRUE),
    lscale = pi * sd(log(x), na.rm = TRUE) / sqrt(6)
  ))
}
