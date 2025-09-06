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

#' @describeIn ssd_p Cumulative Distribution Function for Log-Logistic Distribution
#' @export
#' @examples
#'
#' ssd_pllogis(1)
ssd_pllogis <- function(q, locationlog = 0, scalelog = 1, lower.tail = TRUE, log.p = FALSE) {
  pdist("logis",
    q = q, location = locationlog, scale = scalelog,
    lower.tail = lower.tail, log.p = log.p, .lgt = TRUE
  )
}

#' @describeIn ssd_q Cumulative Distribution Function for Log-Logistic Distribution
#' @export
#' @examples
#'
#' ssd_qllogis(0.5)
ssd_qllogis <- function(p, locationlog = 0, scalelog = 1, lower.tail = TRUE, log.p = FALSE) {
  qdist("logis",
    p = p, location = locationlog, scale = scalelog,
    lower.tail = lower.tail, log.p = log.p, .lgt = TRUE
  )
}

#' @describeIn ssd_r Random Generation for Log-Logistic Distribution
#' @export
#' @examples
#'
#' withr::with_seed(50, {
#'   x <- ssd_rllogis(10000)
#' })
#' hist(x, breaks = 1000)
ssd_rllogis <- function(n, locationlog = 0, scalelog = 1, chk = TRUE) {
  rdist("logis", n = n, location = locationlog, scale = scalelog, .lgt = TRUE, chk = chk)
}

#' @describeIn ssd_e Default Parameter Values for Log-Logistic Distribution
#' @export
#' @examples
#'
#' ssd_ellogis()
ssd_ellogis <- function() {
  list(locationlog = 0, scalelog = 1)
}

sllogis <- function(data, pars = NULL) {
  if (!is.null(pars)) {
    return(pars)
  }

  x <- mean_weighted_values(data)

  list(
    locationlog = mean(log(x), na.rm = TRUE),
    log_scalelog = log(pi * sd(log(x), na.rm = TRUE) / sqrt(3))
  )
}

plogis_ssd <- function(q, location, scale) {
  if (scale <= 0) {
    return(NaN)
  }
  stats::plogis(q, location, scale)
}

qlogis_ssd <- function(p, location, scale) {
  if (scale <= 0) {
    return(NaN)
  }
  stats::qlogis(p, location, scale)
}

rlogis_ssd <- function(n, location, scale) {
  if (scale <= 0) {
    return(rep(NaN, n))
  }
  stats::rlogis(n, location, scale)
}

pllogis_ssd <- function(q, locationlog, scalelog) {
  plogis_ssd(log(q), location = locationlog, scale = scalelog)
}

qllogis_ssd <- function(p, locationlog, scalelog) {
  exp(qlogis_ssd(p, location = locationlog, scale = scalelog))
}
