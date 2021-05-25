any_missing <- function(...) {
  x <- unlist(list(...))
  any(is.na(x) & !is.nan(x))
}

.pdist <- function(dist, q, ..., lower.tail, log.p) {
  inf <- !is.na(q) & is.infinite(q)
  pos <- is.na(q) | q > 0
  q[inf] <- NA_real_
  fun <- paste0("p", dist, "_ssd")
  p <- mapply(fun, q, ...)
  p[mapply(any_missing, q, ...)] <- NA_real_
  p[inf & pos] <- 1
  p[inf & !pos] <- 0
  if(!lower.tail) p <- 1 - p
  if(log.p) p <- log(p)
  p
}

pdist <- function(dist, q, ..., lower.tail = TRUE, log.p = FALSE, .lgt = FALSE) {
  if(!length(q)) return(numeric(0))
  
  if(!.lgt)
    return(.pdist(dist, q = q, ..., lower.tail = lower.tail, log.p = log.p))

  lte <- !is.na(q) & q <= 0
  q[lte] <- NA_real_
  p <- .pdist(dist, q = log(q),  ..., lower.tail = TRUE, log.p = FALSE)
  p[lte] <- 0
  if(!lower.tail) p <- 1 - p
  if(log.p) p <- log(p)
  p
}

.qdist <- function(dist, p, ...) {
  fun <- paste0("q", dist, "_ssd")
  q <- mapply(fun, p, ...)
  q[mapply(any_missing, p, ...)] <- NA_real_
  q
}

qdist <- function(dist, p, ..., lower.tail = TRUE, log.p = FALSE, .lgt = FALSE) {
  if(!length(p)) return(numeric(0))
  
  if (log.p) p <- exp(p)
  if (!lower.tail) p <- 1 - p
  
  nvld <- !is.na(p) & !(p >= 0 & p <= 1)
  p[nvld] <- NA_real_
  q <- .qdist(dist, p = p, ...)
  q[nvld] <- NaN
  if(.lgt) q <- exp(q)
  q
}

.rdist <- function(dist, n, ...) {
  fun <- paste0("r", dist, "_ssd")
  args <- list(...)
  args$n <- n
  r <- do.call(fun, args)
  if(any_missing(...)) return(NA_real_)
  r
}

rdist <- function(dist, n, ..., .lgt = FALSE) {
  if(!length(n)) return(numeric(0))
  
  if(length(n) > 1) {
    n <- length(n)
  }
  n <- floor(n)
  if(n < 0) stop("invalid arguments")
  if(n == 0L) return(numeric(0))

  r <- .rdist(dist, n = n, ...)
  if(.lgt) r <- exp(r)
  r
}

bdist <- function(dist) {
  fun <- paste0("b", dist)
  if(!exists(fun, mode = "function"))
    return(list(lower = -Inf, upper = Inf))
  do.call(fun)
}
