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

censor_data <- function(new_data, data) {
  censored <- data$left != data$right | data$left == 0 | is.infinite(data$right)
  if(!any(censored)) return(new_data)
  .NotYetImplemented()
}

generate_new_data <- function(estimates, data, dist) {
  n <- nrow(data)
  what <- paste0("r", dist)
  args <- list(n = n)
  args <- c(args, estimates)
  sample <- do.call(what, args)
  new_data <- data.frame(left = sample, right = sample)
  new_data$weight <- 1
  new_data <- censor_data(new_data, data)
  new_data
}

sample_parameters <- function(i, estimates, data, dist, control) {
  new_data <- generate_new_data(estimates, data, dist)
  fit <- fit_tmb(dist, new_data, control = control)
  estimates(fit)
}

boot_tmbfit <- function(x, nboot, data, control, parallel, ncpus) {
  # need to do parallel
  dist <- .dist_tmbfit(x)
  estimates <- estimates(x)
  lapply(1:nboot, sample_parameters, estimates = estimates, data = data, dist = dist, control = control)
}
