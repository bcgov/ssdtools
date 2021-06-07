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

#' Hazard Percent
#'
#' Gets percent species protected at specified concentrations.
#'
#' @inheritParams params
#' @return A data frame of the conc and percent.
#' @export
ssd_hp <- function(x, ...) {
  UseMethod("ssd_hp")
}

.ssd_hp_tmbfit <- function(x, conc, ci, level, nboot, data, rescale, censoring, control, parallel, ncpus) {
  args <- estimates(x)
  args$q <- conc / rescale
  dist <- .dist_tmbfit(x)
  what <- paste0("p", dist)
  
  est <- do.call(what, args)
  if (!ci) {
    na <- rep(NA_real_, length(conc))
    return(tibble(
      dist = rep(dist, length(conc)), 
      conc = conc, 
      est = est * 100,
      se = na, 
      lcl = na, 
      ucl = na    
      ))
  }
  censoring <- censoring / rescale
  estimates <- boot_tmbfit(x, nboot = nboot, data = data, censoring = censoring,
                           control = control, parallel = parallel, ncpus = ncpus)
  cis <- cis_tmb(estimates, what, level = level, x = conc / rescale)
  tibble(
    dist = dist,
    conc = conc, 
    est = est * 100,
    se = cis$se * 100, 
    lcl = cis$lcl * 100, 
    ucl = cis$ucl * 100 
  )
}

.ssd_hp_fitdists <- function(x, conc, ci, level, nboot, control, parallel, ncpus,
                             average, ic) {
  if (!length(x) || !length(conc)) {
    no <- numeric(0)
    return(tibble(
      dist = character(0), conc = no, est = no, se = no,
      lcl = no, ucl = no,
    ))
  }

  if(is.null(control))
    control <- .control_fitdists(x)
  data <- .data_fitdists(x)
  rescale <- .rescale_fitdists(x)
  censoring <- .censoring_fitdists(x)
  
  if(ci && identical(censoring, c(NA_real_, NA_real_))) {
    wrn("CIs cannot be calculated for inconsistently censored data.")
    ci <- FALSE
  }
  
  hp <- lapply(x, .ssd_hp_tmbfit,
    conc = conc, ci = ci, level = level, nboot = nboot, data = data, 
    rescale = rescale, censoring = censoring,
    control = control,
    parallel = parallel, ncpus = ncpus
  )
  if (!average) {
    return(bind_rows(hp))
  }
  hp <- lapply(hp, function(x) x[2:6])
  hp <- lapply(hp, as.matrix)
  hp <- Reduce(function(x, y) {
    abind(x, y, along = 3)
  }, hp)
  weight <- .ssd_gof_fitdists(x)$weight
  suppressMessages(hp <- apply(hp, c(1, 2), weighted.mean, w = weight))
  hp <- as_tibble(hp)
  hp$conc <- conc
  hp$dist <- "average"
  hp <- hp[c("dist", "conc", "est", "se", "lcl", "ucl")]
}

#' @describeIn ssd_hp Hazard Percent fitdists
#' @export
#' @examples
#' ssd_hp(boron_dists, c(0, 1, 30, Inf))
ssd_hp.fitdists <- function(x, conc, ci = FALSE, level = 0.95, nboot = 1000,
                            control = NULL,
                            parallel = NULL, ncpus = 1,
                            average = TRUE, ic = "aicc", ...) {
  chk_string(ic)
  chk_subset(ic, c("aic", "aicc", "bic"))
  chk_null_or(control, chk_list)
  chk_unused(...)

  .ssd_hp_fitdists(x, conc,
    ci = ci, level = level, nboot = nboot, control = control,
    parallel = parallel, ncpus = ncpus,
    average = average, ic = ic
  )
}
