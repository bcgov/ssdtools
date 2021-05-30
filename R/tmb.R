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

tmb_fun <- function(data, parameters, dist) {
  model <- paste0("ll_", dist)
  data <- c(model = model, data)
  MakeADFun(data = data,
                 parameters = parameters,
                 DLL = "ssdtools_TMBExports", silent = TRUE)
}

tmb_parameters <- function(data, dist) {
  x <- rowMeans(data[c("left", "right")], na.rm = TRUE)
  fun <- paste0("s", dist)
  do.call(fun, list(x = x))
}

tmb_model <- function(data, dist) {
  parameters <- tmb_parameters(data, dist)
  tmb_fun(data, parameters, dist)
}

fit_tmb <- function(dist, data, control) {
  model <- tmb_model(data, dist)
  bounds <- bdist(dist)
  # required because model can switch order of parameters
  lower <- bounds$lower[names(model$par)]
  upper <- bounds$upper[names(model$par)]
  capture.output(
    optim <- optim(model$par, model$fn, model$gr, 
                   method = "L-BFGS-B",
                   lower = lower, upper = upper,
                   control= control, hessian = TRUE)
  )
  fit <- list(dist = dist, model = model, optim = optim)
  class(fit) <- "tmbfit"
  fit
}

.dist_tmbfit <- function(x) {
  x$dist
}

.objective_tmbfit <- function(x) {
  x$optim$value
}

.pars_tmbfit <- function(x) {
  x$optim$par
}
