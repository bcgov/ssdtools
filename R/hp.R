# Copyright 2023 Province of British Columbia
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
#' Gets percent of species affected at specified concentration(s).
#'
#' If `ci = TRUE` uses parameteric bootstrapping to get confidence intervals on the
#' hazard percent(s).
#'
#' @inheritParams params
#' @return A tibble of corresponding hazard percents.
#' @seealso [`ssd_hc()`]
#' @export
#' @examples
#' fits <- ssd_fit_dists(ssddata::ccme_boron)
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
    wt = numeric(0),
    nboot = integer(0),
    pboot = numeric(0)
  )
}

.ssd_hp_tmbfit <- function(x, conc, ci, level, nboot, min_pboot,
                           data, rescale, weighted, censoring,
                           min_pmix, range_shape1, range_shape2, parametric, control) {
  args <- estimates(x) #TODO: checkout estimates
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
      wt = rep(1, length(conc)),
      nboot = rep(0L, length(conc)),
      pboot = na
    ))
  }
  censoring <- censoring / rescale
  fun <- safely(fit_tmb)
  estimates <- boot_estimates(x,
    fun = fun, nboot = nboot, data = data,
    weighted = weighted, censoring = censoring,
    min_pmix = min_pmix,
    range_shape1 = range_shape1,
    range_shape2 = range_shape2,
    parametric = parametric,
    control = control
  )
  cis <- cis_estimates(estimates, what, level = level, x = conc / rescale)
  hp <- tibble(
    dist = dist,
    conc = conc,
    est = est * 100,
    se = cis$se * 100,
    lcl = cis$lcl * 100,
    ucl = cis$ucl * 100,
    wt = rep(1, length(conc)),
    nboot = nboot, pboot = length(estimates) / nboot
  )
  replace_min_pboot_na(hp, min_pboot)
}

.ssd_hp_fitdists <- function(
    x, 
    conc, 
    ci, 
    level, 
    nboot,
    average, 
    min_pboot, 
    parametric, 
    root, 
    control) {

  if (!length(x) || !length(conc)) {
    return(no_ssd_hp())
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
  
  if(root && average) {
    seeds <- seed_streams(length(conc))
    hps <- future_map(
      conc, .ssd_hp_root, 
      wt_est_nest = wt_est_nest, ci = ci, level = level, nboot = nboot,
      min_pboot = min_pboot,
      data = data, rescale = rescale, weighted = weighted, censoring = censoring,
      min_pmix = min_pmix, range_shape1 = range_shape1, range_shape2 = range_shape2,
      parametric = parametric, control = control,
      .options = furrr::furrr_options(seed = seeds))

    hp <- dplyr::bind_rows(hps)
    
    method <- if (parametric) "parametric" else "non-parametric"
    
    return(
      tibble(
        dist = "average", conc = conc, est = hp$est, se = hp$se,
        lcl = hp$lcl, ucl = hp$ucl, wt = rep(1, length(conc)),
        method = method, nboot = nboot, pboot = hp$pboot
      )
    )
  }
  
  seeds <- seed_streams(length(x))

  hp <- future_map(x, .ssd_hp_tmbfit,
    conc = conc, ci = ci, level = level, nboot = nboot,
    min_pboot = min_pboot, data = data,
    rescale = rescale, weighted = weighted, censoring = censoring,
    min_pmix = min_pmix, range_shape1 = range_shape1, range_shape2 = range_shape2,
    parametric = parametric,
    control = control, .options = furrr::furrr_options(seed = seeds)
  )
  
  weight <- wt_est_nest$weight
  if (!average) {
    hp <- mapply(
      function(x, y) {
        x$wt <- y
        x
      },
      x = hp, y = weight,
      USE.NAMES = FALSE, SIMPLIFY = FALSE
    )
    hp <- bind_rows(hp)
    hp$method <- if (parametric) "parametric" else "non-parametric"
    hp <- hp[c("dist", "conc", "est", "se", "lcl", "ucl", "method", "nboot", "pboot")]
    return(hp)
  }
  hp <- lapply(hp, function(x) x[c("est", "se", "lcl", "ucl", "pboot")])
  hp <- lapply(hp, as.matrix)
  hp <- Reduce(function(x, y) {
    abind(x, y, along = 3)
  }, hp)
  suppressMessages(min <- apply(hp, c(1, 2), min))
  suppressMessages(hp <- apply(hp, c(1, 2), weighted.mean, w = weight))
  min <- as.data.frame(min)
  hp <- as_tibble(hp)
  hp$conc <- conc
  hp$dist <- "average"
  hp$wt <- 1
  hp$nboot <- nboot
  hp$pboot <- min$pboot
  hp$method <- if (parametric) "parametric" else "non-parametric"
  hp[c("dist", "conc", "est", "se", "lcl", "ucl", "wt", "method", "nboot", "pboot")]
}

#' @describeIn ssd_hp Hazard Percents for fitdists Object
#' @export
ssd_hp.fitdists <- function(
    x, 
    conc = 1, 
    ci = FALSE, 
    level = 0.95, 
    nboot = 1000,
    average = TRUE, 
    delta = 7, 
    min_pboot = 0.99,
    parametric = TRUE,
    root = FALSE,
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
  chk_flag(parametric)
  chk_flag(root)
  chk_null_or(control, vld = vld_list)
  chk_unused(...)

  x <- subset(x, delta = delta)
  hp <- .ssd_hp_fitdists(
    x, 
    conc,
    ci = ci, 
    level = level, 
    nboot = nboot,
    average = average, 
    min_pboot = min_pboot,
    parametric = parametric,
    root = root,
    control = control
  )
  warn_min_pboot(hp, min_pboot)
}
