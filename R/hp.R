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

#' @describeIn ssd_hp Hazard Percents for fitdists Object
#' @export
ssd_hp.fitdists <- function(
    x, conc = 1, ci = FALSE, level = 0.95, nboot = 1000,
    average = TRUE,  delta = 7, min_pboot = 0.99,
    parametric = TRUE, multi = FALSE, control = NULL, ...
) {
  
  chk_vector(conc)
  chk_numeric(conc)
  chk_unused(...)
  
  hcp <- ssd_hcp_fitdists(
    x = x, value = conc, ci = ci, level = level, nboot = nboot,
    average = average, delta = delta, min_pboot = min_pboot,
    parametric = parametric, multi = multi, control = control, hc = FALSE
  )
  hcp <- dplyr::rename(hcp, conc = "value")
  hcp
}


#' @describeIn ssd_hp Hazard Percents for fitburrlioz Object
#' @export
#' @examples
#' 
#' fit <- ssd_fit_burrlioz(ssddata::ccme_boron)
#' ssd_hp(fit)
ssd_hp.fitburrlioz <- function(x, conc = 1, ci = FALSE, level = 0.95, nboot = 1000,
                               min_pboot = 0.99, parametric = FALSE, ...) {
  chk_length(x, upper = 1L)
  chk_named(x)
  chk_subset(names(x), c("burrIII3", "invpareto", "llogis", "lgumbel"))
  chk_vector(conc)
  chk_numeric(conc)
  chk_flag(ci)
  chk_unused(...)
  
  if (names(x) != "burrIII3" || !ci || !length(conc)) {
    class(x) <- class(x)[-1]
    return(ssd_hp(x,
                  conc = conc, ci = ci, level = level,
                  nboot = nboot, min_pboot = min_pboot,
                  average = FALSE, parametric = parametric
    ))
  }
  
  hcp <-   ssd_hcp_fitdists (
    x = x,
    value = conc, 
    ci = TRUE,
    level = level,
    nboot = nboot,
    average = FALSE,
    delta = Inf,
    min_pboot = min_pboot,
    parametric = parametric,
    multi = TRUE,
    control = NULL,
    hc = FALSE,
    fun = fit_burrlioz)

  hcp <- dplyr::rename(hcp, conc = "value")
  hcp
}
