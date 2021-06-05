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

# censor_data <- function(new_data, data) {
#   censored <- data$left != data$right | data$left == 0 | is.infinite(data$right)
#   if(!any(censored)) return(new_data)
#   .NotYetImplemented()
# }

generate_new_data <- function(dist, args) {
  what <- paste0("r", dist)
  sample <- do.call(what, args)
  data <- data.frame(left = sample, right = sample)
  data$weight <- 1
#  data <- censor_data(new_data, data)
  data
}

sample_parameters <- function(i, dist, args, control) {
  new_data <- generate_new_data(dist, args)
  fit <- fit_tmb(dist, new_data, control = control) # and this
  estimates(fit) # this really needs speeding up
}

boot_tmbfit <- function(x, nboot, data, control, parallel, ncpus) {
  # need to do parallel
  dist <- .dist_tmbfit(x)
  args <- list(n = nrow(data))
  args <- c(args, estimates(x))
  
  lapply(1:nboot, sample_parameters, dist = dist, args = args, control = control)
}
