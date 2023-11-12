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

#' Log-Gumbel (Inverse Weibull) Probability Density
#'
#' `r lifecycle::badge("deprecated")`
#'
#' @param x A numeric vector of values.
#' @inheritParams params
#' @return A numeric vector.
#' @export
dlgumbel <- function(x, locationlog = 0, scalelog = 1, log = FALSE) {
  lifecycle::deprecate_warn("1.0.0", "dlgumbel()")
  ddist("gumbel",
    x = x, location = locationlog, scale = scalelog,
    log = log, .lgt = TRUE
  )
}

#' @describeIn ssd_p Cumulative Distribution Function for Log-Gumbel Distribution
#' @export
#' @examples
#'
#' ssd_plgumbel(1)
ssd_plgumbel <- function(q, locationlog = 0, scalelog = 1, lower.tail = TRUE, log.p = FALSE) {
  pdist("gumbel",
    q = q, location = locationlog, scale = scalelog,
    lower.tail = lower.tail, log.p = log.p, .lgt = TRUE
  )
}

#' @describeIn ssd_p Cumulative Distribution Function for Log-Gumbel Distribution
#' `r lifecycle::badge("deprecated")`
#' @export
plgumbel <- function(q, locationlog = 0, scalelog = 1, lower.tail = TRUE, log.p = FALSE) {
  lifecycle::deprecate_warn("1.0.0", "plgumbel()", "ssd_plgumbel()")
  ssd_plgumbel(q,
    locationlog = locationlog, scalelog = scalelog,
    lower.tail = lower.tail, log.p = log.p
  )
}

#' @describeIn ssd_q Quantile Function for Log-Gumbel Distribution
#' @export
#' @examples
#'
#' ssd_qlgumbel(0.5)
ssd_qlgumbel <- function(p, locationlog = 0, scalelog = 1, lower.tail = TRUE, log.p = FALSE) {
  qdist("gumbel",
    p = p, location = locationlog, scale = scalelog,
    lower.tail = lower.tail, log.p = log.p, .lgt = TRUE
  )
}

#' @describeIn ssd_q Quantile Function for Log-Gumbel Distribution
#' `r lifecycle::badge("deprecated")`
#' @export
qlgumbel <- function(p, locationlog = 0, scalelog = 1, lower.tail = TRUE, log.p = FALSE) {
  lifecycle::deprecate_warn("1.0.0", "qlgumbel()", "ssd_qlgumbel()")
  ssd_qlgumbel(p,
    locationlog = locationlog, scalelog = scalelog,
    lower.tail = lower.tail, log.p = log.p
  )
}

#' @describeIn ssd_r Random Generation for log-Gumbel Distribution
#' @export
#' @examples
#'
#' set.seed(50)
#' hist(ssd_rlgumbel(10000), breaks = 1000)
ssd_rlgumbel <- function(n, locationlog = 0, scalelog = 1, chk = TRUE) {
  rdist("gumbel", n = n, location = locationlog, scale = scalelog, .lgt = TRUE, chk = chk)
}

#' @describeIn ssd_r Random Generation for log-Gumbel Distribution
#' `r lifecycle::badge("deprecated")`
#' @export
rlgumbel <- function(n, locationlog = 0, scalelog = 1) {
  lifecycle::deprecate_warn("1.0.0", "rlgumbel()", "ssd_rlgumbel()")
  ssd_rlgumbel(n, locationlog = locationlog, scalelog = scalelog)
}

slgumbel <- function(data, pars = NULL) {
  if (!is.null(pars)) {
    return(pars)
  }

  x <- mean_weighted_values(data)

  list(
    locationlog = mean(log(x), na.rm = TRUE),
    log_scalelog = log(pi * sd(log(x), na.rm = TRUE) / sqrt(6))
  )
}

pgumbel_ssd <- function(q, location, scale) {
  if (scale <= 0) {
    return(NaN)
  }
  exp(-exp(-(q - location) / scale))
}

qgumbel_ssd <- function(p, location, scale) {
  if (scale <= 0) {
    return(NaN)
  }
  location - scale * log(-log(p))
}
