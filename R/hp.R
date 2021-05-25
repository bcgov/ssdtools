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

.ssd_hp_tmbfit <- function(x, conc, ci, level, nboot, parallel, ncpus) {
  chk_vector(conc)
  chk_numeric(conc)
  chk_number(level)
  chk_range(level)
  
  args <- estimates(x)
  args$q <- conc
  dist <- .dist_tmbfit(x)
  what <- paste0("p", dist)
  
  est <- do.call(what, args)
  if (!ci) {
    na <- rep(NA_real_, length(conc))
    return(as_tibble(data.frame(
      dist = rep(dist, length(conc)), conc = conc, est = est * 100,
      se = na, lcl = na, ucl = na,
      stringsAsFactors = FALSE
    )))
  }
  estimates <- boot_tmbfit(x, nboot = nboot, parallel = parallel, ncpus = ncpus)
  cis <- cis_tmb(estimates, what, level = level, x = conc)
  as_tibble(data.frame(
    dist = dist,
    conc = conc, est = est * 100,
    se = cis$se * 100, lcl = cis$lcl * 100, ucl = cis$ucl * 100, 
    stringsAsFactors = FALSE
  ))
}

.ssd_hp_fitdists <- function(x, conc, ci, level, nboot, parallel, ncpus,
                             average, ic) {
  if (!length(x) || !length(conc)) {
    no <- numeric(0)
    return(as_tibble(data.frame(
      dist = character(0), conc = no, est = no, se = no,
      lcl = no, ucl = no,
      stringsAsFactors = FALSE
    )))
  }

  hp <- lapply(x, .ssd_hp_tmbfit,
    conc = conc, ci = ci, level = level, nboot = nboot,
    parallel = parallel, ncpus = ncpus
  )
  if (!average) {
    hp <- do.call("rbind", hp)
    row.names(hp) <- NULL
    return(as_tibble(hp))
  }
  hp <- lapply(hp, function(x) x[2:6])
  hp <- lapply(hp, as.matrix)
  hp <- Reduce(function(x, y) {
    abind(x, y, along = 3)
  }, hp)
  weight <- .ssd_gof_fitdists(x)$weight
  suppressMessages(hp <- apply(hp, c(1, 2), weighted.mean, w = weight))
  hp <- as.data.frame(hp)
  hp$conc <- conc
  hp$dist <- "average"
  hp <- hp[c("dist", "conc", "est", "se", "lcl", "ucl")]
  as_tibble(hp)
}

#' @describeIn ssd_hp Hazard Percent fitdists
#' @export
#' @examples
#' ssd_hp(boron_dists, c(0, 1, 30, Inf))
ssd_hp.fitdists <- function(x, conc, ci = FALSE, level = 0.95, nboot = 1000,
                            parallel = NULL, ncpus = 1,
                            average = TRUE, ic = "aicc", ...) {
  chk_string(ic)
  chk_subset(ic, c("aic", "aicc", "bic"))
  chk_unused(...)

  .ssd_hp_fitdists(x, conc,
    ci = ci, level = level, nboot = nboot,
    parallel = parallel, ncpus = ncpus,
    average = average, ic = ic
  )
}
