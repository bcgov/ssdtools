dweibull_cpp <- function(x, shape, scale, log_cpp) {
  if(shape <= 0 || scale <= 0) return(NaN)
  stats::dweibull(x = x, shape = shape, scale = scale, log = log_cpp)
}

pweibull_cpp <- function(q, shape, scale) {
  if(shape <= 0 || scale <= 0) return(NaN)
  stats::pweibull(q = q, shape = shape, scale = scale)
}

qweibull_cpp <- function(p, shape, scale) {
  if(shape <= 0 || scale <= 0) return(NaN)
  stats::qweibull(p = p, shape = shape, scale = scale)
}
