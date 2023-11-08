#    Copyright 2023 Australian Government Department of 
#    Climate Change, Energy, the Environment and Water
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

#' Get Distributions Weights and Parameter Estimates
#' 
#' Gets distribution names, weights and parameter estimates for a fitdists object.
#' @inheritParams params
#' @export
#' @examples
#' fits <- ssd_fit_dists(ssddata::ccme_boron)
#' ssd_wt_est(fits)
#' ssd_wt_est(fits)$data[[1]]
ssd_wt_est <- function(x) {
  chk_s3_class(x, "fitdists")
  wt_est_nest(x)
}

check_est <- function(x, x_name = NULL) {
  if (is.null(x_name)) x_name <- deparse_backtick_chk((substitute(x)))
  
  chk_data(x)
  check_names(x, c("term", "est"))
  
  chk_character(x$term)
  chk_not_any_na(x$term)
  chk_unique(x$term)
  
  chk_numeric(x$est)
  chk_not_any_na(x$est)
  
  invisible(x)
}

check_wt_est <- function(x, x_name = NULL) {
  if (is.null(x_name)) x_name <- deparse_backtick_chk((substitute(x)))
  
  chk_data(x)
  # FIXME: switch data to est and possibly weight to wt
  # FIXME: switch term to par or param
  check_names(x, c("dist", "weight", "data"))
  
  chk_character(x$dist)
  chk_not_any_na(x$dist)
  chk_unique(x$dist)
  chk_subset(x$dist, ssd_dists_all())
  
  chk_numeric(x$weight)
  chk_not_any_na(x$weight)
  chk_range(x$weight, c(0,1))
  chk_gt(sum(x$weight), 0)
  
  chk_list(x$data)
  chk_all(x$data, chk_fun = check_est)
  invisible(x)
}
