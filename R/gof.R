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
#' Returns with the following columns
#' \describe{
#'   \item{dist}{The distribution name (chr)}
#'   \item{ad}{Anderson-Darling statistic (dbl)}
#'   \item{ks}{Kolmogorov-Smirnov statistic (dbl)}
#'   \item{cvm}{Cramer-von Mises statistic (dbl)}
#'   \item{aic}{Akaike's Information Criterion (dbl)}
#'   \item{aicc}{Akaike's Information Criterion corrected for sample size (dbl)}
#'   \item{bic}{Bayesion Information Criterion (dbl)}
#' }
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

#' @export
ssd_gof.fitdist <- function(x, ...) {
  dist <- x$distname
  n <- nobs(x)
  k <- npars(x)
  x %<>% fitdistrplus::gofstat()

  aicc <- x$aic  + 2 * k * (k + 1) / (n - k - 1)

  dplyr::data_frame(dist = dist, ad = x$ad, ks = x$ks, cvm = x$cvm,
                    aic = x$aic, aicc = aicc, bic = x$bic)
}

#' @export
ssd_gof.fitdists <- function(x, ...) {
  map_df(x, ssd_gof)
}
