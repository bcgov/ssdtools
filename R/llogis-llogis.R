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

#' @describeIn ssd_p Cumulative Distribution Function for Log-Logistic/Log-Logistic Mixture Distribution
#' @export
#' @examples
#'
#' ssd_pllogis_llogis(1)
ssd_pllogis_llogis <- function(q, locationlog1 = 0, scalelog1 = 1,
                               locationlog2 = 1, scalelog2 = 1, pmix = 0.5,
                               lower.tail = TRUE, log.p = FALSE) {
  pdist("logis_logis",
    q = q, location1 = locationlog1, scale1 = scalelog1,
    location2 = locationlog2, scale2 = scalelog2, pmix = pmix,
    lower.tail = lower.tail, log.p = log.p, .lgt = TRUE
  )
}

#' @describeIn ssd_q Cumulative Distribution Function for Log-Logistic/Log-Logistic Mixture Distribution
#' @export
#' @examples
#'
#' ssd_qllogis_llogis(0.5)
ssd_qllogis_llogis <- function(p, locationlog1 = 0, scalelog1 = 1,
                               locationlog2 = 1, scalelog2 = 1, pmix = 0.5,
                               lower.tail = TRUE, log.p = FALSE) {
  qdist("logis_logis",
    p = p, location1 = locationlog1, scale1 = scalelog1,
    location2 = locationlog2, scale2 = scalelog2, pmix = pmix,
    lower.tail = lower.tail, log.p = log.p, .lgt = TRUE
  )
}

#' @describeIn ssd_r Random Generation for Log-Logistic/Log-Logistic Mixture Distribution
#' @export
#' @examples
#'
#' set.seed(50)
#' hist(ssd_rllogis_llogis(10000), breaks = 1000)
ssd_rllogis_llogis <- function(n, locationlog1 = 0, scalelog1 = 1,
                               locationlog2 = 1, scalelog2 = 1, pmix = 0.5, chk = TRUE) {
  rdist("logis_logis",
    n = n, location1 = locationlog1, scale1 = scalelog1,
    location2 = locationlog2, scale2 = scalelog2, pmix = pmix, .lgt = TRUE, chk = chk
  )
}

sllogis_llogis <- function(data, pars = NULL) {
  if (!is.null(pars)) {
    return(pars)
  }

  x <- mean_weighted_values(data)
  x <- sort(x)
  n <- length(x)
  n2 <- floor(n / 2)
  x1 <- x[1:n2]
  x2 <- x[(n2 + 1):n]
  s1 <- sllogis(data.frame(left = x1, right = x1, weight = 1))
  s2 <- sllogis(data.frame(left = x2, right = x2, weight = 1))
  names(s1) <- paste0(names(s1), "1")
  names(s2) <- paste0(names(s2), "2")
  logit_pmix <- list(logit_pmix = 0)
  c(s1, s2, logit_pmix)
}

bllogis_llogis <- function(x, min_pmix, ...) {
  list(
    lower = list(locationlog1 = -Inf, log_scalelog1 = -Inf, locationlog2 = -Inf, log_scalelog2 = -Inf, logit_pmix = qlogis(min_pmix)),
    upper = list(locationlog1 = Inf, log_scalelog1 = Inf, locationlog2 = Inf, log_scalelog2 = Inf, logit_pmix = qlogis(1 - min_pmix))
  )
}

plogis_logis_ssd <- function(q, location1, scale1, location2, scale2, pmix) {
  if (scale1 <= 0 || scale2 <= 0 || pmix <= 0 || pmix >= 1) {
    return(NaN)
  }
  pmix * plogis_ssd(q, location1, scale1) + (1 - pmix) * plogis_ssd(q, location2, scale2)
}

qlogis_logis_ssd <- function(p, location1, scale1, location2, scale2, pmix) {
  if (scale1 <= 0 || scale2 <= 0 || pmix <= 0 || pmix >= 1) {
    return(NaN)
  }
  f <- function(x) {
    plogis_logis_ssd(x, location1, scale1, location2, scale2, pmix) - p
  }
  stats::uniroot(f, lower = 0, upper = 10, extendInt = "upX", tol = .Machine$double.eps)$root
}

rlogis_logis_ssd <- function(n, location1, scale1, location2, scale2, pmix) {
  if (scale1 <= 0 || scale2 <= 0 || pmix <= 0 || pmix >= 1) {
    return(rep(NaN, n))
  }
  dist <- stats::rbinom(n, 1, pmix)
  dist <- as.logical(dist)
  x <- rep(NA_real_, n)
  x[dist] <- rlogis_ssd(sum(dist), location = location1, scale = scale1)
  x[!dist] <- rlogis_ssd(sum(!dist), location = location2, scale = scale2)
  x
}
