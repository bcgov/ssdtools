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

cis <- function(samples, p, level, x) {
  fun <- samples$fitpart$distname
  args <- list()
  if(p) {
    fun <- paste0("p", fun)
    args$q <- x
  } else {
    fun <- paste0("q", fun)
    args$p <- x
  }
  args <- c(args, as.list(samples$estim))
  samples <- do.call(fun, args)
  quantile <- quantile(samples, probs = c(0.025, 0.975))
  data.frame(se = sd(samples), lcl = quantile[1], ucl = quantile[2],
                   row.names = NULL)
}
