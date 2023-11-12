# Copyright 2023 Environment and Climate Change Canada
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

tmb_model <- function(dist, data, pars) {
  model <- paste0("ll_", dist)
  data <- c(model = model, data)
  map <- mdist(dist)
  MakeADFun(
    data = data,
    parameters = pars,
    map = map,
    DLL = "ssdtools_TMBExports", silent = TRUE
  )
}

optimize <- function(par, fn, gr, lower, upper, control, hessian) {
  chk_null_or(control$trace, vld = vld_whole_numeric)

  method <- "L-BFGS-B"
  if (is.null(control$trace) || control$trace < 1) {
    capture.output(
      optim <- optim(par, fn, gr,
        method = method,
        lower = lower, upper = upper,
        control = control, hessian = hessian
      )
    )
  } else {
    optim <- optim(par, fn, gr,
      method = method,
      lower = lower, upper = upper,
      control = control, hessian = hessian
    )
  }
  optim
}

fit_tmb <- function(dist, data, min_pmix, range_shape1, range_shape2,
                    control, pars = NULL, hessian = TRUE) {
  pars <- sdist(dist, data, pars)
  model <- tmb_model(dist, data, pars = pars)
  bounds <- bdist(dist, data, min_pmix, range_shape1, range_shape2)
  # required because model can switch order of parameters
  lower <- bounds$lower[names(model$par)]
  upper <- bounds$upper[names(model$par)]

  optim <- optimize(model$par, model$fn, model$gr,
    lower = lower, upper = upper,
    control = control, hessian = hessian
  )

  fit <- list(dist = dist, model = model, optim = optim)
  class(fit) <- "tmbfit"
  fit$est <- .tidy_tmbfit_estimates(fit)
  fit$pars <- replace_missing(fit$optim$par, pars)
  fit$pars <- fit$pars[stringr::str_order(strip_loglogit(names(fit$pars)))]
  fit
}

.dist_tmbfit <- function(x) {
  x$dist
}

.objective_tmbfit <- function(x) {
  x$optim$value
}

.pars_tmbfit <- function(x) {
  x$pars
}

.ests_tmbfit <- function(x) {
  x$est
}
