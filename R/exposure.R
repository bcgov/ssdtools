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

#' Percent Exposure
#' 
#' Calculates average proportion exposed based on log-normal distribution of concentrations.
#'
#' @param x The object to plot.
#' @param meanlog A number of the mean of the exposure concentrations on the log scale.
#' @param sdlog A number of the standard deviation of the exposure concentrations on the log scale.
#' @param nboot A whole number of the number of samples to use to calculate the exposure.
#' @param ... Unused.
#' @return A number of the proportion exposed.
#' @export
#' @examples 
#' set.seed(10)
#' ssd_exposure(boron_lnorm)
#' ssd_exposure(boron_lnorm, meanlog = 1)
#' ssd_exposure(boron_lnorm, meanlog = 1, sdlog = 1)
ssd_exposure <- function(x, meanlog = 0, sdlog = 1, nboot = 1000) {
  conc <- rlnorm(nboot, meanlog = meanlog, sdlog = sdlog)
  mean(ssd_hp(x, conc)$est) / 100
}