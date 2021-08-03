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
#' Gets percent of species protected at specified concentration(s).
#' 
#' If `ci = TRUE` uses parameteric bootstrapping to get confidence intervals on the 
#' hazard percent(s).
#'
#' @inheritParams params
#' @return A tibble of corresponding hazard percents.
#' @seealso [`ssd_hc()`]
#' @export
#' @examples 
#' fits <- ssd_fit_dists(ssdtools::boron_data)
#' ssd_hp(fits, conc = 1)
ssd_hp <- function(x, ...) {
  UseMethod("ssd_hp")
}

no_ssd_hp <- function() {
  tibble(
    dist = character(0),
    conc = numeric(0),
    est = numeric(0),
    se = numeric(0),
    lcl = numeric(0),
    ucl = numeric(0),
    nboot = integer(0),
    pboot = numeric(0)
  )
}

.ssd_hp_tmbfit <- function(x, conc, ci, level, nboot, data, rescale, weighted, censoring,
                           min_pmix, control) {
  args <- estimates(x)
  args$q <- conc / rescale
  dist <- .dist_tmbfit(x)
  what <- paste0("ssd_p", dist)
  
  est <- do.call(what, args)
  if (!ci) {
    na <- rep(NA_real_, length(conc))
    return(tibble(
      dist = rep(dist, length(conc)), 
      conc = conc, 
      est = est * 100,
      se = na, 
      lcl = na, 
      ucl = na,
      nboot = rep(0L, length(conc)),
      pboot = na))
  }
  censoring <- censoring / rescale
  estimates <- boot_tmbfit(x, nboot = nboot, data = data, 
                           weighted = weighted, censoring = censoring,
                           min_pmix = min_pmix,
                           control = control)
  cis <- cis_tmb(estimates, what, level = level, x = conc / rescale)
  tibble(
    dist = dist,
    conc = conc, 
    est = est * 100,
    se = cis$se * 100, 
    lcl = cis$lcl * 100, 
    ucl = cis$ucl * 100,
    nboot = nboot, pboot = length(estimates) / nboot
  )
}

.ssd_hp_fitdists <- function(x, conc, ci, level, nboot, min_pboot, control,
                             average) {
  if (!length(x) || !length(conc)) {
    return(no_ssd_hp())
  }
  
  if(is.null(control))
    control <- .control_fitdists(x)
  data <- .data_fitdists(x)
  rescale <- .rescale_fitdists(x)
  censoring <- .censoring_fitdists(x)
  min_pmix <- .min_pmix_fitdists(x)
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
  if(!ci) nboot <- 0L
  
  seeds <- seed_streams(length(x))
  
  hp <- future_map(x, .ssd_hp_tmbfit,
               conc = conc, ci = ci, level = level, nboot = nboot, data = data, 
               rescale = rescale,  weighted = weighted, censoring = censoring,
               min_pmix = min_pmix,
               control = control, .options = furrr::furrr_options(seed = seeds))
  ind <- bind_rows(hp)
  if(any(!is.na(ind$pboot) & ind$pboot < min_pboot)) {
    wrn("One or more pboot values less than ", min_pboot, " (decrease min_pboot with caution).")
    return(no_ssd_hp())
  }
  if (!average) {
    return(ind)
  }
  hp <- lapply(hp, function(x) x[c("est", "se", "lcl", "ucl", "pboot")])
  hp <- lapply(hp, as.matrix)
  hp <- Reduce(function(x, y) {
    abind(x, y, along = 3)
  }, hp)
  weight <- glance(x)$weight
  suppressMessages(hp <- apply(hp, c(1, 2), weighted.mean, w = weight))
  hp <- as_tibble(hp)
  hp$conc <- conc
  hp$dist <- "average"
  hp$nboot <- nboot
  hp[c("dist", "conc", "est", "se", "lcl", "ucl", "nboot", "pboot")]
}

#' @describeIn ssd_hp Hazard Percents for fitdists Object
#' @export
ssd_hp.fitdists <- function(x, conc, ci = FALSE, level = 0.95, nboot = 1000,
                            average = TRUE, delta = 7, min_pboot = 0.99,
                            control = NULL,
                            ...) {
  chk_vector(conc)
  chk_numeric(conc)
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
  chk_null_or(control, chk_list)
  chk_unused(...)
  
  x <- subset(x, delta = delta)
  .ssd_hp_fitdists(x, conc,
                   ci = ci, level = level, nboot = nboot, 
                   average = average, min_pboot = min_pboot,
                   control = control)
}
