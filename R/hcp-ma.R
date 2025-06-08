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

weighted_mean <- function(x, wt, geometric) {
  if(geometric) {
    return(exp(weighted.mean(log(x), w = wt)))
  }
  weighted.mean(x, w = wt)
}

ma_est <- function(est, wt, est_method) {
  if(est_method %in% c("arithmetic", "geometric")) {
    return(weighted_mean(est, wt, geometric = est_method == "geometric"))
  }
  chk_subset(est_method, ssd_est_methods())
}

ma_lcl <- function(lcl, ucl, se, wt, ci_method) {
  if(ci_method %in% c("MACL", "GMACL")) {
    return(weighted_mean(lcl, wt, geometric = ci_method == "GMACL"))
  } 
  chk_subset(ci_method, ssd_ci_methods())
}

ma_ucl <- function(lcl, ucl, se, wt, ci_method) {
  if(ci_method %in% c("MACL", "GMACL")) {
    return(weighted_mean(ucl, wt, geometric = ci_method == "GMACL"))
  } 
  chk_subset(ci_method, ssd_ci_methods())
}

## FIXME: what should the se be for MACL and GMACL!
ma_se <- function(lcl, ucl, se, wt, ci_method) {
  if(ci_method %in% c("MACL", "GMACL")) {
    return(weighted_mean(se, wt, geometric = ci_method == "GMACL"))
  } 
  chk_subset(ci_method, ssd_ci_methods())
}

hcp_ma2 <- function(hcp, weight, est_method, ci_method) {
  hcp <- hcp |>
    dplyr::bind_rows() |>
    dplyr::group_by(.data$value) |>
    dplyr::mutate(weight = weight) |>
    dplyr::summarise(
      est2 = ma_est(.data$est, .data$weight, est_method = est_method),
      lcl2 = ma_lcl(.data$lcl, .data$ucl, .data$se, .data$weight, ci_method = ci_method),
      ucl2 = ma_ucl(.data$lcl, .data$ucl, .data$se, .data$weight, ci_method = ci_method),
      se2 = ma_se(.data$lcl, .data$ucl, .data$se, .data$weight, ci_method = ci_method),
      pboot = min(.data$pboot),
      samples = list(unlist(.data$samples))) |>
    dplyr::ungroup() |>
    dplyr::rename(
      est = "est2", lcl = "lcl2", ucl = "ucl2", se = "se2")
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
