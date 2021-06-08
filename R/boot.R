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

generate_data <- function(dist, args, weighted, censoring) {
  what <- paste0("r", dist)
  sample <- do.call(what, args)
  data <- data.frame(left = sample, right = sample)
  data$weight <- weighted
  censor_data(data, censoring)
}

sample_parameters <- function(i, dist, args, pars, weighted, censoring, control) {
  new_data <- generate_data(dist, args, weighted, censoring)
  fit <- fit_tmb(dist, new_data, control = control, pars = pars, hessian = FALSE)
  estimates(fit)
}

boot_tmbfit <- function(x, nboot, data, weighted, censoring, control, parallel, ncpus) {
  # need to do parallel
  dist <- .dist_tmbfit(x)
  args <- list(n = nrow(data))
  args <- c(args, estimates(x))
  pars <- .pars_tmbfit(x)

  lapply(1:nboot, sample_parameters, dist = dist, args = args, pars = pars, 
         weighted = weighted, censoring = censoring, control = control)
}
