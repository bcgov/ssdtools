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

no_hcp <- function(hc) {
  tibble(
    dist = character(0),
    value = numeric(0),
    est = numeric(0),
    se = numeric(0),
    lcl = numeric(0),
    ucl = numeric(0),
    wt = numeric(0),
    nboot = integer(0),
    pboot = numeric(0),
    samples = I(list(numeric(0)))
  )
}

no_ci_hcp <- function(value, dist, est, rescale, hc) {
  na <- rep(NA_real_, length(value))
  multiplier <- if (hc) rescale else 100

  tibble(
    dist = rep(dist, length(value)),
    value = value,
    est = est * multiplier,
    se = na,
    lcl = na,
    ucl = na,
    wt = rep(1, length(value)),
    nboot = rep(0L, length(value)),
    pboot = na,
    samples = I(list(numeric(0)))
  )
}

ci_hcp <- function(cis, estimates, value, dist, est, rescale, nboot, hc) {
  multiplier <- if (hc) rescale else 100
  
  tibble(
    dist = dist,
    value = value,
    est = est * multiplier,
    se = cis$se * multiplier,
    lcl = cis$lcl * multiplier,
    ucl = cis$ucl * multiplier,
    wt = rep(1, length(value)),
    nboot = nboot,
    pboot = length(estimates) / nboot,
    samples = I(lapply(cis$samples, function(x) x * multiplier))
  )
}

.ssd_hcp <- function(
    x, dist, estimates, fun, pars, value, ci, level, nboot, min_pboot,
    data, rescale, weighted, censoring, min_pmix,
    range_shape1, range_shape2, parametric, control, save_to, samples, hc,
    fix_weights = FALSE) {
  args <- estimates
  
  if (hc) {
    args$p <- value
    what <- paste0("ssd_q", dist)
  } else {
    args$q <- value / rescale
    what <- paste0("ssd_p", dist)
  }
  
  est <- do.call(what, args)
  if (!ci) {
    return(no_ci_hcp(value = value, dist = dist, est = est, rescale = rescale, hc = hc))
  }
  
  censoring <- censoring / rescale
  
  ests <- boot_estimates(
    fun = fun, dist = dist, estimates = estimates,
    pars = pars, nboot = nboot, data = data, weighted = weighted,
    censoring = censoring, min_pmix = min_pmix,
    range_shape1 = range_shape1, range_shape2 = range_shape2,
    parametric = parametric, control = control, save_to = save_to,
    fix_weights = fix_weights
  )
  x <- value
  if (!hc) {
    x <- x / rescale
  }
  cis <- cis_estimates(ests, what, level = level, x = x, samples = samples)
  hcp <- ci_hcp(
    cis, estimates = ests, value = value, dist = dist,
    est = est, rescale = rescale, nboot = nboot, hc = hc
  )
  replace_min_pboot_na(hcp, min_pboot)
}

.ssd_hcp_tmbfit <- function(
    x, weight, value, ci, level, nboot, min_pboot, data, rescale, weighted, censoring, min_pmix,
    range_shape1, range_shape2, parametric, fix_weights, average, control, hc, save_to, samples,
    fun) {
  estimates <- estimates(x)
  dist <- .dist_tmbfit(x)
  pars <- .pars_tmbfit(x)
  if (fix_weights && average) {
    nboot <- round(nboot * weight)
  }
  .ssd_hcp(
    x, dist = dist, estimates = estimates, fun = fun, pars = pars,
    value = value, ci = ci, level = level, nboot = nboot,
    min_pboot = min_pboot, data = data, rescale = rescale, weighted = weighted, censoring = censoring,
    min_pmix = min_pmix, range_shape1 = range_shape1, range_shape2 = range_shape2,
    parametric = parametric, control = control, save_to = save_to, samples = samples,
    hc = hc
  )
}

group_samples <- function(hcp) {
  samples <- lapply(hcp, function(x) x[c("dist", "value", "samples")])
  samples <- bind_rows(samples)
  samples <- dplyr::group_by(samples, .data$value)
  samples <- dplyr::summarise(samples, samples = I(list(unlist(samples))))
  dplyr::ungroup(samples)
}

