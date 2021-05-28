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

xcis <- function(x, samples, p, level, fun, args) {
  if (p) {
    args$q <- x
  } else {
    args$p <- x
  }
  samples <- do.call(fun, args)
  if (any(is.na(samples))) {
    err(
      "Distribution '", substr(fun, 2, nchar(fun)),
      "' bootstraps include missing values."
    )
  }
  quantile <- quantile(samples, probs = probs(level))
  data.frame(
    se = sd(samples), lcl = quantile[1], ucl = quantile[2],
    row.names = NULL
  )
}

xcis_tmb <- function(x, args, what, level) {
  if(grepl("^p", what, "^p")) {
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

cis_tmb <- function(estimates, what, level, x) {
  args <- purrr::transpose(estimates)
  args <- purrr::map(args, as.double)
  purrr::map_dfr(x, xcis_tmb, args, what, level)
}

cis <- function(samples, p, level, x) {
  fun <- if (p) "p" else "q"
  fun <- paste0(fun, samples$fitpart$distname)
  args <- as.list(samples$estim)
  samples <- lapply(x, xcis,
    samples = samples, p = p, level = level,
    fun = fun, args = args
  )
  do.call("rbind", samples)
}
