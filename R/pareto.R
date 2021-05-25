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

qpareto <- function(p, scale = 1, shape = 1, lower.tail = TRUE, log.p = FALSE) {
  deprecate_stop("0.2.1", "qpareto()",
                 details = "The 'pareto' distribution is not suitable for SSD data.")
  if (!length(p)) {
    return(numeric(0))
  }
  VGAM::qpareto(p, scale = scale, shape = shape, lower.tail = lower.tail, log.p = log.p)
}

ppareto <- function(q, scale = 1, shape = 1, lower.tail = TRUE, log.p = FALSE) {
  deprecate_stop("0.2.1", "ppareto()",
                 details = "The 'pareto' distribution is not suitable for SSD data.")
  if (!length(q)) {
    return(numeric(0))
  }
  VGAM::ppareto(q, scale = scale, shape = shape, lower.tail = lower.tail, log.p = log.p)
}

rpareto <- function(n, scale = 1, shape = 1) {
  deprecate_stop("0.2.1", "rpareto()",
                 details = "The 'pareto' distribution is not suitable for SSD data.")
  VGAM::rpareto(n, scale = scale, shape = shape)
}

spareto <- function(x) {
  deprecate_stop("0.2.1", "spareto()",
                 details = "The 'pareto' distribution is not suitable for SSD data.")
  fit <- vglm(x ~ 1, VGAM::paretoff)
  list(
    start = list(shape = exp(unname(coef(fit)))),
    fix.arg = list(scale = fit@extra$scale)
  )
}
