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

pgompertz <- function(q, location = 1, shape = 1, lower.tail = TRUE, log.p = FALSE) {
  pdist("gompertz", q = q, location = location, shape = shape, 
        lower.tail = lower.tail, log.p = log.p)
}

qgompertz <- function(p, location = 1, shape = 1, lower.tail = TRUE, log.p = FALSE) {
  qdist("gompertz", p = p, location = location, shape = shape, 
        lower.tail = lower.tail, log.p = log.p)
}

rgompertz <- function(n, location = 1, shape = 1) {
  rdist("gompertz", n = n, location = location, shape = shape)
}

sgompertz <- function(x) {
  fit <- vglm(x ~ 1, VGAM::gompertz)
  list(
    log_location = unname(coef(fit)[2]), log_shape = unname(coef(fit)[1])
  )
}