hcp_average <- function(hcp, weight, value, method, nboot, geometric) {
  samples <- group_samples(hcp)
  
  hcp <- lapply(hcp, function(x) x[c("value", "est", "se", "lcl", "ucl", "pboot")])
  hcp <- lapply(hcp, as.matrix)
  hcp <- Reduce(function(x, y) {
    abind(x, y, along = 3)
  }, hcp)
  suppressMessages(min <- apply(hcp, c(1, 2), min))
  suppressMessages(hcp <- apply(hcp, c(1, 2), weighted_mean, w = weight, geometric = geometric))
  min <- as.data.frame(min)
  hcp <- as.data.frame(hcp)
  tib <- tibble(
    dist = "average", value = value, est = hcp$est, se = hcp$se,
    lcl = hcp$lcl, ucl = hcp$ucl, wt = rep(1, length(value)),
    method = method, nboot = nboot, pboot = min$pboot
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
    hcp$samples <- I(list(numeric(0)))
  }
  hcp
}

hcp_ind <- function(hcp, weight, method) {
  hcp <- mapply(
    function(x, y) {
      x$wt <- y
      x
    },
    x = hcp, y = weight,
    USE.NAMES = FALSE, SIMPLIFY = FALSE
  )
  hcp <- bind_rows(hcp)
  hcp$method <- method
  hcp[c("dist", "value", "est", "se", "lcl", "ucl", "wt", "method", "nboot", "pboot", "samples")]
}

replace_estimates <- function(hcp, est) {
  est <- est[c("value", "est")]
  colnames(est) <- c("value", "est2")
  hcp <- dplyr::inner_join(hcp, est, by = c("value"))
  hcp$est <- hcp$est2
  hcp$est2 <- NULL
  hcp
}

.ssd_hcp_conventional <- function(x, value, ci, level, nboot, geometric, min_pboot, estimates,
                                  data, rescale, weighted, censoring, min_pmix,
                                  range_shape1, range_shape2, parametric, control,
                                  save_to, samples, fix_weights, hc, fun) {
  if (ci && fix_weights) {
    atleast1 <- round(glance(x)$weight * nboot) >= 1L
    x <- subset(x, names(x)[atleast1])
    estimates <- estimates[atleast1]
  }
  weight <- purrr::map_dbl(estimates, function(x) x$weight)
  hcp <- purrr::map2(
    x, weight, .ssd_hcp_tmbfit, value = value, ci = ci, level = level, nboot = nboot,
    min_pboot = min_pboot, data = data, rescale = rescale, weighted = weighted, censoring = censoring,
    min_pmix = min_pmix, range_shape1 = range_shape1, range_shape2 = range_shape2,
    parametric = parametric, fix_weights = fix_weights, average = TRUE, control = control,
    hc = hc, save_to = save_to, samples = samples || fix_weights, fun = fun
  )
  
  method <- if (parametric) "parametric" else "non-parametric"
  
  hcp <- hcp_average(hcp, weight, value, method, nboot, geometric = geometric)
  if (!fix_weights) {
    if (!samples) {
      hcp$samples <- I(list(numeric(0)))
    }
    return(hcp)
  }
  hcp_weighted(hcp, level = level, samples = samples, min_pboot = min_pboot)
}

.ssd_hcp_multi <- function(x, value, ci, level, nboot, min_pboot,
                           data, rescale, weighted, censoring, min_pmix,
                           range_shape1, range_shape2, parametric, control,
                           save_to, samples, fix_weights, hc) {
  estimates <- estimates(x, all_estimates = TRUE)
  dist <- "multi"
  fun <- fits_dists
  pars <- pars_fitdists(x)
  
  hcp <- .ssd_hcp(
    x, dist = dist, estimates = estimates, fun = fun, pars = pars,
    value = value, ci = ci, level = level, nboot = nboot, min_pboot = min_pboot,
    data = data, rescale = rescale, weighted = weighted, censoring = censoring,
    min_pmix = min_pmix, range_shape1 = range_shape1, range_shape2 = range_shape2,
    parametric = parametric, control = control, save_to = save_to,
    samples = samples, hc = hc, fix_weights = fix_weights
  )
  hcp$dist <- "average"
  method <- if (parametric) "parametric" else "non-parametric"
  hcp$method <- method
  hcp[c("dist", "value", "est", "se", "lcl", "ucl", "wt", "method", "nboot", "pboot", "samples")]
}

