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

#' Hazard Concentration
#'
#' Estimates with bootstrap confidence intervals the hazard concentration
#' at which by default 5\% of the species are affected.
#'
#' @param x The object.
#' @param hc A number between 0 and 1 indicating the percent hazard concentration to plot (or NULL).
#' @param ... Unused.
#' @inheritParams predict.fitdists
#' @return A data frame of the estimate with the standard error and upper and lower confidence intervals.
#' @export
ssd_hc <- function(x, ...) {
  UseMethod("ssd_hc")
}

#' @describeIn ssd_hc Hazard Concentration
#' @export
#' @examples
#' ssd_hc(boron_lnorm)
ssd_hc.fitdist <- function(x, hc = 0.05, level = 0.95, ...) {
  check_probability(hc)
  predict(x, props = hc, level = level)
}

#' @describeIn ssd_hc Hazard Concentration
#' @export
#' @examples
#' ssd_hc(fluazinam_lnorm)
ssd_hc.fitdistcens <- function(x, hc = 0.05, level = 0.95, ...) {
  check_probability(hc)
  predict(x, props = hc, level = level)
}

#' @describeIn ssd_hc Hazard Concentration
#' @export
#' @examples
#' \dontrun{
#' ssd_hc(boron_dists)
#' }
ssd_hc.fitdists <- function(x, hc = 0.05, ic = "aicc", average = TRUE, level = 0.95, ...) {
  check_probability(hc)
  predict(x, props = hc, ic = ic, average = average, level = level)
}

#' @describeIn ssd_hc  Hazard Concentration
#' @export
#' @examples
#' \dontrun{
#' ssd_hc(fluazinam_dists)
#' }
ssd_hc.fitdistscens <- function(x, hc = 0.05, ic = "aic", average = TRUE, level = 0.95, ...) {
  check_probability(hc)
  predict(x, props = hc, ic = ic, average = average, level = level)
}
