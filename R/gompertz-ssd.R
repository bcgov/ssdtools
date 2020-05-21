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


dgompertz_ssd<- function(x, scale, shape) {
  if(is.na(scale) || is.na(shape)) return (NA_real_)
  if(scale <= 0 || shape <= 0) return (NaN)
  log(shape) + x * scale - (shape/scale) * (exp(x * scale) - 1)
}

qgompertz_ssd <- function(p, scale, shape) {
  if(is.na(scale) || is.na(shape)) return (NA_real_)
  if(scale <= 0 || shape <= 0) return (NaN)
  log(1 - scale/shape * log(1-p)) / scale
}

pgompertz_ssd <- function(q, scale, shape) {
  if(is.na(scale) || is.na(shape)) return (NA_real_)
  if(scale <= 0 || shape <= 0) return (NaN)
  1 - exp(-scale/shape * (exp(shape*q) - 1))
}

rgompertz_ssd <- function(n, scale, shape) {
  stopifnot(identical(length(scale), 1L))
  stopifnot(identical(length(shape), 1L))
  if(is.na(scale) || is.na(shape)) return (NA_real_)
  if(scale <= 0 || shape <= 0) return (rep(NaN, n))
  qgompertz_ssd(runif(n), scale = scale, shape = shape)
}
