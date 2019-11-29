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

#' Percent Protected
#'
#' Gets percent species protected at specified concentrations.
#'
#' @param x The object.
#' @param conc A numeric vector of the concentrations.
#' @inheritParams predict.fitdists
#' @param ... Unused.
#' @return A data frame of the conc and percent.
#' @export
ssd_pp <- function(x, ...) {
  UseMethod("ssd_pp")
}

.ssd_pp_fitdist <- function(x, conc) {
  args <- as.list(x$estimate)
  args$q <- conc
  
  what <- paste0("p", x$distname)
  
  p <- do.call(what, args)
  p <- p * 100
  as_tibble(data.frame(conc = conc, percent = p))
}

#' @describeIn ssd_pp Percent Protected fitdist
#' @export
#' @examples
#' ssd_pp(boron_lnorm, c(0, 1, 30, Inf))
ssd_pp.fitdist <- function(x, conc, ...) {
  chk_unused(...)
  .ssd_pp_fitdist(x, conc)
}

#' @describeIn ssd_pp Percent Protected fitdists
#' @export
#' @examples
#' ssd_pp(boron_dists, c(0, 1, 30, Inf))
ssd_pp.fitdists <- function(x, conc, ic = "aicc", ...) {
  chk_vector(conc)
  chk_numeric(conc)
  chk_unused(...)
  
  if(!length(x)) { 
    return(as_tibble(data.frame(conc = conc, 
                                percent = rep(NA_real_, length(conc)))))
  }
  
  ps <- lapply(x, ssd_pp, conc = conc)
  ps <- lapply(ps, function(x) x$percent)
  ps <- c(list(conc = conc, percent = NA_real_), ps)
  ps <- as.data.frame(ps)
  
  ic <- ssd_gof(x)[c("dist", ic)]
  ic$delta <- ic[[2]] - min(ic[[2]])
  ic$weight <- exp(-ic$delta / 2) / sum(exp(-ic$delta / 2))
  mat <- ps[,3:ncol(ps),drop = FALSE]
  ps$percent <- apply(mat, 1, weighted.mean, w = ic$weight)
  
  ps
}

#' @describeIn ssd_pp Percent Protected fitdistcens
#' @export
#' @examples
#' ssd_pp(fluazinam_lnorm, c(0, 1, 30, Inf))
ssd_pp.fitdistcens <- function(x, conc, ...) {
  chk_unused(...)
  .ssd_pp_fitdist(x, conc)
}
