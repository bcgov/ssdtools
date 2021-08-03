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

#' 5% Hazard Concentration for British Columbia
#' 
#' Calculates the 5% Hazard Concentration for British Columbia
#' after rescaling the data 
#' based on the log-logistic, log-normal and gamma distributions 
#' using the parametric bootstrap and AICc model averaging.
#' 
#' Returns a tibble the model averaged 5% hazard concentration with 
#' standard errors, 95% lower and upper confidence limits
#' and the number of bootstrap samples as well as the proportion of bootstrap
#' samples that successfully returned a likelihood 
#' (convergence of the bootstrap sample is not required).
#'
#' @inheritParams params
#'
#' @return A tibble of the 5% hazard concentration with stand 95% confidence intervals.
#' @seealso [`ssd_fit_dists()`] and [`ssd_hc()`] 
#' @export
#'
#' @examples
#' \dontrun{
#'  ssd_hc5_bc(ssdtools::boron_data)
#' }
ssd_hc5_bc <- function(data, left = "Conc") {
  dists <- ssd_dists("bc")
  fits <- ssd_fit_dists(data, left = left, rescale = TRUE)
  ssd_hc(fits, ci = TRUE, delta = 7, nboot = 10000)
}
