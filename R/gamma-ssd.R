pgamma_ssd <- function(q, shape, scale) {
  if(shape <= 0 || scale <= 0) return(NaN)
  stats::pgamma(q = q, shape = shape, scale = scale)
}

qgamma_ssd <- function(p, shape, scale) {
  if(shape <= 0 || scale <= 0) return(NaN)
  stats::qgamma(p = p, shape = shape, scale = scale)
}
