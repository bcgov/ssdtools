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
#' @seealso [`glance.fitdists()`]
#' @export
#' @examples
#' fits <- ssd_fit_dists(ssddata::ccme_boron)
#' ssd_gof(fits)
ssd_gof <- function(x, ...) {
  UseMethod("ssd_gof")
}

.tests_tmbfit <- function(x, data, pvalue) {
  dist <- .dist_tmbfit(x)
  pars <- estimates(x)

  ad <- tdist(dist, data, pars, pvalue, "ad", y = "null")
  ks <- tdist(dist, data, pars, pvalue)
  cvm <- tdist(dist, data, pars, pvalue, "cvm", y = "null")

  tibble(ad = ad, ks = ks, cvm = cvm)
}

#' @describeIn ssd_gof Goodness of Fit
#' @export
#' @examples
#' ssd_gof(fits)
ssd_gof.fitdists <- function(x, pvalue = FALSE, ...) {
  chk_flag(pvalue)
  chk_unused(...)

  glance <- glance(x)
  glance$bic <- -2 * glance$log_lik + log(glance$nobs) * glance$npars

  if (glance$nobs[1] < 8) {
    glance$ad <- NA_real_
    glance$ks <- NA_real_
    glance$cvm <- NA_real_
  } else {
    data <- .data_fitdists(x)
    tests <- lapply(x, .tests_tmbfit, data = data, pvalue = pvalue)
    tests <- bind_rows(tests)
    glance <- cbind(glance, tests)
    glance <- as_tibble(glance)
  }
  glance$weight <- round(glance$weight, 3)
  glance$delta <- round(glance$delta, 3)
  glance[c("dist", "ad", "ks", "cvm", "aic", "aicc", "bic", "delta", "weight")]
}
