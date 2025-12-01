# Copyright 2015-2023 Province of British Columbia
# Copyright 2021 Environment and Climate Change Canada
# Copyright 2023-2025 Australian Government Department of Climate Change,
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

#' Goodness of Fit
#'
#' Returns a tbl data frame with the following columns
#' \describe{
#'   \item{dist}{The distribution name (chr)}
#'   \item{aic}{Akaike's Information Criterion (dbl)}
#'   \item{bic}{Bayesian Information Criterion (dbl)}
#'   \item{at_bound}{Parameter(s) at boundary (lgl)}
#'   \item{computable}{All parameter have computable standard errors (lgl)}
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
#'   \item{wt}{The Information Criterion weights (dbl)}
#' }
#' where `delta` and `wt` are based on `aic` for censored data
#' and `aicc` for non-censored data.
#'
#' @inheritParams params
#' @return A tbl data frame of the gof statistics.
#' @seealso [`glance.fitdists()`]
#' @export
#' @examples
#' fits <- ssd_fit_dists(ssddata::ccme_boron)
#' ssd_gof(fits, wt = TRUE)
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
#' ssd_gof(fits, pvalue = TRUE, wt = TRUE)
ssd_gof.fitdists <- function(x, ..., pvalue = FALSE, wt = FALSE) {
  chk_unused(...)
  chk_flag(pvalue)

  if (vld_flag(wt) && !wt) {
    lifecycle::deprecate_soft(
      "2.3.1", I("ssd_gof(wt = FALSE)"), I("ssd_gof(wt = TRUE)"),
      "Please set the `wt` argument to `ssd_gof()` to be TRUE which will rename the 'weight' column to 'wt' and then update your downstream code accordingly."
    )
  }
  chk_flag(wt)

  gof <- glance(x, wt = TRUE)
  gof$bic <- -2 * gof$log_lik + log(gof$nobs) * gof$npars

  if (is.na(gof$nobs[1] || gof$nobs[1] < 8)) {
    gof$ad <- NA_real_
    gof$ks <- NA_real_
    gof$cvm <- NA_real_
  } else {
    data <- .data_fitdists(x)
    tests <- lapply(x, .tests_tmbfit, data = data, pvalue = pvalue)
    tests <- dplyr::bind_rows(tests)
    gof <- cbind(gof, tests)
    gof <- as_tibble(gof)
  }
  gof$wt <- round(gof$wt, 3)
  gof$delta <- round(gof$delta, 3)
  gof[c("dist", "ad", "ks", "cvm", "aic", "aicc", "bic", "delta", "wt")]

  if (!wt) {
    gof <- dplyr::rename(gof, weight = "wt")
  }

  ## after in case old fit object and not have at_boundary or computable flags.
  gof$at_bound <- ssd_at_boundary(x)
  gof$computable <- ssd_computable(x)
  gof
}