.ssd_hcp_ind <- function(x, value, ci, level, nboot, min_pboot, estimates,
                         data, rescale,
                         weighted, censoring, min_pmix, range_shape1,
                         range_shape2, parametric,
                         control, hc, save_to, samples, fun) {
  hcp <- purrr::map(x, .ssd_hcp_tmbfit, weight = 1,
                     value = value, ci = ci, level = level, nboot = nboot,
                     min_pboot = min_pboot,
                     data = data, rescale = rescale, weighted = weighted, censoring = censoring,
                     min_pmix = min_pmix, range_shape1 = range_shape1, range_shape2 = range_shape2,
                     parametric = parametric, fix_weights = FALSE, average = FALSE, control = control,
                     hc = hc, save_to = save_to, samples = samples, fun = fun
  )
  method <- if (parametric) "parametric" else "non-parametric"

  weight <- purrr::map_dbl(estimates, function(x) x$weight)
  
  hcp_ind(hcp, weight, method)
}

.ssd_hcp_fitdists_average <- function(
    x, value, data, ci, level, nboot, multi_est,
    min_pboot, min_pmix,parametric,rescale, weighted, multi_ci, censoring,
    range_shape1, range_shape2, fix_weights, estimates, control, hc, save_to,
    samples, fun) {
  
  if (.is_censored(censoring) && !identical_parameters(x)) {
    wrn("Model averaged estimates cannot be calculated for censored data when the distributions have different numbers of parameters.")
  }
  
  geometric = multi_est == "geometric"
  
  if (multi_ci) {
    hcp <- .ssd_hcp_multi(
      x, value, ci = ci, level = level, nboot = nboot,
      min_pboot = min_pboot, data = data, rescale = rescale, weighted = weighted, censoring = censoring,
      min_pmix = min_pmix, range_shape1 = range_shape1, range_shape2 = range_shape2,
      parametric = parametric, control = control, save_to = save_to, samples = samples,
      fix_weights = fix_weights, hc = hc
    )
    
    if (multi_est == "multi") {
      return(hcp)
    }
    
    est <- .ssd_hcp_conventional(
      x, value, ci = FALSE, level = level, nboot = nboot, geometric = geometric,
      min_pboot = min_pboot, estimates = estimates,
      data = data, rescale = rescale, weighted = weighted, censoring = censoring,
      min_pmix = min_pmix, range_shape1 = range_shape1, range_shape2 = range_shape2,
      parametric = parametric, control = control, save_to = save_to, samples = samples,
      fix_weights = fix_weights, hc = hc, fun = fun
    )
    
    hcp <- replace_estimates(hcp, est)
    
    return(hcp)
  }
  
  hcp <- .ssd_hcp_conventional(
    x, value, ci = ci, level = level, nboot = nboot, geometric = geometric,
    min_pboot = min_pboot, estimates = estimates,
    data = data, rescale = rescale, weighted = weighted, censoring = censoring,
    min_pmix = min_pmix, range_shape1 = range_shape1, range_shape2 = range_shape2,
    parametric = parametric, control = control, save_to = save_to, samples = samples,
    fix_weights = fix_weights, hc = hc, fun = fun
  )
  
  if (multi_est != "multi") {
    if (!fix_weights) {
      return(hcp)
    }
    est <- .ssd_hcp_conventional(
      x, value,
      ci = FALSE, level = level, nboot = nboot, geometric = geometric,
      min_pboot = min_pboot, estimates = estimates,
      data = data, rescale = rescale, weighted = weighted, censoring = censoring,
      min_pmix = min_pmix, range_shape1 = range_shape1, range_shape2 = range_shape2,
      parametric = parametric, control = control, save_to = save_to, samples = samples,
      fix_weights = fix_weights, hc = hc, fun = fun
    )
  } else {
    est <- .ssd_hcp_multi(
      x, value, ci = FALSE, level = level, nboot = nboot, min_pboot = min_pboot,
      data = data, rescale = rescale, weighted = weighted, censoring = censoring,
      min_pmix = min_pmix, range_shape1 = range_shape1, range_shape2 = range_shape2,
      parametric = parametric, control = control, save_to = save_to, samples = samples,
      fix_weights = fix_weights, hc = hc
    )
  }
  replace_estimates(hcp, est)
}

