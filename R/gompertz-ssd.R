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

dgompertz_ssd<- function(x, location, shape) {
  if(is.na(location) || is.na(shape)) return (NA_real_)
  if(location <= 0 || shape <= 0) return (NaN)
  log(location) + x * shape - (location/shape) * (exp(x * shape) - 1)
}

pgompertz_ssd <- function(q, location, shape) {
  if(is.na(location) || is.na(shape)) return (NA_real_)
  if(location <= 0 || shape <= 0) return (NaN)
  1 - exp(-location/shape * (exp(q * shape) - 1))
}

qgompertz_ssd <- function(p, location, shape) {
  if(is.na(location) || is.na(shape)) return (NA_real_)
  if(location <= 0 || shape <= 0) return (NaN)
  log(1 - shape/location * log(1-p)) / shape
}

rgompertz_ssd <- function(n, location, shape) {
  stopifnot(identical(length(location), 1L))
  stopifnot(identical(length(shape), 1L))
  if(is.na(location) || is.na(shape)) return (NA_real_)
  if(location <= 0 || shape <= 0) return (rep(NaN, n))
  qgompertz_ssd(runif(n), location = location, shape = shape)
}
