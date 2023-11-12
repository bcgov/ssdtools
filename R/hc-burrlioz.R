# Copyright 2023 Environment and Climate Change Canada
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

.ssd_hc_burrlioz_tmbfit <- function(x, proportion, level, nboot, min_pboot,
                                    data, rescale, weighted, censoring, min_pmix,
                                    range_shape1, range_shape2, parametric, control) {
  args <- estimates(x)
  args$p <- proportion
  dist <- .dist_tmbfit(x)
  stopifnot(identical(dist, "burrIII3"))

  what <- paste0("ssd_q", dist)

  est <- do.call(what, args)
  censoring <- censoring / rescale

  fun <- safely(fit_burrlioz)

  estimates <- boot_estimates(x,
    fun = fun, nboot = nboot, data = data, weighted = weighted,
    censoring = censoring, min_pmix = min_pmix,
    range_shape1 = range_shape1,
    range_shape2 = range_shape2,
    parametric = parametric,
    control = control
  )

  cis <- cis_estimates(estimates,
    what = "ssd_qburrlioz", level = level, x = proportion,
    .names = c("scale", "shape", "shape1", "shape2", "locationlog", "scalelog")
  )

  method <- if (parametric) "parametric" else "non-parametric"

  hc <- tibble(
    dist = dist,
    percent = proportion * 100, est = est * rescale,
    se = cis$se * rescale, lcl = cis$lcl * rescale, ucl = cis$ucl * rescale,
    method = method,
    nboot = nboot, pboot = length(estimates) / nboot
  )
  replace_min_pboot_na(hc, min_pboot)
}

.ssd_hc_burrlioz_fitdists <- function(x, percent, level, nboot, min_pboot, parametric) {
  control <- .control_fitdists(x)
  data <- .data_fitdists(x)
  rescale <- .rescale_fitdists(x)
  censoring <- .censoring_fitdists(x)
  min_pmix <- .min_pmix_fitdists(x)
  range_shape1 <- .range_shape1_fitdists(x)
  range_shape2 <- .range_shape2_fitdists(x)
  weighted <- .weighted_fitdists(x)
  unequal <- .unequal_fitdists(x)

  if (parametric && identical(censoring, c(NA_real_, NA_real_))) {
    err("Parametric CIs cannot be calculated for inconsistently censored data.")
  }

  if (parametric && unequal) {
    err("Parametric CIs cannot be calculated for unequally weighted data.")
  }

  seeds <- seed_streams(length(x))
  hc <- future_map(x, .ssd_hc_burrlioz_tmbfit,
    proportion = percent / 100,
    level = level, nboot = nboot, min_pboot = min_pboot,
    data = data, rescale = rescale, weighted = weighted, censoring = censoring,
    min_pmix = min_pmix, range_shape1 = range_shape1, range_shape2 = range_shape2,
    parametric = parametric,
    control = control, .options = furrr::furrr_options(seed = seeds)
  )$burrIII3
  hc
}

#' Hazard Concentrations for Burrlioz Fit
#'
#' Deprecated for [`ssd_hc()`].
#'
#' @inheritParams params
#' @return A tibble of corresponding hazard concentrations.
#' @export
#' @examples
#' fit <- ssd_fit_burrlioz(ssddata::ccme_boron)
#' ssd_hc_burrlioz(fit)
#'
#' @export
ssd_hc_burrlioz <- function(x, percent = 5, ci = FALSE, level = 0.95, nboot = 1000,
                            min_pboot = 0.99, parametric = FALSE) {
  lifecycle::deprecate_warn("0.3.5", "ssd_hc_burrlioz()", "ssd_hc()")
  chk_s3_class(x, "fitburrlioz")

  ssd_hc(x,
    percent = percent, ci = ci, level = level,
    nboot = nboot, min_pboot = min_pboot, parametric = parametric
  )
}
