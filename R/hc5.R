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

#' 5\% Hazard Concentration
#'
#' Estimates with bootstrap confidence intervals the hazard concentration
#' at which 5\% of the species are affected.
#'
#' @param x The object.
#' @param ... Unused.
#' @return A data frame of the estimate with the standard error and upper and lower confidence intervals.
#' @export
ssd_hc5 <- function(x, ...) {
  UseMethod("ssd_hc5")
}

#' 5\% Hazard Concentration
#'
#' Estimates with bootstrap confidence intervals the hazard concentration
#' at which 5\% of the species are affected.
#'
#' @param x A fitdist object.
#' @inheritParams predict.fitdist
#' @param ... Unused.
#' @export
#' @examples
#' ssd_hc5(boron_lnorm)
ssd_hc5.fitdist <- function(x, level = 0.95, ...) {
  predict(x, props = 0.05, level = level)
}

#' 5\% Hazard Concentration
#'
#' Estimates with bootstrap confidence intervals the hazard concentration
#' at which 5\% of the species are affected.
#'
#' @param x A fitdist object.
#' @inheritParams predict.fitdists
#' @param ... Unused.
#' @export
#' @examples
#' \dontrun{
#' ssd_hc5(boron_dists)
#' }
ssd_hc5.fitdists <- function(x, ic = "aicc", average = TRUE, level = 0.95, ...) {
    predict(x, props = 0.05, ic = ic, average = average, level = level)
}
