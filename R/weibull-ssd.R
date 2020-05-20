dweibull_ssd <- function(x, shape, scale, log_ssd) {
  if(shape <= 0 || scale <= 0) return(NaN)
  stats::dweibull(x = x, shape = shape, scale = scale, log = log_ssd)
}

pweibull_ssd <- function(q, shape, scale) {
  if(shape <= 0 || scale <= 0) return(NaN)
  stats::pweibull(q = q, shape = shape, scale = scale)
}

qweibull_ssd <- function(p, shape, scale) {
  if(shape <= 0 || scale <= 0) return(NaN)
  stats::qweibull(p = p, shape = shape, scale = scale)
}
