tmb_model <- function(data, left, right, weight, dist) {
  data <- data.frame(left = data[[left]], right = data[[right]], weight = data[[weight]])
  x <- rowMeans(data[c("left", "right")], na.rm = TRUE)
  parameters <- do.call(paste0("s", dist, "_tmb"), list(x = x))
  data <- as.list(data)
  dll <- paste0("ll_", dist)
  print(data)
  print(parameters)
  print(dll)
  TMB::MakeADFun(data, parameters, DLL = dll)
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

tmb_sd <- function(fit) {
  capture.output(sd <- TMB::sdreport(fit$model))
  summary(sd)
}
