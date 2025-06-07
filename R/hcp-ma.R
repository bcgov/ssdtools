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

ma_est <- function(est, wt, est_method) {
  if(est_method == "geometric") {
    return(exp(weighted.mean(log(est), w = wt)))
  }
  weighted.mean(est, w = wt)
}

ma_cl <- function(cl, wt, est_method) {
  if(est_method == "geometric") {
    return(exp(weighted.mean(log(cl), w = wt)))
  }
  weighted.mean(cl, w = wt)
}

hcp_ma2 <- function(hcp, weight, est_method, ci_method) {
  hcp <- hcp |>
    dplyr::bind_rows() |>
    dplyr::group_by(.data$value) |>
    dplyr::mutate(weight = weight) |>
    dplyr::summarise(
      est = ma_est(.data$est, .data$weight, est_method = est_method),
      lcl = ma_cl(.data$lcl, .data$weight, est_method = est_method),
      ucl = ma_cl(.data$ucl, .data$weight, est_method = est_method),
      se = ma_cl(.data$se, .data$weight, est_method = est_method),
      pboot = min(.data$pboot),
      samples = list(unlist(.data$samples))) |>
    dplyr::ungroup()
}

hcp_ma <- function(x, value, ci, level, nboot, est_method, min_pboot,
                             data, rescale, weighted, censoring, min_pmix,
                             range_shape1, range_shape2, parametric, control,
                             save_to, samples, ci_method, hc, fun) {
  
  hcp <- purrr::map(
    x, hcp_tmbfit, nboot = nboot, value = value, ci = ci, level = level,
    min_pboot = min_pboot, data = data, rescale = rescale, weighted = weighted, censoring = censoring,
    min_pmix = min_pmix, range_shape1 = range_shape1, range_shape2 = range_shape2,
    parametric = parametric, est_method = est_method, ci_method = ci_method, average = TRUE, control = control,
    hc = hc, save_to = save_to, samples = samples, fun = fun
  )
  weight <- glance(x, wt = TRUE)$wt

  hcp_ma2(hcp, weight, est_method = est_method, ci_method = ci_method)
}