.ssd_hcp_fitdists <- function(
    x, value, ci, level, nboot, average, multi_est, min_pboot, parametric,
    multi_ci, fix_weights, control, hc, save_to, samples, fun) {
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
  
  if (parametric && ci && !identical(censoring, c(0, Inf))) {
    wrn("Parametric CIs cannot be calculated for censored data.")
    ci <- FALSE
  }
  
  if (parametric && ci && unequal) {
    wrn("Parametric CIs cannot be calculated for unequally weighted data.")
    ci <- FALSE
  }
  
  if (!ci) {
    nboot <- 0L
  }
  
  if (!average) {
    hcp <- .ssd_hcp_ind(
      x, value = value, ci = ci, level = level, nboot = nboot,
      min_pboot = min_pboot, estimates = estimates,
      data = data, rescale = rescale, weighted = weighted, censoring = censoring,
      min_pmix = min_pmix, range_shape1 = range_shape1, range_shape2 = range_shape2,
      parametric = parametric, control = control,
      hc = hc, save_to = save_to, samples = samples, fun = fun
    )
    return(hcp)
  }
  .ssd_hcp_fitdists_average(
    x = x, value = value, ci = ci, level = level, nboot = nboot, multi_est = multi_est,
    min_pboot = min_pboot, estimates = estimates, multi_ci = multi_ci,
    fix_weights = fix_weights,
    data = data, rescale = rescale, weighted = weighted, censoring = censoring,
    min_pmix = min_pmix, range_shape1 = range_shape1, range_shape2 = range_shape2,
    parametric = parametric, control = control,
    hc = hc, save_to = save_to, samples = samples, fun = fun
  )
}

ssd_hcp_fitdists <- function(
    x, value, ci, level, nboot, average, multi_est, delta, min_pboot,
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
  
  chkor_vld(vld_flag(multi_est), vld_string(multi_est))
  
  chk_number(delta)
  chk_gte(delta)
  chk_number(min_pboot)
  chk_range(min_pboot)
  chk_flag(parametric)
  
  chk_string(ci_method)
  chk_subset(ci_method, c("weighted_samples", "weighted_arithmetic", "multi_free", "multi_fixed"))
  
  fix_weights <- ci_method %in% c("weighted_samples", "multi_fixed")
  multi_ci <- ci_method %in% c("multi_free", "multi_fixed")
  
  chk_null_or(control, vld = vld_list)
  chk_null_or(save_to, vld = vld_dir)
  chk_flag(samples)
  
  if(vld_flag(multi_est)) {
    multi_est <- if(multi_est) "multi" else "arithmetic"
  }
  
  chk_subset(multi_est, c("arithmetic", "geometric", "multi"))
  
  x <- subset(x, delta = delta)
  
  hcp <- .ssd_hcp_fitdists(
    x, value = value, ci = ci, level = level, nboot = nboot,
    average = average, multi_est = multi_est, min_pboot = min_pboot,
    parametric = parametric, multi_ci = multi_ci, fix_weights = fix_weights,
    control = control, save_to = save_to, samples = samples, hc = hc, fun = fun
  )
  warn_min_pboot(hcp, min_pboot)
}
