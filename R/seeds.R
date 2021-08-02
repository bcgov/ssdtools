rinteger <- function(n = 1L) {
  chk_whole_number(n)
  chk_gte(n, 0L)
  if(n == 0) integer(0)
  mx <- 2147483647L
  as.integer(runif(n, -mx, mx))
}

get_random_seed <- function() {
  globalenv()$.Random.seed
}

set_random_seed <- function(seed, advance = FALSE) {
  env <- globalenv()
  env$.Random.seed <- seed
  if(advance) {
    fun <- if(is.null(seed)) suppressWarnings else identity
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
