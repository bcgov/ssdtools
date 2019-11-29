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

.autoplot <- function(object, type = "cdf") {
  chk_string(type)
  chk_subset(type, c("cdf", "pdf"))

  if(type == "cdf") return(ssd_plot_cdf(object))
#  ssd_plot_pdf(object)
  NULL
}

#' Autoplot fitdist
#' 
#' Plots the cumulative distribution function (cdf) using the ggplot2
#' generic.
#'
#' @param object The object to plot.
#' @param type A string specifying whether to plot the cdf or pdf.
#' @param ... Unused.
#' @export
#' @examples
#' ggplot2::autoplot(boron_lnorm)
autoplot.fitdist <- function(object, type = "cdf", ...) {
  chk_unused(...)
  .autoplot(object, type = type)
}

#' @describeIn autoplot.fitdist Autoplot fitdistcens
#' @export
#' @examples
#' fluazinam_lnorm$censdata$right[3] <- fluazinam_lnorm$censdata$left[3] * 1.5
#' fluazinam_lnorm$censdata$left[5] <- NA
#' ggplot2::autoplot(fluazinam_lnorm)
autoplot.fitdistcens <- function(object, type = "cdf", ...) {
  chk_unused(...)
  .autoplot(object, type = type)
}

#' @describeIn autoplot.fitdist Autoplot fitdists
#'
#' @export
#' @examples
#' \dontrun{
#' #' ggplot2::autoplot(boron_dists)
#' }
autoplot.fitdists <- function(object, type = "cdf", ...) {
  chk_unused(...)
  .autoplot(object, type = type)
}
