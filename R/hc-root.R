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

wt_est_nest <- function(x) {
  glance <- glance(x)
  tidy <- tidy(x)
  
  wt <- dplyr::select(glance, "dist", "weight")
  est <- dplyr::select(tidy, "dist", "term", "est", "se")
  est_nest <- tidyr::nest(est, .by = "dist")
  dplyr::inner_join(wt, est_nest, by = "dist")
}

ma_cdf <- function(glance, tidy) {
  wt_est <- wt_est_nest(glance, tidy)
  
  funs <- paste0("ssd_p", wt$dist)
  wts <- wt_est$weight
#  args <- map(wts$data, 
  
}

.ssd_hc_root <- function(proportion, glance, tidy, ci, level, nboot, min_pboot,
                         data, rescale, weighted, censoring, min_pmix,
                         range_shape1, range_shape2, parametric, control) {
  browser()
  .NotYetImplemented()
  # 1 proportion , multiple distributions, rest all 1
  # need tidy eval and/or function factor to construct function.
}
