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
  as_tibble(data.frame(
    percent = numeric(0),
    est = numeric(0),
    se = numeric(0),
    lcl = numeric(0),
    ucl = numeric(0),
    dist = character(0),
    wt = numeric(0),
    stringsAsFactors = FALSE
  ))
}

.ssd_hc_dist <- function(x, dist, percent) {
  chk_vector(percent)
  chk_numeric(percent)

  percent <- percent / 100
  fun <- paste0("q", dist)
  args <- list(p = percent)
  args <- c(as.list(x), args)
  est <- do.call(fun, args)
  data.frame(
    percent = percent * 100, est = est,
    se = NA_real_, lcl = NA_real_, ucl = NA_real_, dist = dist,
    stringsAsFactors = FALSE
  )
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
      wt =  rep(1, length(percent)), stringsAsFactors = FALSE
    )))
  }
  samples <- boot(x, nboot = nboot, parallel = parallel, ncpus = ncpus)
  cis <- cis(samples, p = FALSE, level = level, x = percent)
  as_tibble(data.frame(
    percent = percent * 100, est = est,
    se = cis$se, lcl = cis$lcl, ucl = cis$ucl, dist = dist,
    wt = 1, stringsAsFactors = FALSE
  ))
}

.ssd_hc_fitdists <- function(x, percent, ci, level, nboot, parallel, ncpus,
                             average) {
  if (!length(x) || !length(percent)) {
    return(no_ssd_hc())
  }

  hc <- lapply(x, ssd_hc,
    percent = percent, ci = ci, level = level, nboot = nboot,
    parallel = parallel, ncpus = ncpus
  )
  weight <- .ssd_gof_fitdists(x)$weight
  if (!average) {
    hc <- mapply(function(x, y) {x$wt <- y; x}, hc, weight, USE.NAMES = FALSE,
                 SIMPLIFY = FALSE)
    hc <- do.call("rbind", hc)
    row.names(hc) <- NULL
    return(as_tibble(hc))
  }
  hc <- lapply(hc, function(x) x[1:5])
  hc <- lapply(hc, as.matrix)
  hc <- Reduce(function(x, y) {
    abind(x, y, along = 3)
  }, hc)
  suppressMessages(hc <- apply(hc, c(1, 2), weighted.mean, w = weight))
  hc <- as.data.frame(hc)
  hc$percent <- percent
  hc$dist <- "average"
  hc$wt <- 1
  as_tibble(hc)
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
    deprecate_soft("0.1.0", "ssd_hc(hc = )", "ssd_hc(percent = )")
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
  hc$wt <- rep(NA_real_, nrow(hc))
  as_tibble(hc)
}

#' @describeIn ssd_hc Hazard Percent fitdist
#' @export
#' @examples
#' ssd_hc(boron_lnorm, c(0, 1, 30, Inf))
ssd_hc.fitdist <- function(x, percent = 5, hc = 5, ci = FALSE, level = 0.95, nboot = 1000, parallel = NULL, ncpus = 1, ...) {
  chk_unused(...)

  if (!missing(hc)) {
    deprecate_soft("0.1.0", "ssd_hc(hc = )", "ssd_hc(percent = )")
    percent <- hc
  }

  .ssd_hc_fitdist(x, percent,
    ci = ci, level = level, nboot = nboot,
    parallel = parallel, ncpus = ncpus
  )
}

#' @describeIn ssd_hc Hazard Percent fitdistcens
#' @export
#' @examples
#' ssd_hc(fluazinam_lnorm, c(0, 1, 30, Inf))
ssd_hc.fitdistcens <- function(x, percent = 5, hc = 5, ci = FALSE, level = 0.95, nboot = 1000, parallel = NULL, ncpus = 1, ...) {
  chk_unused(...)

  if (!missing(hc)) {
    deprecate_soft("0.1.0", "ssd_hc(hc = )", "ssd_hc(percent = )")
    percent <- hc
  }

  .ssd_hc_fitdist(x, percent,
    ci = ci, level = level, nboot = nboot,
    parallel = parallel, ncpus = ncpus
  )
}

#' @describeIn ssd_hc Hazard Percent fitdists
#' @export
#' @examples
#' ssd_hc(boron_dists, c(0, 1, 30, Inf))
ssd_hc.fitdists <- function(x, percent = 5, hc = 5, ci = FALSE, level = 0.95, nboot = 1000, parallel = NULL, ncpus = 1, average = TRUE, ic = "aicc", ...) {
  chk_unused(...)

  if (!missing(hc)) {
    deprecate_soft("0.1.0", "ssd_hc(hc = )", "ssd_hc(percent = )")
    percent <- hc
  }
  if(!missing(ic)) {
    deprecate_warn("0.3.6", "ssdtools::ssd_hc(ic = )",
                   details = "AICc is used for model averaging unless the data are censored in which case AIC is used.")
  }

  .ssd_hc_fitdists(x, percent,
    ci = ci, level = level, nboot = nboot,
    parallel = parallel, ncpus = ncpus,
    average = average
  )
}

#' @describeIn ssd_hc Hazard Percent fitdistcens
#' @export
#' @examples
#' ssd_hc(fluazinam_dists, c(0, 1, 30, Inf))
ssd_hc.fitdistscens <- function(x, percent = 5, hc = 5, ci = FALSE, level = 0.95, nboot = 1000, parallel = NULL, ncpus = 1, average = TRUE, ic = "aic", ...) {
  chk_unused(...)

  if (!missing(hc)) {
    deprecate_soft("0.1.0", "ssd_hc(hc = )", "ssd_hc(percent = )")
    percent <- hc
  }
  if(!missing(ic)) {
    deprecate_warn("0.3.6", "ssdtools::ssd_hc(ic = )",
                   details = "AICc is used for model averaging unless the data are censored in which case AIC is used.")
  }

  .ssd_hc_fitdists(x, percent,
    ci = ci, level = level, nboot = nboot,
    parallel = parallel, ncpus = ncpus,
    average = average
  )
}
