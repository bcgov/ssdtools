# Copyright 2023 Environment and Climate Change Canada
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

#' @describeIn ssd_p Cumulative Distribution Function for Log-Normal/Log-Normal Mixture Distribution
#' @export
#' @examples
#'
#' ssd_plnorm_lnorm(1)
ssd_plnorm_lnorm <- function(q, meanlog1 = 0, sdlog1 = 1,
                             meanlog2 = 1, sdlog2 = 1, pmix = 0.5,
                             lower.tail = TRUE, log.p = FALSE) {
  pdist("lnorm_lnorm",
    q = q, meanlog1 = meanlog1, sdlog1 = sdlog1,
    meanlog2 = meanlog2, sdlog2 = sdlog2, pmix = pmix,
    lower.tail = lower.tail, log.p = log.p
  )
}

#' @describeIn ssd_q Cumulative Distribution Function for Log-Normal/Log-Normal Mixture Distribution
#' @export
#' @examples
#'
#' ssd_qlnorm_lnorm(0.5)
ssd_qlnorm_lnorm <- function(p, meanlog1 = 0, sdlog1 = 1,
                             meanlog2 = 1, sdlog2 = 1, pmix = 0.5,
                             lower.tail = TRUE, log.p = FALSE) {
  qdist("lnorm_lnorm",
    p = p, meanlog1 = meanlog1, sdlog1 = sdlog1,
    meanlog2 = meanlog2, sdlog2 = sdlog2, pmix = pmix,
    lower.tail = lower.tail, log.p = log.p
  )
}

#' @describeIn ssd_r Random Generation for Log-Normal/Log-Normal Mixture Distribution
#' @export
#' @examples
#'
#' set.seed(50)
#' hist(ssd_rlnorm_lnorm(10000), breaks = 1000)
ssd_rlnorm_lnorm <- function(n, meanlog1 = 0, sdlog1 = 1,
                             meanlog2 = 1, sdlog2 = 1, pmix = 0.5, chk = TRUE) {
  rdist("lnorm_lnorm",
    n = n, meanlog1 = meanlog1, sdlog1 = sdlog1,
    meanlog2 = meanlog2, sdlog2 = sdlog2, pmix = pmix, chk = chk
  )
}

slnorm_lnorm <- function(data, pars = NULL) {
  if (!is.null(pars)) {
    return(pars)
  }

  x <- mean_weighted_values(data)

  x <- sort(x)
  n <- length(x)
  n2 <- floor(n / 2)
  x1 <- x[1:n2]
  x2 <- x[(n2 + 1):n]
  s1 <- slnorm(data.frame(left = x1, right = x1, weight = 1))
  s2 <- slnorm(data.frame(left = x2, right = x2, weight = 1))
  names(s1) <- paste0(names(s1), "1")
  names(s2) <- paste0(names(s2), "2")
  logit_pmix <- list(logit_pmix = 0)
  c(s1, s2, logit_pmix)
}

blnorm_lnorm <- function(x, min_pmix, ...) {
  list(
    lower = list(meanlog1 = -Inf, log_sdlog1 = -Inf, meanlog2 = -Inf, log_sdlog2 = -Inf, logit_pmix = qlogis(min_pmix)),
    upper = list(meanlog1 = Inf, log_sdlog1 = Inf, meanlog2 = Inf, log_sdlog2 = Inf, logit_pmix = qlogis(1 - min_pmix))
  )
}

plnorm_lnorm_ssd <- function(q, meanlog1, sdlog1, meanlog2, sdlog2, pmix) {
  if (sdlog1 <= 0 || sdlog2 <= 0 || pmix <= 0 || pmix >= 1) {
    return(NaN)
  }
  pmix * plnorm_ssd(q, meanlog1, sdlog1) + (1 - pmix) * plnorm_ssd(q, meanlog2, sdlog2)
}

qlnorm_lnorm_ssd <- function(p, meanlog1, sdlog1, meanlog2, sdlog2, pmix) {
  if (sdlog1 <= 0 || sdlog2 <= 0 || pmix <= 0 || pmix >= 1) {
    return(NaN)
  }

  f <- function(x) {
    plnorm_lnorm_ssd(x, meanlog1, sdlog1, meanlog2, sdlog2, pmix) - p
  }
  stats::uniroot(f, lower = 0, upper = 10, extendInt = "upX", tol = .Machine$double.eps)$root
}

rlnorm_lnorm_ssd <- function(n, meanlog1, sdlog1, meanlog2, sdlog2, pmix) {
  if (sdlog1 <= 0 || sdlog2 <= 0 || pmix <= 0 || pmix >= 1) {
    return(rep(NaN, n))
  }
  dist <- stats::rbinom(n, 1, pmix)
  dist <- as.logical(dist)
  x <- rep(NA_real_, n)
  x[dist] <- rlnorm_ssd(sum(dist), meanlog = meanlog1, sdlog = sdlog1)
  x[!dist] <- rlnorm_ssd(sum(!dist), meanlog = meanlog2, sdlog = sdlog2)
  x
}
