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

pllogis <- function(q, locationlog = 0, scalelog = 1, lower.tail = TRUE, log.p = FALSE) {
  pdist("logis", q = q,  location = locationlog, scale = scalelog, 
        lower.tail = lower.tail, log.p = log.p, .lgt = TRUE)
}

qllogis <- function(p, locationlog = 0, scalelog = 1, lower.tail = TRUE, log.p = FALSE) {
  qdist("logis", p = p,  location = locationlog, scale = scalelog,
        lower.tail = lower.tail, log.p = log.p, .lgt = TRUE)
}

rllogis <- function(n, locationlog = 0, scalelog = 1) {
  rdist("logis", n = n,  location = locationlog, scale = scalelog, .lgt = TRUE)
}

sllogis <- function(data) {
  x <- mean_weighted_values(data)
  
  list(
    locationlog = mean(log(x), na.rm = TRUE),
    log_scalelog = log(pi * sd(log(x), na.rm = TRUE) / sqrt(3))
  )
}

plogis_ssd <- function(q, location, scale) {
  if(scale <= 0) return(NaN)
  stats::plogis(q, location, scale)
}

qlogis_ssd <- function(p, location, scale) {
  if(scale <= 0) return(NaN)
  stats::qlogis(p, location, scale)
}

rlogis_ssd <- function(n, location, scale) {
  if(scale <= 0) return(rep(NaN, n))
  stats::rlogis(n, location, scale)
}

