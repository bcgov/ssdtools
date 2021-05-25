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

dgamma <- function(x, shape = 1, scale = 1, log = FALSE) {
  ddist("gamma", x,  shape = shape, scale = scale, 
        log = log)
}

pgamma <- function(q, shape = 1, scale = 1, lower.tail = TRUE, log.p = FALSE) {
  pdist("gamma", q = q, shape = shape, scale = scale, 
             lower.tail = lower.tail, log.p = log.p)
}

qgamma <- function(p, shape = 1, scale = 1, lower.tail = TRUE, log.p = FALSE) {
  qdist("gamma", p = p, shape = shape, scale = scale, 
        lower.tail = lower.tail, log.p = log.p)
}

rgamma <- function(n, shape = 1, scale = 1) {
  rdist("gamma", n = n, shape = shape, scale = scale)
}

sgamma <- function(x) {
  var <- var(x, na.rm = TRUE)
  mean <- mean(x, na.rm = TRUE)
  list(
    log_scale = log(var / mean),
    log_shape = log(mean^2 / var)
  )
}
