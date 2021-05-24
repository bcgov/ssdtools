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

boot <- function(x, nboot, parallel, ncpus) {
  UseMethod("boot")
}

censor_data <- function(new_data, data) {
  censored <- data$left != data$right | data$left == 0 | is.infinite(data$right)
  if(!any(censored)) return(new_data)
  .NotYetImplemented()
}

generate_new_data <- function(x) {
  data <- .data_tmbfit(x)
  dist <- .dist_tmbfit(x)
  
  n <- nrow(data)
  what <- paste0("r", dist)
  args <- list(n = n)
  args <- c(args, estimates(x))
  sample <- do.call(what, args)
  new_data <- tibble::tibble(left = sample, right = sample)
  new_data$weight <- 1
  new_data <- censor_data(new_data, data)
  new_data
}

sample_parameters <- function(n, x) {
  dist <- .dist_tmbfit(x)
  new_data <- generate_new_data(x)
  fit <- ssd_fit_dist(new_data, left = "left", right = "right", dist = dist, tmb = TRUE)
  estimates(fit)
}

boot_tmbfit <- function(x, nboot, parallel, ncpus) {
  # need to do parallel
  lapply(1:nboot, sample_parameters, x = x)
}

boot.fitdist <- function(x, nboot, parallel, ncpus) {
  fitdistrplus::bootdist(x,
    niter = nboot, parallel = parallel,
    ncpus = ncpus
  )
}

boot.fitdistcens <- function(x, nboot, parallel, ncpus) {
  fitdistrplus::bootdistcens(x,
    niter = nboot, parallel = parallel,
    ncpus = ncpus
  )
}
