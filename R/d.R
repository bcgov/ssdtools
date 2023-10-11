#    Copyright 2015 Province of British Columbia
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

any_missing <- function(...) {
  x <- unlist(list(...))
  any(is.na(x) & !is.nan(x))
}

.ddist <- function(dist, x, ..., log) {
  inf <- !is.na(x) & is.infinite(x)
  x[inf] <- NA_real_
  fun <- paste0("d", dist, "_ssd")
  d <- mapply(fun, x, ...)
  d[mapply(any_missing, x, ...)] <- NA_real_
  d[inf] <- -Inf
  if (!log) d <- exp(d)
  d
}

ddist <- function(dist, x, ..., log = FALSE, .lgt = FALSE) {
  if (!length(x)) {
    return(numeric(0))
  }

  if (!.lgt) {
    return(.ddist(dist, x = x, ..., log = log))
  }

  lte <- !is.na(x) & x <= 0
  x[lte] <- NA_real_
  d <- .ddist(dist, x = log(x), ..., log = FALSE) / x
  d[lte] <- 0
  if (log) {
    return(log(d))
  }
  d
}
