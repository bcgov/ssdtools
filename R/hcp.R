#    Copyright 2023 Australian Government Department of 
#    Climate Change, Energy, the Environment and Water
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

no_ssd_hcp <- function(hc) {
  x <- tibble(
    dist = character(0),
    percent = numeric(0),
    est = numeric(0),
    se = numeric(0),
    lcl = numeric(0),
    ucl = numeric(0),
    wt = numeric(0),
    nboot = integer(0),
    pboot = numeric(0)
  )
  if(!hc) {
    x <- dplyr::rename(x, conc = percent)
  }
  x
}

no_ci_hcp <- function(value, dist, est, rescale, hc) {
  na <- rep(NA_real_, length(value))
  x <- tibble(
    dist = rep(dist, length(value)),
    percent = value * 100,
    est = est * rescale,
    se = na,
    lcl = na,
    ucl = na,
    wt = rep(1, length(value)),
    nboot = rep(0L, length(value)),
    pboot = na
  )
  if(!hc) {
      x <- dplyr::rename(x, conc = .data$percent)
      x <- dplyr::mutate(x, conc = .data$conc / 100, 
                         est = .data$est / rescale * 100)
  }
  x
}
