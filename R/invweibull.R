#    Copyright 2015 Province of British Columbia
#
#    Licensed under the Apache License, Version 2.0 (the "License");
#    you may not use this file except in compliance with the License.
#    You may obtain a copy of the License at
#
#       https://www.apache.org/licenses/LICENSE-2.0
#
#    Unless required by applicable law or agreed to in writing, software
#    distributed under the License is distributed on an "AS IS" BASIS,
#    WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
#    See the License for the specific language governing permissions and
#    limitations under the License.

pinvweibull <- function(q, shape = 1, scale = 1, lower.tail = TRUE, log.p = FALSE) {
  pdist("invweibull", q = q, shape = shape, scale = scale, 
        lower.tail = lower.tail, log.p = log.p)
}

qinvweibull <- function(p, shape = 1, scale = 1, lower.tail = TRUE, log.p = FALSE) {
  qdist("invweibull", p = p, shape = shape, scale = scale,
        lower.tail = lower.tail, log.p = log.p)
}

rinvweibull <- function(n, shape = 1, scale = 1) {
  rdist("invweibull", n = n, shape = shape, scale = scale)
}

sinvweibull <- function(x) {
  list(log_scale = 0, log_shape = 0)
}

pinvweibull_ssd <- function(q, shape, scale) {
  if(shape <= 0 || scale <= 0) return(NaN)
  1-pweibull_ssd(1/q, shape, scale)
}

qinvweibull_ssd <- function(p, shape, scale) {
  if(shape <= 0 || scale <= 0) return(NaN)
  1/qweibull_ssd(1-p, shape, scale)
}
