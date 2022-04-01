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
  if(!log) d <- exp(d)
  d
}

ddist <- function(dist, x, ..., log = FALSE, .lgt = FALSE) {
  if(!length(x)) return(numeric(0))
  
  if(!.lgt)
    return(.ddist(dist, x = x, ..., log = log))
  
  lte <- !is.na(x) & x <= 0
  x[lte] <- NA_real_
  d <- .ddist(dist, x = log(x),  ..., log = FALSE) / x
  d[lte] <- 0
  if (log) return(log(d))
  d
}
