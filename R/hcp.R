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

ci_hcp <- function(cis, estimates, value, dist, est, rescale, nboot, hc) {
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
  hcp
}

.ssd_hcp_tmbfit <- function(
    x, value, ci, level, nboot, min_pboot,
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
  hcp <- ci_hcp(cis, estimates = estimates, value = value, dist = dist, 
                est = est, rescale = rescale, nboot = nboot, hc = hc)
  replace_min_pboot_na(hcp, min_pboot)
  
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
    root, 
    control,
    hc) {
  
  if (!length(x) || !length(value)) {
    hcp <- no_hcp()
    if(hc) {
      hcp <- dplyr::rename(hcp, percent = "value")
    } else {
      hcp <- dplyr::rename(hcp, conc = "value")
    }
    return(hcp)
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
  wt_est_nest <- wt_est_nest(x)
  
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
  
  if(hc) {
    value <- value / 100
  }
  
  if(root && average) {
    seeds <- seed_streams(length(value))
    hcs <- future_map(
      value, .ssd_hcp_root, 
      wt_est_nest = wt_est_nest, ci = ci, level = level, nboot = nboot,
      min_pboot = min_pboot,
      data = data, rescale = rescale, weighted = weighted, censoring = censoring,
      min_pmix = min_pmix, range_shape1 = range_shape1, range_shape2 = range_shape2,
      parametric = parametric, control = control, hc = hc,
      .options = furrr::furrr_options(seed = seeds))
    
    hcp <- dplyr::bind_rows(hcs)
    
    method <- if (parametric) "parametric" else "non-parametric"
    
    hcp <- tibble(
      dist = "average", value = value, est = hcp$est, se = hcp$se,
      lcl = hcp$lcl, ucl = hcp$ucl, wt = rep(1, length(value)),
      method = method, nboot = nboot, pboot = hcp$pboot
    )
    if(hc) {
      hcp <- dplyr::rename(hcp, percent = "value")
      hcp <- dplyr::mutate(hcp, percent = as.integer(round(.data$percent * 100)))
    } else {
      hcp <- dplyr::rename(hcp, conc = "value")
    }
    return(hcp)
  }
  
  seeds <- seed_streams(length(x))
  
  hcp <- future_map(x, .ssd_hcp_tmbfit,
                    value = value, ci = ci, level = level, nboot = nboot,
                    min_pboot = min_pboot,
                    data = data, rescale = rescale, weighted = weighted, censoring = censoring,
                    min_pmix = min_pmix, range_shape1 = range_shape1, range_shape2 = range_shape2,
                    parametric = parametric, control = control,
                    .options = furrr::furrr_options(seed = seeds),
                    hc = hc)
  
  weight <- wt_est_nest$weight
  if (!average) {
    hcp <- mapply(
      function(x, y) {
        x$wt <- y
        x
      },
      x = hcp, y = weight,
      USE.NAMES = FALSE, SIMPLIFY = FALSE
    )
    hcp <- bind_rows(hcp)
    hcp$method <- if (parametric) "parametric" else "non-parametric"
    #FIXME: do we want wt for !hc
    if(hc) {
      hcp <- hcp[c("dist", "percent", "est", "se", "lcl", "ucl", "wt", "method", "nboot", "pboot")]
    } else {
      hcp <- hcp[c("dist", "conc", "est", "se", "lcl", "ucl", "method", "nboot", "pboot")]
    }
    return(hcp)
  }
  if(hc) {
    hcp <- lapply(hcp, function(x) x[c("percent", "est", "se", "lcl", "ucl", "pboot")])
  } else {
    hcp <- lapply(hcp, function(x) x[c("conc", "est", "se", "lcl", "ucl", "pboot")])
  }
  hcp <- lapply(hcp, as.matrix)
  hcp <- Reduce(function(x, y) {
    abind(x, y, along = 3)
  }, hcp)
  suppressMessages(min <- apply(hcp, c(1, 2), min))
  suppressMessages(hcp <- apply(hcp, c(1, 2), weighted.mean, w = weight))
  min <- as.data.frame(min)
  hcp <- as.data.frame(hcp)
  method <- if (parametric) "parametric" else "non-parametric"
  out <- tibble(
    dist = "average", value = value, est = hcp$est, se = hcp$se,
    lcl = hcp$lcl, ucl = hcp$ucl, wt = rep(1, length(value)),
    method = method, nboot = nboot, pboot = min$pboot
  )
  if(hc) {
    out <- dplyr::rename(out, percent = "value")
    out <- dplyr::mutate(out, percent = as.integer(round(.data$percent * 100)))
  } else {
    out <- dplyr::rename(out, conc = "value")
  }
  out
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
    hc) {
  
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
  
  hcp <- .ssd_hcp_fitdists(
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
    hc = hc
  )
  warn_min_pboot(hcp, min_pboot)
}
