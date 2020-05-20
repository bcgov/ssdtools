dgamma_cpp <- function(x, shape, scale, log_cpp) {
  if(shape <= 0 || scale <= 0) return(NaN)
  stats::dgamma(x = x, shape = shape, scale = scale, log = log_cpp)
}

pgamma_cpp <- function(q, shape, scale) {
  if(shape <= 0 || scale <= 0) return(NaN)
  stats::pgamma(q = q, shape = shape, scale = scale)
}

qgamma_cpp <- function(p, shape, scale) {
  if(shape <= 0 || scale <= 0) return(NaN)
  stats::qgamma(p = p, shape = shape, scale = scale)
}
