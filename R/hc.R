#    Copyright 2015 Province of British Columbia
#
#    Licensed under the Apache License, Version 2.0 (the "License");
#    you may not use this file except in compliance with the License.
#    You may obtain a copy of the License at
#
#       http://www.apache.org/licenses/LICENSE-2.0
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
#' @return A data frame of the percent and concentrations.
#' @export
ssd_hc <- function(x, ...) {
  UseMethod("ssd_hc")
}

.ssd_hc_fitdist <- function(x, percent, ci, level, nboot, parallel, ncpus) {
  chk_vector(percent)
  chk_numeric(percent)
  chk_number(level)
  chk_range(level)
  
  percent <- percent / 100
  
  args <- as.list(x$estimate)
  args$p <- percent
  dist <- x$distname
  what <- paste0("q", dist)
  
  est <- do.call(what, args)
  if (!ci) {
    na <- rep(NA_real_, length(percent))
    return(as_tibble(data.frame(
      percent = percent * 100, est = est,
      se = na, lcl = na, ucl = na, dist = rep(dist, length(percent)),
     stringsAsFactors = FALSE
    )))
  }
  samples <- boot(x, nboot = nboot, parallel = parallel, ncpus = ncpus)
  cis <- cis(samples, p = FALSE, level = level, x = percent)
  as_tibble(data.frame(
    percent = percent * 100, est = est,
    se = cis$se, lcl = cis$lcl, ucl = cis$ucl, dist = dist,
    stringsAsFactors = FALSE))
}

.ssd_hc_fitdists <- function(x, percent, ci, level, nboot, parallel, ncpus, 
                             average, ic) {
  if (!length(x) || !length(percent)) {
    no <- numeric(0)
    return(as_tibble(data.frame(percent = no, est = no, se = no, 
                                lcl = no, ucl = no, dist = character(0),
                                stringsAsFactors = FALSE)))
  }
  
  hc <- lapply(x, ssd_hc, percent = percent, ci = ci, level = level, nboot = nboot, 
               parallel = parallel, ncpus = ncpus)
  if(!average) {
    hc <- do.call("rbind", hc)
    row.names(hc) <- NULL
    return(as_tibble(hc))
  }
  hc <- lapply(hc, function(x) x[1:5])
  hc <- lapply(hc, as.matrix)
  hc <- Reduce(function(x, y) { abind(x, y, along = 3) }, hc)
  weight <- .ssd_gof_fitdists(x)$weight
  suppressMessages(hc <- apply(hc, c(1, 2), weighted.mean, w = weight))
  hc <- as.data.frame(hc)
  hc$percent <- percent
  hc$dist <- "average"
  as_tibble(hc)
}

#' @describeIn ssd_hc Hazard Percent fitdist
#' @export
#' @examples
#' ssd_hc(boron_lnorm, c(0, 1, 30, Inf))
ssd_hc.fitdist <- function(x, percent = 5, ci = FALSE, level = 0.95, nboot = 1000, parallel = NULL, ncpus = 1,...) {
  chk_unused(...)
  
  .ssd_hc_fitdist(x, percent, ci = ci, level = level, nboot = nboot, 
                  parallel = parallel, ncpus = ncpus)
}

#' @describeIn ssd_hc Hazard Percent fitdistcens
#' @export
#' @examples
#' ssd_hc(fluazinam_lnorm, c(0, 1, 30, Inf))
ssd_hc.fitdistcens <- function(x, percent = 5, ci = FALSE, level = 0.95, nboot = 1000, parallel = NULL, ncpus = 1, ...) {
  chk_unused(...)
  
  .ssd_hc_fitdist(x, percent, ci = ci, level = level, nboot = nboot, 
                  parallel = parallel, ncpus = ncpus)
}

#' @describeIn ssd_hc Hazard Percent fitdists
#' @export
#' @examples
#' ssd_hc(boron_dists, c(0, 1, 30, Inf))
ssd_hc.fitdists <- function(x, percent = 5, ci = FALSE, level = 0.95, nboot = 1000, parallel = NULL, ncpus = 1, average = TRUE, ic = "aicc", ...) {
  chk_string(ic)
  chk_subset(ic, c("aic", "aicc", "bic"))
  chk_unused(...)
  
  .ssd_hc_fitdists(x, percent, ci = ci, level = level, nboot = nboot, 
                   parallel = parallel, ncpus = ncpus, average = average, ic = ic)
}

#' @describeIn ssd_hc Hazard Percent fitdistcens
#' @export
#' @examples
#' ssd_hc(fluazinam_dists, c(0, 1, 30, Inf))
ssd_hc.fitdistscens <- function(x, percent = 5, ci = FALSE, level = 0.95, nboot = 1000, parallel = NULL, ncpus = 1, average = TRUE, ic = "aic", ...) {
  chk_string(ic)
  chk_subset(ic, c("aic", "bic"))
  chk_unused(...)
  
  .ssd_hc_fitdists(x, percent, ci = ci, level = level, nboot = nboot, 
                   parallel = parallel, ncpus = ncpus, average = average, ic = ic)
}
