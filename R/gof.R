#    Copyright 2015 Province of British Columbia
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

#' Goodness of Fit
#'
#' Returns a tbl data frame with the following columns
#' \describe{
#'   \item{dist}{The distribution name (chr)}
#'   \item{aic}{Akaike's Information Criterion (dbl)}
#'   \item{bic}{Bayesian Information Criterion (dbl)}
#' }
#' and if the data are non-censored
#' \describe{
#'   \item{aicc}{Akaike's Information Criterion corrected for sample size (dbl)}
#'  }
#' and if there are 8 or more samples
#' \describe{
#'   \item{ad}{Anderson-Darling statistic (dbl)}
#'   \item{ks}{Kolmogorov-Smirnov statistic (dbl)}
#'   \item{cvm}{Cramer-von Mises statistic (dbl)}
#' }
#' In the case of an object of class fitdists the function also returns
#' \describe{
#'   \item{delta}{The Information Criterion differences (dbl)}
#'   \item{weight}{The Information Criterion weights (dbl)}
#' }
#' where `delta` and `weight` are based on `aic` for censored data
#' and `aicc` for non-censored data.
#'
#' @inheritParams params
#' @return A tbl data frame of the gof statistics.
#' @export
#' @examples
#' ssd_gof(boron_lnorm)
#' ssd_gof(boron_dists)
ssd_gof <- function(x, ...) {
  UseMethod("ssd_gof")
}

.ssd_gof_tmbfit <- function(x, attrs, pvalue) {
  nobs <- nrow(attrs$data)
  glance <- .glance_tmbfit(x, nobs)

  dist <- glance$dist
  aic <- glance$aic
  aicc <- glance$aicc
  bic <- - 2 * glance$log_lik + log(nobs) * glance$npars
  
  if (glance$nobs >= 8) {
    ad <- addist(dist, attrs$data, estimates(x), pvalue = pvalue)
    ks <- ksdist(dist, attrs$data, estimates(x), pvalue = pvalue)
    cvm <- cvmdist(dist, attrs$data, estimates(x), pvalue = pvalue)
  } else {
    ad <- NA_real_
    ks <- NA_real_
    cvm <- NA_real_
  }
  tibble(
    dist = dist, ad = ad, ks = ks, cvm = cvm,
    aic = aic, aicc = aicc, bic = bic
  )
}

.ssd_gof_fitdists <- function(x, pvalue) {
  attrs <- .attrs_fitdists(x)
  x <- lapply(x, .ssd_gof_tmbfit, attrs = attrs, pvalue = pvalue)
  x <- bind_rows(x)
  if ("aicc" %in% colnames(x)) {
    x$delta <- x$aicc - min(x$aicc)
  } else { # aicc not defined for censored data
    x$delta <- x$aic - min(x$aic)
  }
  x$weight <- exp(-x$delta / 2) / sum(exp(-x$delta / 2))
  x
}

#' @describeIn ssd_gof Goodness of Fit
#' @export
#' @examples
#' ssd_gof(boron_dists)
ssd_gof.fitdists <- function(x, pvalue = FALSE, ...) {
  chk_flag(pvalue)
  chk_unused(...)

  x <- .ssd_gof_fitdists(x, pvalue = pvalue)
  x$weight <- round(x$weight, 3)
  x$delta <- round(x$delta, 3)
  x
}
