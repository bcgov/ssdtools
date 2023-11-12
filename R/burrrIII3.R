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

#' @describeIn ssd_p Cumulative Distribution Function for BurrIII Distribution
#' @export
#' @examples
#'
#' ssd_pburrIII3(1)
ssd_pburrIII3 <- function(q, shape1 = 1, shape2 = 1, scale = 1, lower.tail = TRUE, log.p = FALSE) {
  pdist("burrIII3",
    q = q, shape1 = shape1, shape2 = shape2, scale = scale,
    lower.tail = lower.tail, log.p = log.p
  )
}

#' @describeIn ssd_q Quantile Function for BurrIII Distribution
#' @export
#' @examples
#'
#' ssd_qburrIII3(0.5)
ssd_qburrIII3 <- function(p, shape1 = 1, shape2 = 1, scale = 1, lower.tail = TRUE, log.p = FALSE) {
  qdist("burrIII3",
    p = p, shape1 = shape1, shape2 = shape2, scale = scale,
    lower.tail = lower.tail, log.p = log.p
  )
}

#' @describeIn ssd_r Random Generation for BurrIII Distribution
#' @export
#' @examples
#'
#' set.seed(50)
#' hist(ssd_rburrIII3(10000), breaks = 1000)
ssd_rburrIII3 <- function(n, shape1 = 1, shape2 = 1, scale = 1, chk = TRUE) {
  rdist("burrIII3", n = n, shape1 = shape1, shape2 = shape2, scale = scale, chk = chk)
}

sburrIII3 <- function(data, pars = NULL) {
  if (!is.null(pars)) {
    return(pars)
  }
  list(log_scale = 0, log_shape1 = 0, log_shape2 = 0)
}

bburrIII3 <- function(x, range_shape1, range_shape2, ...) {
  log_range_shape1 <- log(range_shape1)
  log_range_shape2 <- log(range_shape2)
  list(
    lower = list(
      log_scale = -Inf,
      log_shape1 = log_range_shape1[1],
      log_shape2 = log_range_shape2[1]
    ),
    upper = list(
      log_scale = Inf,
      log_shape1 = log_range_shape1[2],
      log_shape2 = log_range_shape2[2]
    )
  )
}

pburrIII3_ssd <- function(q, shape1, shape2, scale) {
  if (shape1 <= 0 || shape2 <= 0 || scale <= 0) {
    return(NaN)
  }
  1 / pow(1 + pow(scale / q, shape2), shape1)
}

qburrIII3_ssd <- function(p, shape1, shape2, scale) {
  if (shape1 <= 0 || shape2 <= 0 || scale <= 0) {
    return(NaN)
  }
  scale / (pow(pow(1 / p, 1 / shape1) - 1, 1 / shape2))
}
