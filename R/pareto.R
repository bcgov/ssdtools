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

#' Pareto Distribution
#'
#' Density, distribution function, quantile function, random generation
#' and starting values for the
#' Pareto distribution
#' with scale and shape parameters.
#'
#' The functions are wrappers on the equivalent VGAM functions.
#'
#' @param x A numeric vector of values.
#' @inheritParams params
#' @return A numeric vector.
#' @seealso \code{\link[VGAM]{dpareto}}
#' @name pareto
#' @examples
#' x <- seq(0.01, 5, by = 0.01)
#' plot(x, dpareto(x), type = "l")
NULL

#' @rdname pareto
#' @export
dpareto <- function(x, scale = 1, shape = 1, log = FALSE) {
  if (!length(x)) {
    return(numeric(0))
  }
  is.na(x[is.na(x)]) <- TRUE  
  x[!is.na(x)] <- VGAM::dpareto(x[!is.na(x)], scale = scale, shape = shape, log = log)
  x
}

#' @rdname pareto
#' @export
qpareto <- function(p, scale = 1, shape = 1, lower.tail = TRUE, log.p = FALSE) {
  if (!length(p)) {
    return(numeric(0))
  }
  VGAM::qpareto(p, scale = scale, shape = shape, lower.tail = lower.tail, log.p = log.p)
}

#' @rdname pareto
#' @export
ppareto <- function(q, scale = 1, shape = 1, lower.tail = TRUE, log.p = FALSE) {
  if (!length(q)) {
    return(numeric(0))
  }
  VGAM::ppareto(q, scale = scale, shape = shape, lower.tail = lower.tail, log.p = log.p)
}

#' @rdname pareto
#' @export
rpareto <- function(n, scale = 1, shape = 1) {
  VGAM::rpareto(n, scale = scale, shape = shape)
}

#' @rdname pareto
#' @export
spareto <- function(x) {
  fit <- vglm(x ~ 1, VGAM::paretoff)
  list(start = list(shape = exp(unname(coef(fit)))),
       fix.arg = list(scale = fit@extra$scale))
}
