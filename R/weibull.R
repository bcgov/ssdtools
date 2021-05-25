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

pweibull <- function(q, shape = 1, scale = 1, lower.tail = TRUE, log.p = FALSE) {
  pdist("weibull", q = q, shape = shape, scale = scale, 
        lower.tail = lower.tail, log.p = log.p)
}

qweibull <- function(p, shape = 1, scale = 1, lower.tail = TRUE, log.p = FALSE) {
  qdist("weibull", p = p, shape = shape, scale = scale, 
        lower.tail = lower.tail, log.p = log.p)
}

rweibull <- function(n, shape = 1, scale = 1) {
  rdist("weibull", n = n, shape = shape, scale = scale)
}

sweibull_tmb <- function(x) {
  list(
    log_scale = log(mean(x, na.rm = TRUE)),
    log_shape = log(sd(x, na.rm = TRUE))
  )
}
