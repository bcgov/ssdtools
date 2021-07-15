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

pinvpareto <- function(q, shape = 3, scale = 1, lower.tail = TRUE, log.p = FALSE) {
  pdist("invpareto", q = q, shape = shape, scale = scale, 
        lower.tail = lower.tail, log.p = log.p)
}

qinvpareto <- function(p, shape = 3, scale = 1, lower.tail = TRUE, log.p = FALSE) {
  qdist("invpareto", p = p, shape = shape, scale = scale,
        lower.tail = lower.tail, log.p = log.p)
}

rinvpareto <- function(n, shape = 3, scale = 1) {
  rdist("invpareto", n = n, shape = shape, scale = scale)
}

sinvpareto <- function(x) {
  list(log_scale = log(max(x) * 2), log_shape = 0)
}

# binvpareto <- function(x, data) {
#   mx <- max(data$right)
#   list(lower = list(log_scale = log(mx), log_shape = -Inf),
#        upper = list(log_scale = Inf, log_shape = Inf))
# }

pinvpareto_ssd <- function(q, shape, scale) {
  if(shape <= 0 || scale <= 0) return(NaN)
  pow((q/scale),shape)
}

qinvpareto_ssd <- function(p, shape, scale) {
  if(shape <= 0 || scale <= 0) return(NaN)
  pow(p,1/shape) * scale
}
