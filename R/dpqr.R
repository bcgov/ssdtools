vectorise_vectors <- function(...) {
  data <- try(data.frame(..., stringsAsFactors = FALSE), silent = TRUE)
  if(!inherits(data, "try-error")) return(as.list(data))
  abort_chk("arguments imply differing number of values")
}

d_apply <- function(dist, x, ..., log = FALSE) {
  if(!length(x)) return(numeric(0))
  
  list <- vectorise_vectors(x = x, ...)
  list$log_cpp <- log
  fun <- paste0("d", dist, "_cpp")
  do.call(fun, list)
}

p_apply <- function(dist, q, ..., lower.tail = TRUE, log.p = FALSE) {
  if(!length(q)) return(numeric(0))
  
  list <- vectorise_vectors(q = q, ...)
  fun <- paste0("p", dist, "_cpp")
  p <- do.call(fun, list)
  
  if(!lower.tail) p <- 1 - p
  if(log.p) p <- log(p)
  p
}

q_apply <- function(dist, p, ..., lower.tail = TRUE, log.p = FALSE) {
  if(!length(p)) return(numeric(0))
  
  if (log.p) p <- exp(p)
  if (!lower.tail) p <- 1 - p
  
  list <- vectorise_vectors(p = p, ...)
  fun <- paste0("q", dist, "_cpp")
  do.call(fun, list)
}

r_apply <- function(dist, n, ...) {
  if(n == 0L) return(numeric(0))
  
  list <- vectorise_vectors(n = rep(1, n), ...)
  list$n <- n
  fun <- paste0("r", dist, "_cpp")
  do.call(fun, list)
}