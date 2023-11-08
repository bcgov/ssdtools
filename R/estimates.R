# Copyright 2023 Province of British Columbia
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

#' @export
universals::estimates

#' @export
estimates.tmbfit <- function(x, ...) {
  as.list(.ests_tmbfit(x))
}

#' Estimates for fitdists Object
#'
#' Gets a named list of the estimated values by distribution and term.
#'
#' @inheritParams params
#' @return A named list of the estimates.
#' @seealso [`tidy.fitdists()`], [`ssd_match_moments()`], [`ssd_hc()`] and [`ssd_plot_cdf()`]
#' @export
#' @examples
#' fits <- ssd_fit_dists(ssddata::ccme_boron)
#' estimates <- estimates(fits)
#' print(estimates)
#' ssd_hc(estimates)
#' ssd_plot_cdf(estimates)
estimates.fitdists <- function(x, ...) {
  y <- lapply(x, estimates)
  names(y) <- names(x)
  y
}
