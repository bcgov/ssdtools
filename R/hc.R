#    Copyright 2015 Province of British Columbia
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

#' Hazard Concentration
#'
#' Gets concentrations that protect specified percentages of species.
#'
#' @inheritParams params
#' @param hc A numeric vector of percentages.
#' @return A data frame of the percent and concentrations.
#' @export
ssd_hc <- function(x, ...) {
  UseMethod("ssd_hc")
}

no_ssd_hc <- function() {
  tibble(
    dist = character(0),
    percent = numeric(0),
    est = numeric(0),
    se = numeric(0),
    lcl = numeric(0),
    ucl = numeric(0)
  )
}

.ssd_hc_dist <- function(x, dist, proportion) {
  fun <- paste0("q", dist)
  args <- list(p = proportion)
  args <- c(as.list(x), args)
  est <- do.call(fun, args)
  tibble(
    dist = dist,
    percent = proportion * 100, est = est,
    se = NA_real_, lcl = NA_real_, ucl = NA_real_
  )
}

.ssd_hc_tmbfit <- function(x, proportion, ci, level, nboot, data, rescale,  weighted, censoring, control, parallel, ncpus) {
  args <- estimates(x)
  args$p <- proportion
  dist <- .dist_tmbfit(x)
  what <- paste0("q", dist)
  
  est <- do.call(what, args)
  if (!ci) {
    na <- rep(NA_real_, length(proportion))
    return(tibble(
      dist = rep(dist, length(proportion)),
      percent = proportion * 100, 
      est = est * rescale,
      se = na, 
      lcl = na, 
      ucl = na))
  }
  censoring <- censoring / rescale
  estimates <- boot_tmbfit(x, nboot = nboot, data = data, weighted = weighted,
                           censoring = censoring, 
                           control = control, parallel = parallel, ncpus = ncpus)
  cis <- cis_tmb(estimates, what, level = level, x = proportion)
  tibble(
    dist = dist,
    percent = proportion * 100, est = est * rescale,
    se = cis$se * rescale, lcl = cis$lcl * rescale, ucl = cis$ucl * rescale
  )
}

.ssd_hc_fitdists <- function(x, percent, ci, level, nboot, control, parallel, ncpus,
                             average, ic) {
  if (!length(x) || !length(percent)) {
    return(no_ssd_hc())
  }
  
  if(is.null(control))
    control <- .control_fitdists(x)

  data <- .data_fitdists(x)
  rescale <- .rescale_fitdists(x)
  censoring <- .censoring_fitdists(x)
  weighted <- .weighted_fitdists(x)
  unequal <- .unequal_fitdists(x)
  
  if(ci && identical(censoring, c(NA_real_, NA_real_))) {
    wrn("CIs cannot be calculated for inconsistently censored data.")
    ci <- FALSE
  }
  
  if(ci && unequal) {
    wrn("CIs cannot be calculated for unequally weighted data.")
    ci <- FALSE
  }
  
  hc <- lapply(x, .ssd_hc_tmbfit,
    proportion = percent / 100, ci = ci, level = level, nboot = nboot,
    data = data, rescale = rescale, weighted = weighted, censoring = censoring,
    parallel = parallel, ncpus = ncpus, control = control
  )
  if (!average) {
    return(bind_rows(hc))
  }
  hc <- lapply(hc, function(x) x[c("percent", "est", "se", "lcl", "ucl")])
  hc <- lapply(hc, as.matrix)
  hc <- Reduce(function(x, y) {
    abind(x, y, along = 3)
  }, hc)
  weight <- .ssd_gof_fitdists(x, pvalue = TRUE)$weight
  suppressMessages(hc <- apply(hc, c(1, 2), weighted.mean, w = weight))
  hc <- as.data.frame(hc)
  tibble(dist = "average", percent = percent, est = hc$est, se = hc$se, 
         lcl = hc$lcl, ucl = hc$ucl)
}

#' @describeIn ssd_hc Hazard Concentration list of distributions
#' @export
#' @examples
#' ssd_hc(list("lnorm" = NULL))
#' ssd_hc(list("lnorm" = list(meanlog = 2, sdlog = 1)))
ssd_hc.list <- function(x, percent = 5, hc = 5, ...) {
  chk_list(x)
  chk_named(x)
  chk_unique(names(x))
  chk_unused(...)
  
  if (!missing(hc)) {
    deprecate_stop("0.1.0", "ssd_hc(hc = )", "ssd_hc(percent = )")
  }
  
  if (!length(x)) {
    return(no_ssd_hc())
  }
  hc <- mapply(.ssd_hc_dist, x, names(x),
               MoreArgs = list(proportion = percent / 100),
               SIMPLIFY = FALSE
  )
  bind_rows(hc)
}

#' @describeIn ssd_hc Hazard Concentration fitdists
#' @export
#' @examples
#' boron_dists <- ssd_fit_dists(ssdtools::boron_data)
#' ssd_hc(boron_dists, c(0, 1, 30, Inf))
ssd_hc.fitdists <- function(x, percent = 5, hc = 5, ci = FALSE, level = 0.95, nboot = 1000, 
                            control = NULL, 
                            parallel = NULL, ncpus = 1, average = TRUE, ic = "aicc", ...) {
  chk_string(ic)
  chk_subset(ic, c("aic", "aicc", "bic"))
  chk_null_or(control, chk_list)
  chk_unused(...)

  if (!missing(hc)) {
    deprecate_stop("0.1.0", "ssd_hc(hc = )", "ssd_hc(percent = )")
  }
  
  .ssd_hc_fitdists(x, percent,
    ci = ci, level = level, nboot = nboot, control = control,
    parallel = parallel, ncpus = ncpus,
    average = average, ic = ic
  )
}
