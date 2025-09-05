# Copyright 2015-2023 Province of British Columbia
# Copyright 2021 Environment and Climate Change Canada
# Copyright 2023-2024 Australian Government Department of Climate Change,
# Energy, the Environment and Water
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
#' `r lifecycle::badge("deprecated")`
#'
#' @param x A numeric vector of values.
#' @inheritParams params
#' @return A numeric vector.
#' @keywords internal
#' @export
dgompertz <- function(x, llocation = 0, lshape = 0, log = FALSE) {
  lifecycle::deprecate_stop("1.0.0", "dgompertz()")
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

#' Cumulative Distribution Function for Gompertz Distribution
#' `r lifecycle::badge("deprecated")`
#'
#' Deprecated for `ssd_pgompertz()`.
#'
#' @inheritParams params
#' @keywords internal
#' @export
pgompertz <- function(q, llocation = 0, lshape = 0, lower.tail = TRUE, log.p = FALSE) {
  lifecycle::deprecate_stop("1.0.0", "pgompertz()", "ssd_pgompertz()")
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

#' Quantile Function for Gompertz Distribution
#' `r lifecycle::badge("deprecated")`
#'
#' Deprecated for `ssd_qgompertz()`.
#'
#' @inheritParams params
#' @keywords internal
#' @export
qgompertz <- function(p, llocation = 0, lshape = 0, lower.tail = TRUE, log.p = FALSE) {
  lifecycle::deprecate_stop("1.0.0", "qgompertz()", "ssd_qgompertz()")
}

#' @describeIn ssd_r Random Generation for Gompertz Distribution
#' @export
#' @examples
#'
#' withr::with_seed(50, {
#' x <- ssd_rgompertz(10000)
#' })
#' hist(x, breaks = 1000)
ssd_rgompertz <- function(n, location = 1, shape = 1, chk = TRUE) {
  rdist("gompertz", n = n, location = location, shape = shape, chk = chk)
}

#' @describeIn ssd_e Default Parameter Values for Gompertz Distribution
#' @export
#' @examples
#'
#' ssd_egompertz()
ssd_egompertz <- function() {
  list(location = 1, shape = 1)
}

#' Random Generation for Gompertz Distribution
#' `r lifecycle::badge("deprecated")`
#'
#' Deprecated for `ssd_rgompertz()`.
#'
#' @inheritParams params
#' @keywords internal
#' @export
rgompertz <- function(n, llocation = 0, lshape = 0) {
  lifecycle::deprecate_stop("1.0.0", "rgompertz()", "ssd_rgompertz()")
}

sgompertz <- function(data, pars = NULL) {
  rlang::check_installed("VGAM")
  x <- mean_weighted_values(data)

  if (!is.null(pars)) {
    pars <- rev(unlist(pars))
  }
  data <- data.frame(x = x)
  fit <- suppressWarnings(VGAM::vglm(x ~ 1, VGAM::gompertz, coefstart = pars, data = data))
  list(
    log_location = unname(coef(fit)[2]) * (1 + 1e-3),
    log_shape = unname(coef(fit)[1]) * (1 - 1e-3)
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
