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

pburrIII3 <- function(q, shape1 = 1, shape2 = 1, scale = 1, lower.tail = TRUE, log.p = FALSE) {
  pdist("burrIII3", q = q, shape1 = shape1, shape2 = shape2, scale = scale, 
        lower.tail = lower.tail, log.p = log.p)
}

qburrIII3 <- function(p, shape1 = 1, shape2 = 1, scale = 1, lower.tail = TRUE, log.p = FALSE) {
  qdist("burrIII3", p = p, shape1 = shape1, shape2 = shape2, scale = scale,
        lower.tail = lower.tail, log.p = log.p)
}

rburrIII3 <- function(n, shape1 = 1, shape2 = 1, scale = 1, chk = TRUE) {
  rdist("burrIII3", n = n, shape1 = shape1, shape2 = shape2, scale = scale, chk = chk)
}

sburrIII3 <- function(data) {
  list(log_scale = 1, log_shape1 = 0, log_shape2 = 0)
}

bburrIII3 <- function(x, data) {
  list(lower = list(log_scale = -Inf, log_shape1 = -3, log_shape2 = -3),
       upper = list(log_scale = Inf, log_shape1 = 3, log_shape2 = 3))
}

pburrIII3_ssd <- function(q, shape1, shape2, scale) {
  if(shape1 <= 0 || shape2 <= 0 || scale <= 0) return(NaN)
  1/pow(1+pow(1/(scale*q),shape2),shape1)
}

qburrIII3_ssd <- function(p, shape1, shape2, scale) {
  if(shape1 <= 0 || shape2 <= 0 || scale <= 0) return(NaN)
  (1/(pow(pow(1/p, 1/shape1) - 1,1/shape2)))/scale
}
