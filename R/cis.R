# Copyright 2015-2023 Province of British Columbia
# Copyright 2021 Environment and Climate Change Canada
# Copyright 2023-2024 Australian Government Department of Climate Change,
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

xcis_estimates <- function(x, args, n, what, level, samples) {
  if (grepl("^ssd_p", what)) {
    args$q <- x
  } else {
    args$p <- x
  }
  ests <- do.call(what, args)
  names(ests) <- n
  quantile <- unname(quantile(ests, probs = probs(level)))
  samples <- if (samples) ests else numeric(0)
  tibble(
    se = sd(ests), log_se = sd(log(ests)), lcl = quantile[1], ucl = quantile[2],
    samples = list(samples),
    row.names = NULL
  )
}

cis_estimates <- function(estimates, what, level, x, samples, .names = NULL) {
  n <- names(estimates)
  args <- transpose(estimates, .names = .names)
  args <- purrr::map_depth(args, 2, function(x) {
    if (is.null(x)) NA_real_ else x
  })
  args <- lapply(args, as.double)
  x <- lapply(x, xcis_estimates, args, n, what, level, samples = samples)
  dplyr::bind_rows(x)
}
