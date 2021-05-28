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

.ssd_hc_dist <- function(x, dist, percent) {
  chk_vector(percent)
  chk_numeric(percent)

  percent <- percent / 100
  fun <- paste0("q", dist)
  args <- list(p = percent)
  args <- c(as.list(x), args)
  est <- do.call(fun, args)
  tibble(
    dist = dist,
    percent = percent * 100, est = est,
    se = NA_real_, lcl = NA_real_, ucl = NA_real_
  )
}

.ssd_hc_tmbfit <- function(x, percent, ci, level, nboot, parallel, ncpus) {
  chk_vector(percent)
  chk_numeric(percent)
  chk_number(level)
  chk_range(level)
  
  percent <- percent / 100
  
  args <- estimates(x)
  args$p <- percent
  dist <- .dist_tmbfit(x)
  what <- paste0("q", dist)
  
  est <- do.call(what, args)
  if (!ci) {
    na <- rep(NA_real_, length(percent))
    return(tibble(
      dist = rep(dist, length(percent)),
      percent = percent * 100, 
      est = est,
      se = na, 
      lcl = na, 
      ucl = na))
  }
  estimates <- boot_tmbfit(x, nboot = nboot, parallel = parallel, ncpus = ncpus)
  cis <- cis_tmb(estimates, what, level = level, x = percent)
  tibble(
    dist = dist,
    percent = percent * 100, est = est,
    se = cis$se, lcl = cis$lcl, ucl = cis$ucl  
  )
}

.ssd_hc_fitdists <- function(x, percent, ci, level, nboot, parallel, ncpus,
                             average, ic) {
  if (!length(x) || !length(percent)) {
    return(no_ssd_hc())
  }

  hc <- lapply(x, .ssd_hc_tmbfit,
    percent = percent, ci = ci, level = level, nboot = nboot,
    parallel = parallel, ncpus = ncpus
  )
  if (!average) {
    hc <- do.call("rbind", hc)
    row.names(hc) <- NULL
    return(as_tibble(hc))
  }
  hc <- lapply(hc, function(x) x[c("percent", "est", "se", "lcl", "ucl")])
  hc <- lapply(hc, as.matrix)
  hc <- Reduce(function(x, y) {
    abind(x, y, along = 3)
  }, hc)
  weight <- .ssd_gof_fitdists(x)$weight
  suppressMessages(hc <- apply(hc, c(1, 2), weighted.mean, w = weight))
  hc <- as.data.frame(hc)
  tibble(dist = "average", percent = percent, est = hc$est, se = hc$se, 
         lcl = hc$lcl, ucl = hc$ucl)
}

#' @describeIn ssd_hc Hazard Percent list of distributions
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
    percent <- hc
  }

  if (!length(x)) {
    return(no_ssd_hc())
  }
  hc <- mapply(.ssd_hc_dist, x, names(x),
    MoreArgs = list(percent = percent),
    SIMPLIFY = FALSE
  )
  hc <- do.call("rbind", hc)
  as_tibble(hc)
}

#' @describeIn ssd_hc Hazard Percent fitdists
#' @export
#' @examples
#' ssd_hc(boron_dists, c(0, 1, 30, Inf))
ssd_hc.fitdists <- function(x, percent = 5, hc = 5, ci = FALSE, level = 0.95, nboot = 1000, parallel = NULL, ncpus = 1, average = TRUE, ic = "aicc", ...) {
  chk_string(ic)
  chk_subset(ic, c("aic", "aicc", "bic"))
  chk_unused(...)

  if (!missing(hc)) {
    deprecate_stop("0.1.0", "ssd_hc(hc = )", "ssd_hc(percent = )")
    percent <- hc
  }

  .ssd_hc_fitdists(x, percent,
    ci = ci, level = level, nboot = nboot,
    parallel = parallel, ncpus = ncpus,
    average = average, ic = ic
  )
}
