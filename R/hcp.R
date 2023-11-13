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

no_ssd_hcp <- function(hc) {
  x <- tibble(
    dist = character(0),
    percent = numeric(0),
    est = numeric(0),
    se = numeric(0),
    lcl = numeric(0),
    ucl = numeric(0),
    wt = numeric(0),
    nboot = integer(0),
    pboot = numeric(0)
  )
  if(!hc) {
    x <- dplyr::rename(x, conc = percent)
  }
  x
}

no_ci_hcp <- function(value, dist, est, rescale, hc) {
  na <- rep(NA_real_, length(value))
  x <- tibble(
    dist = rep(dist, length(value)),
    percent = value * 100,
    est = est * rescale,
    se = na,
    lcl = na,
    ucl = na,
    wt = rep(1, length(value)),
    nboot = rep(0L, length(value)),
    pboot = na
  )
  if(!hc) {
    x <- dplyr::rename(x, conc = "percent")
    x <- dplyr::mutate(x, conc = .data$conc / 100, 
                       est = .data$est / rescale * 100)
  }
  x
}

.ssd_hcp_tmbfit <- function(x, value, ci, level, nboot, min_pboot,
                            data, rescale, weighted, censoring, min_pmix,
                            range_shape1, range_shape2, parametric, control, hc) {
  args <- estimates(x)
  dist <- .dist_tmbfit(x)
  
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
  fun <- safely(fit_tmb)
  estimates <- boot_estimates(
    x, fun = fun, nboot = nboot, data = data, weighted = weighted,
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
  cis <- cis_estimates(estimates, what, level = level, x = x)
  
  multiplier <- if(hc) rescale else 100
  hcp <- tibble(
    dist = dist,
    percent = value * 100, 
    est = est * multiplier,
    se = cis$se * multiplier, 
    lcl = cis$lcl * multiplier, 
    ucl = cis$ucl * multiplier,
    wt = rep(1, length(value)),
    nboot = nboot, 
    pboot = length(estimates) / nboot
  )
  if(!hc) {
    hcp <- dplyr::rename(hcp, conc = "percent")
    hcp <- dplyr::mutate(hcp, conc = value)
  }
  replace_min_pboot_na(hcp, min_pboot)
}

.ssd_hcp_fitdists <- function(
    x, value, ci, level, nboot,
    average, delta, min_pboot,
    parametric, root, control, hc
) {
  
  if(hc) {
    return(.ssd_hc_fitdists(
      x, 
      percent = value, 
      ci = ci,
      level = level, 
      nboot = nboot,
      average = average, 
      min_pboot = min_pboot, 
      parametric = parametric, 
      root = root, 
      control = control))
  }
  .ssd_hp_fitdists(
    x, 
    conc = value, 
    ci = ci,
    level = level, 
    nboot = nboot,
    average = average, 
    min_pboot = min_pboot, 
    parametric = parametric, 
    root = root, 
    control = control)
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
    root,
    control,
    hc,
    ...) {
  
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
  chk_flag(root)
  chk_null_or(control, vld = vld_list)
  
  x <- subset(x, delta = delta)
  
  hc <- .ssd_hcp_fitdists(
    x, 
    value = value,
    ci = ci, 
    level = level, 
    nboot = nboot,
    average = average, 
    min_pboot = min_pboot,
    parametric = parametric,
    root = root,
    control = control,
    hc = hc,
  )
  warn_min_pboot(hc, min_pboot)
}
