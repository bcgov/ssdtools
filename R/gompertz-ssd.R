#    Copyright 2015 Province of British Columbia
#
#    Licensed under the Apache License, Version 2.0 (the "License");
#    you may not use this file except in compliance with the License.
#    You may obtain a copy of the License at
#
#       http://www.apache.org/licenses/LICENSE-2.0
#
#    Unless required by applicable law or agreed to in writing, software
#    distributed under the License is distributed on an "AS IS" BASIS,
#    WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
#    See the License for the specific language governing permissions and
#    limitations under the License.


#' @rdname gompertz
#' @export
dgompertz_ssd<- function(x, scale, shape) {
  if(is.na(scale) || is.na(shape)) return (NA_real_)
  if(scale <= 0 || shape <= 0) return (NaN)
  index0 <- (x < 0)
  index1 <- abs(x * scale) < 0.1 & is.finite(x * scale)
  ans <- log(shape) + x * scale - (shape/scale) * (exp(x * 
                                                         scale) - 1)
  ans[index1] <- log(shape[index1]) + x[index1] * scale[index1] - 
    (shape[index1]/scale[index1]) * expm1(x[index1] * scale[index1])
  ans[index0] <- log(0)
  ans[x == Inf] <- log(0)
  ans
}

#' @rdname gompertz
#' @export
qgompertz_ssd <- function(p, scale, shape) {
  if(is.na(scale) || is.na(shape)) return (NA_real_)
  if(scale <= 0 || shape <= 0) return (NaN)
  ans <- log1p((-scale/shape) * log1p(-p))/scale
  ans[p < 0] <- NaN
  ans[p == 0] <- 0
  ans[p == 1] <- Inf
  ans[p > 1] <- NaN
  ans
}

#' @rdname gompertz
#' @export
pgompertz_ssd <- function(q, scale, shape) {
  if(is.na(scale) || is.na(shape)) return (NA_real_)
  if(scale <= 0 || shape <= 0) return (NaN)
  ans <- -expm1((-shape/scale) * expm1(scale * q))
  ans[q <= 0] <- 0
  ans[q == Inf] <- 1
  ans
}

#' @rdname gompertz
#' @export
rgompertz_ssd <- function(n, scale, shape) {
  stopifnot(identical(length(scale), 1L))
  stopifnot(identical(length(scale), 1L))
  if(is.na(scale) || is.na(shape)) return (NA_real_)
  if(scale <= 0 || shape <= 0) return (rep(NaN, n))
  qgompertz_ssd(runif(n), scale = scale, shape = shape)
}
