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

identical_parameters <- function(x) {
  length(unique(npars(x))) < 2
}

probs <- function(level) {
  probs <- (1 - level) / 2
  c(probs, 1 - probs)
}

safely <- function(.f) {
  function(...) {
    x <- try(.f(...), silent = TRUE)
    if (inherits(x, "try-error")) {
      return(list(result = NULL, error = as.character(x)))
    }
    list(result = x, error = NULL)
  }
}

pow <- function(x, y) x^y

root <- function(p, f) {
  q <- rep(NA_real_, length(p))
  for (i in seq_along(p)) {
    q[i] <- stats::uniroot(f, p = p[i], lower = 0, upper = 1, extendInt = "upX", tol = .Machine$double.eps)$root
  }
  q
}

weighted_mean <- function(x, w, geometric) {
  if(!geometric) {
    return(weighted.mean(x, w = w))
  }
  exp(weighted.mean(log(x), w = w))
}
