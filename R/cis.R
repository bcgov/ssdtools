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

xcis_estimates <- function(x, args, what, level) {
  if (grepl("^ssd_p", what)) {
    args$q <- x
  } else {
    args$p <- x
  }
  samples <- do.call(what, args)
  quantile <- quantile(samples, probs = probs(level))
  data.frame(
    se = sd(samples), lcl = quantile[1], ucl = quantile[2],
    row.names = NULL
  )
}

cis_estimates <- function(estimates, what, level, x, .names = NULL) {
  args <- transpose(estimates, .names = .names)
  args <- purrr::map_depth(args, 2, function(x) {
    if (is.null(x)) NA_real_ else x
  })
  args <- lapply(args, as.double)
  x <- lapply(x, xcis_estimates, args, what, level)
  bind_rows(x)
}
