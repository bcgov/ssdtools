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

#' Hazard Concentrations for Species Sensitivity Distributions
#'
#' Gets concentration(s) that protect specified percentage(s) of species.
#'
#' If `ci = TRUE` uses parameteric bootstrapping to get confidence intervals on the
#' hazard concentrations(s).
#'
#' @inheritParams params
#' @return A tibble of corresponding hazard concentrations.
#' @seealso [`predict.fitdists()`] and [`ssd_hp()`].
#' @export
ssd_hc <- function(x, ...) {
  UseMethod("ssd_hc")
}

.ssd_hc_dist <- function(x, dist, proportion) {
  fun <- paste0("ssd_q", dist)
  args <- list(p = proportion)
  args <- c(as.list(x), args)
  est <- do.call(fun, args)
  tibble(
    dist = dist,
    percent = proportion * 100, est = est,
    se = NA_real_, lcl = NA_real_, ucl = NA_real_,
    wt = 1,
    nboot = 0L, pboot = NA_real_
  )
}

#' @describeIn ssd_hc Hazard Concentrations for Distributional Estimates
#' @export
#' @examples
#' 
#' ssd_hc(ssd_match_moments())
ssd_hc.list <- function(x, percent = 5, ...) {
  chk_list(x)
  chk_named(x)
  chk_unique(names(x))
  chk_unused(...)
  
  if (!length(x)) {
    hc <- no_hcp()
    hc <- dplyr::rename(hc, percent = "value")
    return(hc)
  }
  hc <- mapply(.ssd_hc_dist, x, names(x),
               MoreArgs = list(proportion = percent / 100),
               SIMPLIFY = FALSE
  )
  bind_rows(hc)
}

#' @describeIn ssd_hc Hazard Concentrations for fitdists Object
#' @export
#' @examples
#' 
#' fits <- ssd_fit_dists(ssddata::ccme_boron)
#' ssd_hc(fits)
ssd_hc.fitdists <- function(
    x, 
    percent = 5, 
    ci = FALSE, 
    level = 0.95, 
    nboot = 1000,
    average = TRUE, 
    delta = 7, 
    min_pboot = 0.99,
    parametric = TRUE, 
    multi = TRUE,
    fix_weights = TRUE,
    control = NULL,
    samples = FALSE,
    save_to = NULL,
    ...) {
  
  chk_vector(percent)
  chk_numeric(percent)
  chk_range(percent, c(0, 100))
  chk_unused(...)
  
  proportion <- percent / 100
  
  hcp <- ssd_hcp_fitdists(
    x = x, 
    value = proportion,
    ci = ci,
    level = level,
    nboot = nboot,
    average = average,
    delta = delta,
    min_pboot = min_pboot,
    parametric = parametric,
    multi = multi,
    fix_weights = fix_weights,
    control = control,
    samples = samples,
    save_to = save_to,
    hc = TRUE)
  
  hcp <- dplyr::rename(hcp, percent = "value")
  hcp <- dplyr::mutate(hcp, percent = .data$percent * 100)
  hcp
}

#' @describeIn ssd_hc Hazard Concentrations for fitburrlioz Object
#' @export
#' @examples
#' 
#' fit <- ssd_fit_burrlioz(ssddata::ccme_boron)
#' ssd_hc(fit)
ssd_hc.fitburrlioz <- function(x, percent = 5, ci = FALSE, level = 0.95, nboot = 1000,
                               min_pboot = 0.99, parametric = FALSE, 
                               save_to = NULL, samples = FALSE, ...) {
  chk_length(x, upper = 1L)
  chk_named(x)
  chk_subset(names(x), c("burrIII3", "invpareto", "llogis", "lgumbel"))
  chk_vector(percent)
  chk_numeric(percent)
  chk_range(percent, c(0, 100))
  chk_unused(...)

  fun <- if(names(x) == "burrIII3") fit_burrlioz else fit_tmb

  proportion <- percent / 100
  
  hcp <-   ssd_hcp_fitdists (
    x = x,
    value = proportion, 
    ci = ci,
    level = level,
    nboot = nboot,
    average = FALSE,
    delta = Inf,
    min_pboot = min_pboot,
    parametric = parametric,
    multi = TRUE,
    save_to = save_to,
    samples = samples,
    control = NULL,
    hc = TRUE,
    fix_weights = FALSE,
    fun = fun)
  
  hcp <- dplyr::rename(hcp, percent = "value")
  hcp <- dplyr::mutate(hcp, percent = .data$percent * 100)
  hcp
}
