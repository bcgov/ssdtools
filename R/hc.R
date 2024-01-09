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
#' Calculates concentration(s) with quantile based bootstrap confidence intervals 
#' that protect specified percentage(s) of species for 
#' individual or model-averaged distributions
#' using parametric or non-parametric bootstrapping.
#' 
#' Model-averaged estimates and/or confidence intervals (including standard error) 
#' can be calculated  by treating the distributions as constituting a single mixture distribution
#' versus 'taking the mean'.
#' 
#' If treating the distributions as constituting a single mixture distribution
#' when calculating model average confidence intervals then
#' `weighted` specifies whether to use the original model weights versus
#' re-estimating for each bootstrap sample.
#' Conversely when 'taking the mean' then `weighted` specifies
#' whether to take bootstrap samples from each distribution proportional to 
#' its weight versus calculating the weighted arithmetic means of the lower 
#' and upper confidence limits.
#' 
#' Based on Burnham and Anderson (2002),
#' distributions with an absolute AIC difference greater 
#' than a delta of by default 7 are excluded
#' prior to calculation of the hazard concentrations.
#' 
#' @references
#' 
#' Burnham, K.P., and Anderson, D.R. 2002. Model Selection and Multimodel Inference. Springer New York, New York, NY. doi:10.1007/b97636.
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
    multi_est = TRUE,
    delta = 7, 
    min_pboot = 0.99,
    parametric = TRUE, 
    multi_ci = TRUE,
    weighted = TRUE,
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
    multi_est = multi_est,
    delta = delta,
    min_pboot = min_pboot,
    parametric = parametric,
    multi_ci = multi_ci,
    fix_weights = weighted,
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
    multi_est = TRUE,
    delta = Inf,
    min_pboot = min_pboot,
    parametric = parametric,
    multi_ci = TRUE,
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
