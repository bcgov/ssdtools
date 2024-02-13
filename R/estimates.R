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
  # intentionally does not check if ... unused so that the following call 
  # `est <- estimates(fit, all_estimates = TRUE)`
  # in sample_parameters will work with fitdists or tmbfit objects
  as.list(.ests_tmbfit(x))
}

#' Estimates for fitdists Object
#'
#' Gets a named list of the estimated weights and parameters.
#'
#' @inheritParams params
#' @return A named list of the estimates.
#' @seealso [`tidy.fitdists()`], [`ssd_match_moments()`], [`ssd_hc()`] and [`ssd_plot_cdf()`]
#' @export
#' @examples
#' fits <- ssd_fit_dists(ssddata::ccme_boron)
#' estimates(fits)
estimates.fitdists <- function(x, all_estimates = FALSE, ...) {
  chk_flag(all_estimates)
  chk_unused(...)
  estimates <- .list_estimates(x, all_estimates = all_estimates)
  as.list(unlist(estimates))
}

.list_estimates <- function(x, all_estimates = TRUE) {
  y <- lapply(x, estimates)
  wt <- glance(x)$weight
  y <- purrr::map2(y, wt, function(a, b) c(list(weight = b), a))
  names(y) <- names(x)
  if(!all_estimates) {
    return(y)
  }
  all <- emulti_ssd()
  wall <- purrr::map(all, function(x) {x$weight <- 0; x})
  args <- y
  args$.x <- wall
  do.call("list_assign", args)
}

.relist_estimates <- function(x) {
  list <- relist(x, skeleton = emulti_ssd())
  purrr::map(list, function(x) as.list(unlist(x)))
}
