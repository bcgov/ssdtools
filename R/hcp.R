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

samples_unscale <- function(samples, rescale) {
  purrr::map(samples, function(x, r) unscale(x, r), r = rescale)
}

hcp_unscale <- function(hcp, rescale) {
  hcp$est <- unscale(hcp$est, rescale)
  hcp$se <- unscale(hcp$se, rescale)
  hcp$lcl <- unscale(hcp$lcl, rescale)
  hcp$ucl <- unscale(hcp$ucl, rescale)
  hcp$samples <- samples_unscale(hcp$samples, rescale)
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

clean_hcp <- function(hcp, ci, level, average, est_method, ci_method, parametric, nboot, min_pboot, samples) {
  hcp$est_method <- est_method
  hcp$ci_method <- ci_method
  hcp$boot_method <- if (parametric) "parametric" else "non-parametric"
  hcp$level <- level

  if (ci) {
    hcp$nboot <- nboot
  } else {
    hcp$se <- NA_real_
    hcp$lcl <- NA_real_
    hcp$ucl <- NA_real_
    hcp$nboot <- 0L
    hcp$pboot <- 1
  }

  if (any(hcp$pboot < min_pboot)) {
    fail <- hcp$pboot < min_pboot
    hcp$lcl[fail] <- NA_real_
    hcp$ucl[fail] <- NA_real_
    hcp$se[fail] <- NA_real_
  }

  if (average) {
    hcp$dist <- "average"
    hcp$wt <- 1
  } else {
    hcp$est_method <- "cdf"
    hcp$ci_method <- "percentile"
  }

  if (!samples) {
    hcp$samples <- list(numeric(0))
  }

  hcp |>
    dplyr::select(c("dist", "value", "est", "se", "lcl", "ucl", "wt", "level", "est_method", "ci_method", "boot_method", "nboot", "pboot", "dists", "samples"))
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

  if (length(x) == 1L) {
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
      x,
      value = value, ci = ci, level = level, nboot = nboot,
      min_pboot = min_pboot,
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
      min_pboot = min_pboot, ci_method = ci_method,
      data = data, rescale = rescale, weighted = weighted, censoring = censoring,
      min_pmix = min_pmix, range_shape1 = range_shape1, range_shape2 = range_shape2,
      parametric = parametric, control = control,
      hc = hc, save_to = save_to, samples = samples, fun = fun
    )
    hcp$dists <- rep(list(sort(names(x))), nrow(hcp))
  }
  clean_hcp(hcp, ci = ci, level = level, average = average, est_method = est_method, ci_method = ci_method, parametric = parametric, nboot = nboot, min_pboot = min_pboot, samples = samples)
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

  ## FIXME add warning on GMACL and MACL?
  x <- subset(x, delta = delta)

  hcp <- hcp2(
    x,
    value = value, ci = ci, level = level, nboot = nboot,
    average = average, est_method = est_method, min_pboot = min_pboot,
    parametric = parametric, ci_method = ci_method,
    control = control, save_to = save_to, samples = samples, hc = hc, fun = fun
  )
  warn_min_pboot(hcp, min_pboot)
}
