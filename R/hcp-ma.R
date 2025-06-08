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

## https://stats.stackexchange.com/questions/123514/calculating-standard-error-after-a-log-transform
exp_se <- function(se, est) {
  se * est
}

ma_est <- function(est, wt, est_method) {
  if(est_method %in% c("arithmetic", "geometric")) {
    return(weighted_mean(est, wt, geometric = est_method == "geometric"))
  }
  chk_subset(est_method, ssd_est_methods())
}

ma_se <- function(se, log_se, est, wt, ci_method) {
  if(ci_method %in% "MACL") {
    return(weighted_mean(se, wt, geometric = FALSE))
  } 
  if(ci_method %in% "GMACL") {
    log_se <- weighted_mean(log_se, wt, geometric = FALSE)
    est <- ma_est(est, wt = wt, est_method = "geometric")
    return(exp_se(se = log_se, est = est))
  } 
  chk_subset(ci_method, ssd_ci_methods())
}

ma_lcl <- function(est, lcl, se, wt, ci_method) {
  if(ci_method %in% c("MACL", "GMACL")) {
    return(weighted_mean(lcl, wt, geometric = ci_method == "GMACL"))
  } 
  chk_subset(ci_method, ssd_ci_methods())
}

ma_ucl <- function(est, ucl, se, wt, ci_method) {
  if(ci_method %in% c("MACL", "GMACL")) {
    return(weighted_mean(ucl, wt, geometric = ci_method == "GMACL"))
  } 
  chk_subset(ci_method, ssd_ci_methods())
}

hcp_ma2 <- function(hcp, weight, est_method, ci_method) {
  hcp <- hcp |>
    dplyr::bind_rows() |>
    dplyr::group_by(.data$value) |>
    dplyr::mutate(weight = weight) |>
    dplyr::summarise(
      est_ma = ma_est(.data$est, .data$weight, est_method = est_method),
      se_ma = ma_se(se = .data$se, log_se = .data$log_se, est = .data$est, wt = .data$weight, ci_method = ci_method),
      lcl_ma = ma_lcl(lcl = .data$lcl, est = .data$est, se = .data$se, wt = .data$weight, ci_method = ci_method),
      ucl_ma = ma_ucl(ucl = .data$ucl, est = .data$est, se = .data$se, wt = .data$weight, ci_method = ci_method),
      pboot = min(.data$pboot),
      samples = list(unlist(.data$samples))) |>
    dplyr::ungroup() |>
    dplyr::rename(
      est = "est_ma", lcl = "lcl_ma", ucl = "ucl_ma", se = "se_ma")
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
