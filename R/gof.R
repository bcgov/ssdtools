#    Copyright 2015 Province of British Columbia
#
#    Licensed under the Apache License, Version 2.0 (the "License");
#    you may not use this file except in compliance with the License.
#    You may obtain a copy of the License at
#
#       http://www.apache.org/licenses/LICENSE-2.0
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
#' where \code{delta} and \code{weight} are based on \code{aic} for censored data
#' and \code{aicc} for non-censored data.
#'
#' @param x The object.
#' @param ... Unused.
#'
#' @return A tbl data frame of the gof statistics.
#' @export
#' @examples
#' ssd_gof(boron_lnorm)
#' ssd_gof(boron_dists)
ssd_gof <- function(x, ...) {
  UseMethod("ssd_gof")
}

#' @describeIn ssd_gof Goodness of Fit
#' @export
ssd_gof.fitdist <- function(x, ...) {
  dist <- x$distname
  n <- nobs(x)
  k <- npars(x)

  aic <- x$aic
  aicc <- aic  + 2 * k * (k + 1) / (n - k - 1)
  bic <- x$bic

  if(n >= 8) {
    x <- fitdistrplus::gofstat(x)
    ad <- x$ad
    ks <- x$ks
    cvm <- x$cvm
  } else {
    ad <- NA_real_
    ks <- NA_real_
    cvm <- NA_real_
  }
  dplyr::data_frame(dist = dist, ad = ad, ks = ks, cvm = cvm,
                    aic = aic, aicc = aicc, bic = bic)
}

#' @describeIn ssd_gof Goodness of Fit
#' @export
ssd_gof.fitdistcens <- function(x, ...) {
  dist <- x$distname
  dplyr::data_frame(dist = dist, aic = x$aic, bic = x$bic)
}

#' @describeIn ssd_gof Goodness of Fit
#' @export
ssd_gof.fitdists <- function(x, ...) {
  x <- map_df(x, ssd_gof)
  if(!is.null(x$aicc)) {
    x$delta <- x$aicc - min(x$aicc)
  } else # aicc not defined for censored data
    x$delta <- x$aic - min(x$aic)
  x$weight <- exp(-x$delta/2)/sum(exp(-x$delta/2))
  x$weight <- round(x$weight, 3)
  x$delta <- round(x$delta, 3)
  x
}
