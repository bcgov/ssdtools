any_missing <- function(...) {
  x <- unlist(list(...))
  any(is.na(x) & !is.nan(x))
}

ddist <- function(dist, x, ..., log = FALSE) {
  if(!length(x)) return(numeric(0))

  fun <- paste0("d", dist, "_ssd")
  d <- mapply(fun, x, ..., MoreArgs = list(log_ssd = log))
  d[mapply(any_missing, x, ...)] <- NA_real_
  d
}

pdist <- function(dist, q, ..., lower.tail = TRUE, log.p = FALSE) {
  if(!length(q)) return(numeric(0))

  fun <- paste0("p", dist, "_ssd")
  p <- mapply(fun, q, ...)
  p[mapply(any_missing, q, ...)] <- NA_real_
  
  if(!lower.tail) p <- 1 - p
  if(log.p) p <- log(p)
  p
}

qdist <- function(dist, p, ..., lower.tail = TRUE, log.p = FALSE) {
  if(!length(p)) return(numeric(0))
  
  if (log.p) p <- exp(p)
  if (!lower.tail) p <- 1 - p
  
  fun <- paste0("q", dist, "_ssd")
  q <- mapply(fun, p, ...)
  q[mapply(any_missing, p, ...)] <- NA_real_
  q
}

rdist <- function(dist, n, ...) {
  if(n == 0L) return(numeric(0))
  
  fun <- paste0("r", dist, "_ssd")
  list <- list(...)
  list$n <- n
  do.call(fun, list)
}
