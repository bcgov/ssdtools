# Copyright 2023 Province of British Columbia
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

#' Gompertz Probability Density
#'
#' `r lifecycle::badge("deprecated")`
#'
#' @param x A numeric vector of values.
#' @inheritParams params
#' @return A numeric vector.
#' @export
dgompertz <- function(x, llocation = 0, lshape = 0, log = FALSE) {
  lifecycle::deprecate_warn("1.0.0", "dgompertz()")
  ddist("gompertz", x,
    location = exp(llocation), shape = exp(lshape),
    log = log
  )
}

#' @describeIn ssd_p Cumulative Distribution Function for Gompertz Distribution
#' @export
#' @examples
#'
#' ssd_pgompertz(1)
ssd_pgompertz <- function(q, location = 1, shape = 1, lower.tail = TRUE, log.p = FALSE) {
  pdist("gompertz",
    q = q, location = location, shape = shape,
    lower.tail = lower.tail, log.p = log.p
  )
}

#' @describeIn ssd_p Cumulative Distribution Function for Gompertz Distribution
#' `r lifecycle::badge("deprecated")`
#' @export
pgompertz <- function(q, llocation = 0, lshape = 0, lower.tail = TRUE, log.p = FALSE) {
  lifecycle::deprecate_warn("1.0.0", "pgompertz()", "ssd_pgompertz()")
  ssd_pgompertz(q,
    location = exp(llocation), shape = exp(lshape),
    lower.tail = lower.tail, log.p = log.p
  )
}

#' @describeIn ssd_q Quantile Function for Gompertz Distribution
#' @export
#' @examples
#'
#' ssd_qgompertz(0.5)
ssd_qgompertz <- function(p, location = 1, shape = 1, lower.tail = TRUE, log.p = FALSE) {
  qdist("gompertz",
    p = p, location = location, shape = shape,
    lower.tail = lower.tail, log.p = log.p
  )
}

#' @describeIn ssd_q Quantile Function for Gompertz Distribution
#' `r lifecycle::badge("deprecated")`
#' @export
qgompertz <- function(p, llocation = 0, lshape = 0, lower.tail = TRUE, log.p = FALSE) {
  lifecycle::deprecate_warn("1.0.0", "qgompertz()", "ssd_qgompertz()")
  ssd_qgompertz(
    p = p, location = exp(llocation), shape = exp(lshape),
    lower.tail = lower.tail, log.p = log.p
  )
}

#' @describeIn ssd_r Random Generation for Gompertz Distribution
#' @export
#' @examples
#'
#' set.seed(50)
#' hist(ssd_rgompertz(10000), breaks = 1000)
ssd_rgompertz <- function(n, location = 1, shape = 1, chk = TRUE) {
  rdist("gompertz", n = n, location = location, shape = shape, chk = chk)
}

#' @describeIn ssd_r Random Generation for Gompertz Distribution
#' `r lifecycle::badge("deprecated")`
#' @export
rgompertz <- function(n, llocation = 0, lshape = 0) {
  lifecycle::deprecate_warn("1.0.0", "rgompertz()", "ssd_rgompertz()")
  ssd_rgompertz(n = n, location = exp(llocation), shape = exp(lshape))
}

sgompertz <- function(data, pars = NULL) {
  x <- mean_weighted_values(data)

  if (!is.null(pars)) {
    pars <- rev(unlist(pars))
  }
  data <- data.frame(x = x)
  fit <- suppressWarnings(vglm(x ~ 1, gompertz, coefstart = pars, data = data))
  list(
    log_location = unname(coef(fit)[2]),
    log_shape = unname(coef(fit)[1])
  )
}

pgompertz_ssd <- function(q, location, shape) {
  if (location <= 0 || shape <= 0) {
    return(NaN)
  }
  1 - exp(-location / shape * (exp(q * shape) - 1))
}

qgompertz_ssd <- function(p, location, shape) {
  if (location <= 0 || shape <= 0) {
    return(NaN)
  }
  log(1 - shape / location * log(1 - p)) / shape
}
