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

#' Autoplot 
#'
#' Plots the cumulative distribution function (cdf) using the ggplot2
#' generic.
#'
#' @inheritParams params
#' @seealso [ssd_plot_cdf()]
#' @export
autoplot <- function(object, ...) {
  UseMethod("autoplot")
}

#' @describeIn autoplot Autoplot fitdist
#' @export
#' @examples
#' ggplot2::autoplot(boron_lnorm)
autoplot.fitdist <- function(object, ...) {
  chk_unused(...)
  ssd_plot_cdf(object)
}

#' @describeIn autoplot Autoplot fitdists
#' @export
#' @examples
#' ggplot2::autoplot(boron_dists)
autoplot.fitdists <- function(object, ...) {
  chk_unused(...)
  ssd_plot_cdf(object)
}

#' @describeIn autoplot Autoplot fitdistcens
#' @export
#' @examples
#' fluazinam_lnorm$censdata$right[3] <- fluazinam_lnorm$censdata$left[3] * 1.5
#' fluazinam_lnorm$censdata$left[5] <- NA
#' ggplot2::autoplot(fluazinam_lnorm)
autoplot.fitdistcens <- function(object, ...) {
  chk_unused(...)
  ssd_plot_cdf(object)
}
