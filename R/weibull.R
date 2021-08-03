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

ssd_qweibull <- function(p, shape = 1, scale = 1, lower.tail = TRUE, log.p = FALSE) {
  qdist("weibull", p = p, shape = shape, scale = scale, 
        lower.tail = lower.tail, log.p = log.p)
}

#' @describeIn ssd_r Random Generation for Weibull Distribution
#' @export
#' @examples
#' 
#' set.seed(50)
#' hist(ssd_rweibull(10000), breaks = 1000)
ssd_rweibull <- function(n, shape = 1, scale = 1, chk = TRUE) {
  rdist("weibull", n = n, shape = shape, scale = scale, chk = chk)
}

sweibull <- function(data) {
  x <- mean_weighted_values(data)
  
  list(
    log_scale = log(mean(x, na.rm = TRUE)),
    log_shape = log(sd(x, na.rm = TRUE))
  )
}

pweibull_ssd <- function(q, shape, scale) {
  if(shape <= 0 || scale <= 0) return(NaN)
  stats::pweibull(q, shape, scale)
}

qweibull_ssd <- function(p, shape, scale) {
  if(shape <= 0 || scale <= 0) return(NaN)
  stats::qweibull(p, shape, scale)
}

rweibull_ssd <- function(n, shape, scale) {
  if(shape <= 0 || scale <= 0) return(rep(NaN, n))
  stats::rweibull(n, shape, scale)
}
