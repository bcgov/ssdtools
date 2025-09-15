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

hcp_multi <- function(x, value, ci, level, nboot, min_pboot,
                      data, rescale, weighted, censoring, min_pmix,
                      range_shape1, range_shape2, parametric, control,
                      save_to, samples, est_method, ci_method, hc, ...) {
  estimates <- estimates(x, all_estimates = TRUE)
  dist <- "multi"
  fun <- fits_dists
  pars <- pars_fitdists(x)

  hcp_tmbfit2(
    x,
    dist = dist, estimates = estimates, fun = fun, pars = pars,
    value = value, ci = ci, level = level, nboot = nboot, min_pboot = min_pboot,
    data = data, rescale = rescale, weighted = weighted, censoring = censoring,
    min_pmix = min_pmix, range_shape1 = range_shape1, range_shape2 = range_shape2,
    parametric = parametric, control = control, save_to = save_to,
    samples = samples, hc = hc, ci_method = ci_method, est_method = est_method
  )
}
