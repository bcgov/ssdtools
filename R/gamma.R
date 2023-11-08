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

#' @describeIn ssd_p Cumulative Distribution Function for Gamma Distribution
#' @export
#' @examples
#'
#' ssd_pgamma(1)
ssd_pgamma <- function(q, shape = 1, scale = 1, lower.tail = TRUE, log.p = FALSE) {
  pdist("gamma",
    q = q, shape = shape, scale = scale,
    lower.tail = lower.tail, log.p = log.p
  )
}

#' @describeIn ssd_q Quantile Function for Gamma Distribution
#' @export
#' @examples
#'
#' ssd_qgamma(0.5)
ssd_qgamma <- function(p, shape = 1, scale = 1, lower.tail = TRUE, log.p = FALSE) {
  qdist("gamma",
    p = p, shape = shape, scale = scale,
    lower.tail = lower.tail, log.p = log.p
  )
}

#' @describeIn ssd_r Random Generation for Gamma Distribution
#' @export
#' @examples
#'
#' set.seed(50)
#' hist(ssd_rgamma(10000), breaks = 1000)
ssd_rgamma <- function(n, shape = 1, scale = 1, chk = TRUE) {
  rdist("gamma", n = n, shape = shape, scale = scale, chk = chk)
}

sgamma <- function(data, pars = NULL) {
  if (!is.null(pars)) {
    return(pars)
  }
  x <- mean_weighted_values(data)

  var <- var(x, na.rm = TRUE)
  mean <- mean(x, na.rm = TRUE)
  list(
    log_scale = log(var / mean),
    log_shape = log(mean^2 / var)
  )
}

pgamma_ssd <- function(q, shape, scale) {
  if (shape <= 0 || scale <= 0) {
    return(NaN)
  }
  stats::pgamma(q, shape = shape, scale = scale)
}

qgamma_ssd <- function(p, shape, scale) {
  if (shape <= 0 || scale <= 0) {
    return(NaN)
  }
  stats::qgamma(p, shape = shape, scale = scale)
}

rgamma_ssd <- function(n, shape, scale) {
  if (shape <= 0 || scale <= 0) {
    return(rep(NaN, n))
  }
  stats::rgamma(n, shape = shape, scale = scale)
}
