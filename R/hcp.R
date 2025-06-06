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

samples_multiply <- function(samples, multiplier) {
  purrr::map(samples, function(x, m) x * m, m = multiplier)
}

hcp_multiply <- function(hcp, multiplier) {
  hcp$est <- hcp$est * multiplier
  hcp$se <- hcp$se * multiplier
  hcp$lcl <- hcp$lcl * multiplier
  hcp$ucl <- hcp$ucl * multiplier
  hcp$samples <- samples_multiply(hcp$samples, multiplier)
  hcp
}

## no_hcp is returned without tidying so must be complete
no_hcp <- function(hc) {
  tibble(
    dist = character(0),
    value = numeric(0),
    est = numeric(0),
    se = numeric(0),
    lcl = numeric(0),
    ucl = numeric(0),
    wt = numeric(0),
    est_method = character(0),
    ci_method = character(0),
    boot_method = character(0),
    nboot = integer(0),
    pboot = numeric(0),
    samples = list(numeric(0))
  )
}

group_samples <- function(hcp) {
    bind_rows(hcp) |>
    dplyr::group_by(.data$value) |>
    dplyr::summarise(samples = list(unlist(.data$samples))) |>
    dplyr::ungroup()
}

hcp_average2 <- function(hcp, weight, value, nboot, est_method) {
  samples <- group_samples(hcp)
  
  hcp <- lapply(hcp, function(x) x[c("value", "est", "se", "lcl", "ucl", "pboot")])
  hcp <- lapply(hcp, as.matrix)
  hcp <- Reduce(function(x, y) {
    abind(x, y, along = 3)
  }, hcp)
  suppressMessages(min <- apply(hcp, c(1, 2), min))
  suppressMessages(hcp <- apply(hcp, c(1, 2), weighted_mean, w = weight, geometric = est_method == "geometric"))
  min <- as.data.frame(min)
  hcp <- as.data.frame(hcp)
  tib <- tibble(
    dist = "average", value = value, est = hcp$est, se = hcp$se,
    lcl = hcp$lcl, ucl = hcp$ucl, wt = rep(1, length(value)),
    nboot = nboot, pboot = min$pboot
  )
  tib <- dplyr::inner_join(tib, samples, by = "value")
  dplyr::arrange(tib, .data$value)
}

## uses weighted bootstrap to get se, lcl and ucl
hcp_weighted <- function(hcp, level, samples, min_pboot) {
  quantiles <- purrr::map(hcp$samples, stats::quantile, probs = probs(level))
  quantiles <- purrr::transpose(quantiles)
  hcp$lcl <- unlist(quantiles[[1]])
  hcp$ucl <- unlist(quantiles[[2]])
  hcp$se <- purrr::map_dbl(hcp$samples, sd)
  hcp$pboot <- pmin(purrr::map_dbl(hcp$samples, length) / hcp$nboot, 1)
  fail <- hcp$pboot < min_pboot
  hcp$lcl[fail] <- NA_real_
  hcp$ucl[fail] <- NA_real_
  hcp$se[fail] <- NA_real_
  if (!samples) {
    hcp$samples <- list(numeric(0))
  }
  hcp
}

.ssd_hcp_conventional <- function(x, value, ci, level, nboot, est_method, min_pboot, estimates,
                                  data, rescale, weighted, censoring, min_pmix,
                                  range_shape1, range_shape2, parametric, control,
                                  save_to, samples, ci_method, hc, fun) {
  
  if (ci &&  ci_method == "weighted_samples") {
    atleast1 <- round(glance(x, wt = TRUE)$wt * nboot) >= 1L
    x <- subset(x, names(x)[atleast1])
    estimates <- estimates[atleast1]
  }
  weight <- purrr::map_dbl(estimates, function(x) x$weight)
  
  
  hcp <- purrr::map2(
    x, weight, hcp_tmbfit, value = value, ci = ci, level = level, nboot = nboot,
    min_pboot = min_pboot, data = data, rescale = rescale, weighted = weighted, censoring = censoring,
    min_pmix = min_pmix, range_shape1 = range_shape1, range_shape2 = range_shape2,
    parametric = parametric, est_method = est_method, ci_method = ci_method, average = TRUE, control = control,
    hc = hc, save_to = save_to, samples = samples || ci_method == "weighted_samples", fun = fun
  )
  
  hcp <- hcp_average2(hcp, weight, value, nboot = nboot, est_method = est_method)
  if (ci_method != "weighted_samples") {
    if (!samples) {
      hcp$samples <- list(numeric(0))
    }
    return(hcp)
  }
  hcp_weighted(hcp, level = level, samples = samples, min_pboot = min_pboot)
}

.ssd_hcp_multi <- function(x, value, ci, level, nboot, min_pboot,
                           data, rescale, weighted, censoring, min_pmix,
                           range_shape1, range_shape2, parametric, control,
                           save_to, samples, est_method, ci_method, hc) {
  
  estimates <- estimates(x, all_estimates = TRUE)
  dist <- "multi"
  fun <- fits_dists
  pars <- pars_fitdists(x)
  
  hcp <- hcp_tmbfit2(
    x, dist = dist, estimates = estimates, fun = fun, pars = pars,
    value = value, ci = ci, level = level, nboot = nboot, min_pboot = min_pboot,
    data = data, rescale = rescale, weighted = weighted, censoring = censoring,
    min_pmix = min_pmix, range_shape1 = range_shape1, range_shape2 = range_shape2,
    parametric = parametric, control = control, save_to = save_to,
    samples = samples, hc = hc, ci_method = ci_method, est_method = est_method
  )
  hcp$dist <- "average"
  hcp[c("dist", "value", "est", "se", "lcl", "ucl", "wt", "nboot", "pboot", "samples")]
}

