# Copyright 2015-2023 Province of British Columbia
# Copyright 2021 Environment and Climate Change Canada
# Copyright 2023-2025 Australian Government Department of Climate Change,
# Energy, the Environment and Water
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

hcp_ind_weight <- function(hcp, weight) {
  mapply(function(x, y) {
    x$wt <- y
    x
  },
  x = hcp, y = weight,
  USE.NAMES = FALSE, SIMPLIFY = FALSE
  ) |>
    dplyr::bind_rows()
}

hcp_ind <- function(x, value, ci, level, nboot, min_pboot,
                    data, rescale,
                    weighted, censoring, min_pmix, range_shape1,
                    range_shape2, parametric,
                    control, est_method, ci_method, hc, save_to, samples, fun) {
  
  hcp <- purrr::map(
    x, hcp_tmbfit, nboot = nboot,
    value = value, ci = ci, level = level,
    min_pboot = min_pboot,
    data = data, rescale = rescale, weighted = weighted, censoring = censoring,
    min_pmix = min_pmix, range_shape1 = range_shape1, range_shape2 = range_shape2,
    parametric = parametric, est_method = est_method, ci_method = ci_method, 
    average = FALSE, control = control,
    hc = hc, save_to = save_to, samples = samples, fun = fun
  )
  weight <- glance(x, wt = TRUE)$wt
  
  hcp_ind_weight(hcp, weight = weight)
}
