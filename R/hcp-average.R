replace_estimates <- function(hcp, est) {
  dplyr::select(est, "value", est2 = "est") |>
    dplyr::inner_join(hcp, by = "value") |>
    dplyr::mutate(est = .data$est2, est2 = NULL)
}

hcp_average <- function(
    x, value, data, ci, level, nboot, est_method,
    min_pboot, min_pmix,parametric,rescale, weighted, ci_method, censoring,
    range_shape1, range_shape2, estimates, control, hc, save_to,
    samples, fun) {
  
  if (.is_censored(censoring) && !identical_parameters(x)) {
    wrn("Model averaged estimates cannot be calculated for censored data when the distributions have different numbers of parameters.")
  }
  
  est_same <- FALSE
  ci_fun <- if (ci_method %in% c("multi_free", "multi_fixed")) {
    est_same <- est_method == "multi"
    hcp_multi
  } else if(ci_method == "weighted_samples") {
    hcp_weighted
  } else {
    est_same <- est_method %in% c("arithmetic", "geometric")
    hcp_conventional
  }
  
  hcp <- ci_fun(
    x, value, ci = ci, level = level, nboot = nboot, est_method = est_method,
    min_pboot = min_pboot, estimates = estimates,
    data = data, rescale = rescale, weighted = weighted, censoring = censoring,
    min_pmix = min_pmix, range_shape1 = range_shape1, range_shape2 = range_shape2,
    parametric = parametric, control = control, save_to = save_to, samples = samples,
    ci_method = ci_method, hc = hc, fun = fun
  ) 
  
  if(est_same) {
    return(hcp)
  }

  est_fun <- if(est_method == "multi") {
    hcp_multi
  } else {
    hcp_conventional
  }
  est <- est_fun(
    x, value, ci = FALSE, level = level, nboot = nboot, min_pboot = min_pboot,
    data = data, rescale = rescale, weighted = weighted, censoring = censoring,
    min_pmix = min_pmix, range_shape1 = range_shape1, range_shape2 = range_shape2,
    parametric = parametric, control = control, save_to = save_to, samples = samples,
    est_method = est_method, estimates = estimates,
    ci_method = ci_method, hc = hc
  )
  replace_estimates(hcp, est)
}
