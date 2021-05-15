tmb_fun <- function(data, parameters, dist) {
  model <- paste0("ll_", dist)
  data <- c(model = model, data)
  TMB::MakeADFun(data = data,
                  parameters = parameters,
                  DLL = "ssdtools_TMBExports", silent = TRUE)
}

tmb_parameters <- function(data, dist) {
  x <- rowMeans(data[c("left", "right")], na.rm = TRUE)
  fun <- paste0("s", dist, "_tmb")
  do.call(fun, list(x = x))
}

tmb_model <- function(data, left, right, weight, dist) {
  data <- data.frame(left = data[[left]], right = data[[right]], weight = data[[weight]])
  parameters <- tmb_parameters(data, dist)
  tmb_fun(data, parameters, dist)
}

fit_tmb <- function(data, left, right, weight, dist) {
  if(is.null(weight)) { # this should happen before
    data$weight <- 1
    weight <- "weight"
  }
  
  model <- tmb_model(data, left, right, weight, dist)
  control <- list(eval.max = 10000, iter.max = 1000)
  capture.output(nlminb(model$par, model$fn, model$gr, model$he, control= control))
  fit <- list(dist = dist, model = model)
  class(fit) <- "tmbfit"
  fit
}
