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
    pboot = numeric(0)
  )
}

no_ci_hcp <- function(value, dist, est, rescale, hc) {
  na <- rep(NA_real_, length(value))
  multiplier <- if(hc) rescale else 100
  hcp <- tibble(
    dist = rep(dist, length(value)),
    value = value,
    est = est * multiplier,
    se = na,
    lcl = na,
    ucl = na,
    wt = rep(1, length(value)),
    nboot = rep(0L, length(value)),
    pboot = na
  )
  hcp
}

ci_hcp <- function(cis, estimates, value, dist, est, rescale, nboot, hc) {
  multiplier <- if(hc) rescale else 100
  hcp <- tibble(
    dist = dist,
    value = value, 
    est = est * multiplier,
    se = cis$se * multiplier, 
    lcl = cis$lcl * multiplier, 
    ucl = cis$ucl * multiplier,
    wt = rep(1, length(value)),
    nboot = nboot, 
    pboot = length(estimates) / nboot
  )
  hcp
}

.ssd_hcp <- function(
    x, dist, estimates, 
    fun, pars, value, ci, level, nboot, min_pboot,
    data, rescale, weighted, censoring, min_pmix,
    range_shape1, range_shape2, parametric, control, hc) {
  
  args <- estimates
  
  if(hc) {
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
  
  ests <- boot_estimates(fun = fun, dist = dist, estimates = estimates, 
                         pars = pars, nboot = nboot, data = data, weighted = weighted,
                         censoring = censoring, min_pmix = min_pmix,
                         range_shape1 = range_shape1,
                         range_shape2 = range_shape2,
                         parametric = parametric,
                         control = control
  )
  x <- value
  if(!hc) {
    x <- x / rescale
  }
  cis <- cis_estimates(ests, what, level = level, x = x)
  hcp <- ci_hcp(cis, estimates = ests, value = value, dist = dist, 
                est = est, rescale = rescale, nboot = nboot, hc = hc)
  replace_min_pboot_na(hcp, min_pboot)
}

.ssd_hcp_tmbfit <- function(
    x, value, ci, level, nboot, min_pboot,
    data, rescale, weighted, censoring, min_pmix,
    range_shape1, range_shape2, parametric, control, hc,
    fun) {
  estimates <- estimates(x)
  dist <- .dist_tmbfit(x)
  pars <- .pars_tmbfit(x)
  
  .ssd_hcp(x, dist = dist, estimates = estimates, 
           fun = fun, pars = pars,
           value = value, ci = ci, level = level, nboot = nboot,
           min_pboot = min_pboot,
           data = data, rescale = rescale, weighted = weighted, censoring = censoring,
           min_pmix = min_pmix, range_shape1 = range_shape1, range_shape2 = range_shape2,
           parametric = parametric, control = control,
           hc = hc)
}

.ssd_hcp_multi <- function(x, value, ci, level, nboot, min_pboot,
                           data, rescale, weighted, censoring, min_pmix,
                           range_shape1, range_shape2, parametric, control, hc) {
  estimates <- estimates(x, multi = TRUE)
  dist <- "multi"
  fun <- fits_dists
  pars <- pars_fitdists(x)
  
  hcp <- .ssd_hcp(x, dist = dist, estimates = estimates, 
                  fun = fun, pars = pars,
                  value = value, ci = ci, level = level, nboot = nboot,
                  min_pboot = min_pboot,
                  data = data, rescale = rescale, weighted = weighted, censoring = censoring,
                  min_pmix = min_pmix, range_shape1 = range_shape1, range_shape2 = range_shape2,
                  parametric = parametric, control = control,
                  hc = hc)
  hcp$dist <- "average"
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
  hcp <- hcp[c("dist", "value", "est", "se", "lcl", "ucl", "wt", "method", "nboot", "pboot")]
  return(hcp)
}

hcp_average <- function(hcp, weight, value, method, nboot) {
  hcp <- lapply(hcp, function(x) x[c("value", "est", "se", "lcl", "ucl", "pboot")])
  hcp <- lapply(hcp, as.matrix)
  hcp <- Reduce(function(x, y) {
    abind(x, y, along = 3)
  }, hcp)
  suppressMessages(min <- apply(hcp, c(1, 2), min))
  suppressMessages(hcp <- apply(hcp, c(1, 2), weighted.mean, w = weight))
  min <- as.data.frame(min)
  hcp <- as.data.frame(hcp)
  tibble(
    dist = "average", value = value, est = hcp$est, se = hcp$se,
    lcl = hcp$lcl, ucl = hcp$ucl, wt = rep(1, length(value)),
    method = method, nboot = nboot, pboot = min$pboot
  )
}

.ssd_hcp_fitdists <- function(
    x, 
    value, 
    ci, 
    level, 
    nboot,
    average, 
    min_pboot, 
    parametric, 
    multi, 
    control,
    hc,
    fun) {
  
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
  estimates <- .list_estimates(x, multi = FALSE)
  
  if (parametric && ci && identical(censoring, c(NA_real_, NA_real_))) {
    wrn("Parametric CIs cannot be calculated for inconsistently censored data.")
    ci <- FALSE
  }
  
  if (parametric && ci && unequal) {
    wrn("Parametric CIs cannot be calculated for unequally weighted data.")
    ci <- FALSE
  }
  
  if (!ci) {
    nboot <- 0L
  }
  
  method <- if (parametric) "parametric" else "non-parametric"
  
  if(!average || !multi) {
    hcp <- purrr::map(x, .ssd_hcp_tmbfit,
                      value = value, ci = ci, level = level, nboot = nboot,
                      min_pboot = min_pboot,
                      data = data, rescale = rescale, weighted = weighted, censoring = censoring,
                      min_pmix = min_pmix, range_shape1 = range_shape1, range_shape2 = range_shape2,
                      parametric = parametric, control = control,
                      hc = hc, fun = fun)
    
    weight <- purrr::map_dbl(estimates, function(x) x$weight)
    if(!average) {
      return(hcp_ind(hcp, weight, method))
    }
    return(hcp_average(hcp, weight, value, method, nboot))
  }
  
  hcp <- .ssd_hcp_multi(
    x, value, ci = ci, level = level, nboot = nboot,
    min_pboot = min_pboot,
    data = data, rescale = rescale, weighted = weighted, censoring = censoring,
    min_pmix = min_pmix, range_shape1 = range_shape1, range_shape2 = range_shape2,
    parametric = parametric, control = control, hc = hc)
  
  hcp$method <- method
  hcp <- hcp[c("dist", "value", "est", "se", "lcl", "ucl", "wt", "method", "nboot", "pboot")]
  hcp
}

ssd_hcp_fitdists <- function(
    x, 
    value, 
    ci, 
    level,
    nboot,
    average,
    delta,
    min_pboot,
    parametric,
    multi,
    control,
    hc,
    fun = fit_tmb) {
  
  chk_vector(value)
  chk_numeric(value)
  chk_flag(ci)
  chk_number(level)
  chk_range(level)
  chk_whole_number(nboot)
  chk_gt(nboot)
  chk_flag(average)
  chk_number(delta)
  chk_gte(delta)
  chk_number(min_pboot)
  chk_range(min_pboot)
  chk_flag(parametric)
  chk_flag(multi)
  chk_null_or(control, vld = vld_list)
  
  x <- subset(x, delta = delta)
  
  hcp <- .ssd_hcp_fitdists(
    x, 
    value = value,
    ci = ci, 
    level = level, 
    nboot = nboot,
    average = average, 
    min_pboot = min_pboot,
    parametric = parametric,
    multi = multi,
    control = control,
    hc = hc,
    fun = fun
  )
  warn_min_pboot(hcp, min_pboot)
}
