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

.ssd_hp_fitdist <- function(x, conc, ci) {
  chk_vector(conc)
  chk_numeric(conc)
  na <- rep(NA_real_, length(conc))

  args <- as.list(x$estimate)
  args$q <- conc

  what <- paste0("p", x$distname)

  p <- do.call(what, args)
  p <- p * 100
  if (!ci) {
    return(as_tibble(data.frame(
      conc = conc, est = p,
      se = na, lcl = na, ucl = na
    )))
  }
  .NotYetImplemented()
  samples <- boot(x, nboot = 1000, parallel = FALSE, ncpus = 1)
  samples
}

.ssd_hp_fitdists <- function(x, conc, ic, ci) {
  na <- rep(NA_real_, length(conc))
  hp <- data.frame(conc = conc, est = na, se = na, lcl = na, ucl = na)

  if (!length(x) || !length(conc)) {
    return(as_tibble(hp))
  }

  weight <- .ssd_gof_fitdists(x)$weight

  mat <- lapply(x, ssd_hp, conc = conc)
  mat <- lapply(mat, function(x) x$est)
  mat <- as.matrix(as.data.frame(mat))

  hp$est <- apply(mat, 1, weighted.mean, w = weight)
  if (!ci) {
    return(as_tibble(hp))
  }
  .NotYetImplemented()
  hp
}

#' @describeIn ssd_hp Hazard Percent fitdist
#' @export
#' @examples
#' ssd_hp(boron_lnorm, c(0, 1, 30, Inf))
ssd_hp.fitdist <- function(x, conc, ci = FALSE, ...) {
  chk_unused(...)

  .ssd_hp_fitdist(x, conc, ci = ci)
}

#' @describeIn ssd_hp Hazard Percent fitdists
#' @export
#' @examples
#' ssd_hp(boron_dists, c(0, 1, 30, Inf))
ssd_hp.fitdists <- function(x, conc, ic = "aicc", ci = FALSE, ...) {
  chk_string(ic)
  chk_subset(ic, c("aic", "aicc", "bic"))
  chk_unused(...)

  .ssd_hp_fitdists(x, conc, ic = ic, ci = ci)
}

#' @describeIn ssd_hp Hazard Percent fitdistcens
#' @export
#' @examples
#' ssd_hp(fluazinam_lnorm, c(0, 1, 30, Inf))
ssd_hp.fitdistcens <- function(x, conc, ci = FALSE, ...) {
  chk_unused(...)

  .ssd_hp_fitdist(x, conc, ci = ci)
}

#' @describeIn ssd_hp Hazard Percent fitdistcens
#' @export
#' @examples
#' ssd_hp(fluazinam_dists, c(0, 1, 30, Inf))
ssd_hp.fitdistscens <- function(x, conc, ic = "aic", ci = FALSE, ...) {
  chk_string(ic)
  chk_subset(ic, c("aic", "bic"))
  chk_unused(...)

  .ssd_hp_fitdists(x, conc, ic = ic, ci = ci)
}
