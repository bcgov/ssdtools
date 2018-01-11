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

#' Get HC5
#'
#' @param object The object.
#' @param ... Unused.
#'
#' @return A data frame of the hc5 estimate with se and upper and lower confidence intervals.
#' @export
#' @examples
#' ssd_hc5(boron_lnorm)
ssd_hc5 <- function(object, ...) {
  UseMethod("ssd_hc5")
}

#' @export
ssd_hc5.fitdist <- function(object, nboot = 1001, level = 0.95, ...) {
  predict(object, probs = 0.05, nboot = nboot, level = level)
}

#' @export
ssd_hc5.fitdists <- function(object, nboot = 1001, ic = "aicc", level = 0.95, ...) {
    predict(object, probs = 0.05, nboot = nboot, ic = ic, level = level)
}
