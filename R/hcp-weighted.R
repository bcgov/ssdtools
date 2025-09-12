# Copyright 2015-2023 Province of British Columbia
# Copyright 2021 Environment and Climate Change Canada
# Copyright 2023-2025 Australian Government Department of Climate Change,
# Energy, the Environment and Water
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

hcp_wb <- function(hcp, level, nboot) {
  hcp <- hcp |>
    dplyr::bind_rows() |>
    dplyr::group_by(.data$value) |>
    dplyr::summarise(
      samples = list(unlist(.data$samples))
    ) |>
    dplyr::ungroup()

  ## uses weighted bootstrap to get se, lcl and ucl
  quantiles <- purrr::map(hcp$samples, stats::quantile, probs = probs(level))
  quantiles <- purrr::transpose(quantiles)

  hcp |>
    dplyr::mutate(
      lcl = unlist(quantiles[[1]]),
      ucl = unlist(quantiles[[2]]),
      se = purrr::map_dbl(.data$samples, sd),
      pboot = pmin(purrr::map_dbl(.data$samples, length) / nboot, 1)
    )
}

get_nboots <- function(weight, nboot) {
  nboots <- as.integer(round(weight * nboot))

  while (sum(nboots) != nboot) {
    diff <- nboots / nboot - weight
    if (sum(nboots) < nboot) {
      wch <- which.min(diff)
      nboots[wch] <- nboots[wch] + 1L
    } else {
      wch <- which.max(diff)
      nboots[wch] <- nboots[wch] - 1L
    }
  }
  nboots
}

hcp_weighted <- function(x, value, level, nboot, est_method, min_pboot,
                         data, rescale, weighted, censoring, min_pmix,
                         range_shape1, range_shape2, parametric, control,
                         save_to, ci_method, hc, fun, ...) {
  weight <- glance(x, wt = TRUE)$wt
  nboots <- get_nboots(weight, nboot)

  x <- subset(x, names(x)[nboots > 0])
  nboots <- nboots[nboots > 0]

  hcp <- purrr::map2(
    x, nboots, hcp_tmbfit,
    value = value, ci = TRUE, level = level,
    min_pboot = min_pboot, data = data, rescale = rescale, weighted = weighted, censoring = censoring,
    min_pmix = min_pmix, range_shape1 = range_shape1, range_shape2 = range_shape2,
    parametric = parametric, est_method = est_method, ci_method = ci_method, average = TRUE, control = control,
    hc = hc, save_to = save_to, samples = TRUE, fun = fun
  )

  hcp_wb(hcp, level = level, nboot = nboot)
}
