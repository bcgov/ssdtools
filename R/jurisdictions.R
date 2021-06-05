#    Copyright 2015 Province of British Columbia
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

#' Fit Distributions for British Columbia
#' 
#' Fits the gamma, llogis and lnorm distributions to uncensored,
#' non-weighted data that is automatically rescaled.
#' 
#' For more control see [ssd_fit_dists()].
#'
#' @inheritParams params
#' @return An object of class fitdists.
#' @seealso [ssd_hc5_bc()]
#' @export
#' @examples
#' ssd_fit_dists_bc(boron_data)
ssd_fit_dists_bc <- function(data, left = "Conc", silent = FALSE) {
  dists <- ssd_dists("bc")
  fits <- ssd_fit_dists(data = data, left = left, 
                        dists = dists,
                        rescale = TRUE,
                        nrow = 6L,
                        silent = silent)
  missing <- setdiff(dists, names(fits))
  if(length(missing)) {
    n <- length(missing)
    missing <- cc(missing, conj = " and ")
    abort_chk("The following distribution%s failed to fit:",  missing, n = n)
  }
  fits
}

#' Hazard Concentration 5% for British Columbia
#' 
#' Calculates the model averaged 5% Hazard Concentration (HC5) with
#' 95% parametric bootstrap confidence intervals estimated from 10,000 
#' samples for the gamma, llogis and lnorm distributions fitted to 
#' uncensored, non-weighted, rescaled data.
#'
#' @param x A fitdists object fitted using [ssd_fit_dists_bc()]
#' @return A tbl data frame of the HC5.
#' @seealso [ssd_hc5_bc()]
#' @export
#' @examples
#' \dontrun{
#' fits <- ssd_fit_dists_bc(boron_data)
#' ssd_hc5_bc(fits)
#' }
ssd_hc5_bc <- function(x) {
  chk_s3_class(x, "fitdists")
  ssd_hc(x, ci = TRUE, nboot = 10000, average = TRUE, ic = "aic")
}
