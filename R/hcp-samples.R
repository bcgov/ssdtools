# Copyright 2025 Australian Government Department of Climate Change,
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

## TODO: ensure all dists being caried through to list of dists? - are they lost if not converged??

samples_to_vectors <- function(x, nboot) {
  vec <- rep(NA_real_, times = nboot)
  
  numbers <- names(x) |>
    stringr::str_extract("^\\d+") |>
    as.integer()
  
  vec[numbers] <- x
  vec
}

combine_samples <- function(samples, weight, nboot, geometric) {
  colnames <- purrr::map_chr(samples, \(.x) names(.x[1])) |>
    stringr::str_replace("\\d+_", "")

  samples <- purrr::map(samples, \(.x) samples_to_vectors(.x, nboot = nboot)) |>
    purrr::set_names(colnames) |>
    dplyr::as_tibble() |>
    dplyr::rowwise() |>
    dplyr::mutate(.samples = weighted_mean(dplyr::c_across(dplyr::all_of(colnames)), wt = weight, geometric = geometric)) |>
    dplyr::pull(.data$.samples)

  names(samples) <- boot_filename(seq_along(samples),
                                  prefix = "", sep = "",
                                  dist = "_average")
  samples[!is.na(samples)]
}

hcp_combine_samples <- function(hcp, weight, ci_method, level, nboot) {
  geometric <- ci_method == "geometric_samples"

  nboot1 <- nboot
  hcp <- hcp |>
    dplyr::bind_rows() |>
    dplyr::group_by(.data$value) |>
    dplyr::summarise(
      samples = list(combine_samples(.data$samples, weight, nboot = nboot1, geometric = geometric))) |>
    dplyr::ungroup()
  
  quantiles <- purrr::map(hcp$samples, stats::quantile, probs = probs(level))
  quantiles <- purrr::transpose(quantiles)
  
  hcp |> 
    dplyr::mutate(
      lcl = unlist(quantiles[[1]]),
      ucl = unlist(quantiles[[2]]),
      se = purrr::map_dbl(.data$samples, sd),
      pboot = pmin(purrr::map_dbl(.data$samples, length) / nboot, 1))
}

hcp_samples <- function(x, value, level, nboot, est_method, min_pboot,
                         data, rescale, weighted, censoring, min_pmix,
                         range_shape1, range_shape2, parametric, control,
                         save_to, ci_method, hc, fun, ...) {

  hcp <- purrr::map(
    x, hcp_tmbfit, value = value, ci = TRUE, level = level, nboot = nboot,
    min_pboot = min_pboot, data = data, rescale = rescale, weighted = weighted, censoring = censoring,
    min_pmix = min_pmix, range_shape1 = range_shape1, range_shape2 = range_shape2,
    parametric = parametric, est_method = est_method, ci_method = ci_method, average = TRUE, control = control,
    hc = hc, save_to = save_to, samples = TRUE, fun = fun
  )
  weight <- glance(x, wt = TRUE)$wt
  
  hcp_combine_samples(hcp, weight, ci_method = ci_method, level = level, nboot = nboot)
}
