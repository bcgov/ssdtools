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

replace_min_pboot_na <- function(x, min_pboot) {
  x[!is.na(x$pboot) & x$pboot < min_pboot, c("se", "lcl", "ucl")] <- NA_real_
  x
}

ci_hcp <- function(cis, estimates, value, dist, est, rescale, nboot, hc) {
  rescale <- if (hc) rescale else 1

  tibble(
    dist = dist,
    value = value,
    est = unscale(est, rescale),
    log_se = log(unscale(exp(cis$log_se), rescale)),
    se = unscale(cis$se, rescale),
    lcl = unscale(cis$lcl, rescale),
    ucl = unscale(cis$ucl, rescale),
    wt = rep(1, length(value)),
    nboot = nboot,
    pboot = length(estimates) / nboot,
    samples = I(lapply(cis$samples, function(x) unscale(x, rescale)))
  )
}

no_ci_hcp <- function(value, dist, est, rescale, hc) {
  na <- rep(NA_real_, length(value))
  na_chr <- rep(NA_character_, length(value))
  rescale <- if (hc) rescale else 1

  tibble(
    dist = rep(dist, length(value)),
    value = value,
    est = unscale(est, rescale),
    se = na,
    log_se = na,
    lcl = na,
    ucl = na,
    wt = rep(1, length(value)),
    nboot = rep(0L, length(value)),
    pboot = 1,
    samples = list(numeric(0))
  )
}

hcp_tmbfit2 <- function(
    x, dist, estimates, fun, pars, value, ci, level, nboot, min_pboot,
    data, rescale, weighted, censoring, min_pmix,
    range_shape1, range_shape2, parametric, control, save_to, samples, hc,
    est_method, ci_method) {
  args <- estimates

  if (hc) {
    args$p <- value
    what <- paste0("ssd_q", dist)
  } else {
    args$q <- rescale(value, rescale)
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
    ci_method = ci_method
  )
  x <- value
  if (!hc) {
    x <- x / rescale
  }
  cis <- cis_estimates(ests, what, level = level, x = x, samples = samples)
  hcp <- ci_hcp(
    cis,
    estimates = ests, value = value, dist = dist,
    est = est, rescale = rescale, nboot = nboot, hc = hc
  )
  replace_min_pboot_na(hcp, min_pboot)
}

hcp_tmbfit <- function(
    x, nboot, value, ci, level, min_pboot, data, rescale, weighted, censoring, min_pmix,
    range_shape1, range_shape2, parametric, est_method, ci_method, average, control, hc, save_to, samples,
    fun) {
  estimates <- estimates(x)
  dist <- .dist_tmbfit(x)
  pars <- .pars_tmbfit(x)

  hcp_tmbfit2(
    x,
    dist = dist, estimates = estimates, fun = fun, pars = pars,
    value = value, ci = ci, level = level, nboot = nboot,
    min_pboot = min_pboot, data = data, rescale = rescale, weighted = weighted, censoring = censoring,
    min_pmix = min_pmix, range_shape1 = range_shape1, range_shape2 = range_shape2,
    control = control, save_to = save_to, samples = samples,
    hc = hc, ci_method = ci_method, est_method = est_method, parametric = parametric
  )
}
