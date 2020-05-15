#    Copyright 2015 Province of British Columbia
#
#    Licensed under the Apache License, Version 2.0 (the "License");
#    you may not use this file except in compliance with the License.
#    You may obtain a copy of the License at
#
#       http://www.apache.org/licenses/LICENSE-2.0
#
#    Unless required by applicable law or agreed to in writing, software
#    distributed under the License is distributed on an "AS IS" BASIS,
#    WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
#    See the License for the specific language governing permissions and
#    limitations under the License.

xcis <- function(x, samples, p, level, fun, args) {
  # this is a hack to deal with the fact that currently the Rcpp 
  # distribution functions can only accept scalars for parameter values
  fun <- Vectorize(fun, vectorize.args = names(args), USE.NAMES = FALSE)
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
