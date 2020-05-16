vectorise_vectors <- function(...) {
  data <- try(data.frame(..., stringsAsFactors = FALSE), silent = TRUE)
  if(!inherits(data, "try-error")) return(as.list(data))
  abort_chk("arguments imply differing number of values")
}

d_apply <- function(dist, x, ..., log = FALSE) {
  chk_flag(log)
  
  if(!length(x)) return(numeric(0))
  list <- vectorise_vectors(x = x, ...)
  list$log_cpp <- log
  fun <- paste0("d", dist, "_cpp")
  do.call(fun, list)
}

p_apply <- function(dist, q, ..., lower.tail = TRUE, log.p = FALSE) {
  chk_flag(lower.tail)
  chk_flag(log.p)
  
  if(!length(q)) return(numeric(0))
  list <- vectorise_vectors(q = q, ...)
  list$lower_tail <- lower.tail
  list$log_p <- log.p
  fun <- paste0("p", dist, "_cpp")
  do.call(fun, list)
}

q_apply <- function(dist, p, ..., lower.tail = TRUE, log.p = FALSE) {
  chk_flag(lower.tail)
  chk_flag(log.p)
  
  if(!length(p)) return(numeric(0))
  list <- vectorise_vectors(p = p, ...)
  list$lower_tail <- lower.tail
  list$log_p <- log.p
  fun <- paste0("q", dist, "_cpp")
  do.call(fun, list)
}

r_apply <- function(dist, n, ...) {
  chk_whole_number(n)
  chk_gte(n)
  if(n == 0L) return(numeric(0))
  n <- rep(1, n)
  list <- vectorise_vectors(n = n, ...)
  list$n <- NULL
  fun <- paste0("r", dist, "_cpp")
  do.call(fun, list)
}