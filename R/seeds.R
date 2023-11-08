# Copyright 2023 Environment and Climate Change Canada
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

rinteger <- function(n = 1L) {
  chk_whole_number(n)
  chk_gte(n, 0L)
  if (n == 0) integer(0)
  mx <- 2147483647L
  as.integer(runif(n, -mx, mx))
}

get_random_seed <- function() {
  globalenv()$.Random.seed
}

set_random_seed <- function(seed, advance = FALSE) {
  env <- globalenv()
  env$.Random.seed <- seed
  if (advance) {
    fun <- if (is.null(seed)) suppressWarnings else identity
    fun(runif(1))
  }
  invisible(env$.Random.seed)
}

get_lecyer_cmrg_seed <- function() {
  seed <- get_random_seed()
  on.exit(set_random_seed(seed))
  RNGkind("L'Ecuyer-CMRG")
  set.seed(rinteger(1))
  get_random_seed()
}

# inspired by furrr:::generate_seed_streams
seed_streams <- function(nseeds) {
  oseed <- get_random_seed()
  on.exit(set_random_seed(oseed, advance = TRUE))

  seed <- get_lecyer_cmrg_seed()
  seeds <- vector("list", length = nseeds)
  for (i in seq_len(nseeds)) {
    seeds[[i]] <- nextRNGSubStream(seed)
    seed <- nextRNGStream(seed)
  }
  seeds
}
