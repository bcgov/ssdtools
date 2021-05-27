tmb_fun <- function(data, parameters, dist) {
  model <- paste0("ll_", dist)
  data <- c(model = model, data)
  TMB::MakeADFun(data = data,
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

fit_tmb <- function(dist, data) {
  model <- tmb_model(data, dist)
  bounds <- bdist(dist)
  # required because model can switch order of parameters
  lower <- bounds$lower[names(model$par)]
  upper <- bounds$upper[names(model$par)]
  control <- list()
  capture.output(
    optim <- optim(model$par, model$fn, model$gr, 
                   method = "L-BFGS-B",
                   lower = lower, upper = upper,
                   control= control, hessian = TRUE)
  )
  fit <- list(dist = dist, model = model, optim = optim, data = data)
  class(fit) <- "tmbfit"
  fit
}

.data_tmbfit <- function(x) {
  x$data
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