tidy_hcp <- function(hcp, ci, average, est_method, ci_method, parametric) {
  hcp$est_method <- est_method
  hcp$ci_method <- ci_method
  hcp$boot_method <- if (parametric) "parametric" else "non-parametric"

  if(!average) {
    hcp$est_method <- "cdf"
    hcp$ci_method <- "percentile"
  }
  
  if(!ci) {
    hcp$se <- NA_real_
    hcp$lcl <- NA_real_
    hcp$ucl <- NA_real_
    hcp$nboot <- 0L
    hcp$pboot <- 1
    hcp$samples <- list(numeric(0))
  }
  
  hcp[c("dist", "value", "est", "se", "lcl", "ucl", "wt", "est_method", "ci_method", "boot_method", "nboot", "pboot", "dists", "samples")]
}

hcp2 <- function(
    x, value, ci, level, nboot, average, est_method, min_pboot, parametric,
    ci_method, control, hc, save_to, samples, fun) {
  if (!length(x) || !length(value)) {
    return(no_hcp())
  }
  
  if (is.null(control)) {
    control <- .control_fitdists(x)
  }
  
  data <- .data_fitdists(x)
  rescale <- .rescale_fitdists(x)
  censoring <- .censoring_fitdists(x)
  min_pmix <- .min_pmix_fitdists(x)
  range_shape1 <- .range_shape1_fitdists(x)
  range_shape2 <- .range_shape2_fitdists(x)
  weighted <- .weighted_fitdists(x)
  unequal <- .unequal_fitdists(x)
  estimates <- .list_estimates(x, all_estimates = FALSE)
  
  if(length(x) == 1L) {
    average <- FALSE
  }
  
  if (ci && parametric && !identical(censoring, c(0, Inf))) {
    wrn("Parametric CIs cannot be calculated for censored data.")
    ci <- FALSE
  }
  
  if (ci && parametric && unequal) {
    wrn("Parametric CIs cannot be calculated for unequally weighted data.")
    ci <- FALSE
  }
  
  if (!ci) {
    nboot <- 0L
  }
  
  if (!average) {
    hcp <- hcp_ind(
      x, value = value, ci = ci, level = level, nboot = nboot,
      min_pboot = min_pboot, estimates = estimates,
      data = data, rescale = rescale, weighted = weighted, censoring = censoring,
      min_pmix = min_pmix, range_shape1 = range_shape1, range_shape2 = range_shape2,
      parametric = parametric, control = control,
      est_method = est_method, ci_method = ci_method,
      hc = hc, save_to = save_to, samples = samples, fun = fun
    )
    hcp$dists <- as.list(hcp$dist)
  } else {
    hcp <- hcp_average(
      x = x, value = value, ci = ci, level = level, nboot = nboot, est_method = est_method,
      min_pboot = min_pboot, estimates = estimates, ci_method = ci_method,
      data = data, rescale = rescale, weighted = weighted, censoring = censoring,
      min_pmix = min_pmix, range_shape1 = range_shape1, range_shape2 = range_shape2,
      parametric = parametric, control = control,
      hc = hc, save_to = save_to, samples = samples, fun = fun
    )
    hcp$dists <- rep(list(sort(names(x))), nrow(hcp))
  }
  tidy_hcp(hcp, ci = ci, average = average, est_method = est_method, ci_method = ci_method, parametric = parametric)  
}

hcp <- function(
    x, value, ci, level, nboot, average, est_method, delta, min_pboot,
    parametric, ci_method, control, samples, save_to,
    hc, fun = fit_tmb) {
  chk_vector(value)
  chk_numeric(value)
  chk_flag(ci)
  chk_number(level)
  chk_range(level)
  chk_whole_number(nboot)
  chk_gt(nboot)
  chk_lt(nboot, 1e+09)
  chk_flag(average)
  
  chk_string(est_method)
  chk_subset(est_method, ssd_est_methods())
  
  chk_number(delta)
  chk_gte(delta)
  chk_number(min_pboot)
  chk_range(min_pboot)
  chk_flag(parametric)
  
  chk_string(ci_method)
  chk_subset(ci_method, ssd_ci_methods())
  chk_null_or(control, vld = vld_list)
  chk_null_or(save_to, vld = vld_dir)
  chk_flag(samples)
  
  x <- subset(x, delta = delta)
  
  hcp <- hcp2(
    x, value = value, ci = ci, level = level, nboot = nboot,
    average = average, est_method = est_method, min_pboot = min_pboot,
    parametric = parametric, ci_method = ci_method,
    control = control, save_to = save_to, samples = samples, hc = hc, fun = fun
  )
  warn_min_pboot(hcp, min_pboot)
}
