replace_estimates <- function(hcp, est) {
  est <- dplyr::select(est, "value", est2 = "est")
  hcp <- dplyr::inner_join(hcp, est, by = "value")
  dplyr::mutate(hcp, est = .data$est2, est2 = NULL)
}

hcp_average <- function(
    x, value, data, ci, level, nboot, est_method,
    min_pboot, min_pmix,parametric,rescale, weighted, ci_method, censoring,
    range_shape1, range_shape2, estimates, control, hc, save_to,
    samples, fun) {
  
  if (.is_censored(censoring) && !identical_parameters(x)) {
    wrn("Model averaged estimates cannot be calculated for censored data when the distributions have different numbers of parameters.")
  }
  
  if (ci_method %in% c("multi_free", "multi_fixed")) {
    hcp <- hcp_multi(
      x, value, ci = ci, level = level, nboot = nboot,
      min_pboot = min_pboot, data = data, rescale = rescale, weighted = weighted, censoring = censoring, 
      min_pmix = min_pmix, range_shape1 = range_shape1, range_shape2 = range_shape2,
      parametric = parametric, control = control, save_to = save_to, samples = samples,
      est_method = est_method,
      ci_method = ci_method, hc = hc
    )
    
    if (est_method == "multi") {
      return(hcp)
    }
  } else if(ci_method == "weighted_samples") {
    hcp <- hcp_weighted(
      x, value, ci = ci, level = level, nboot = nboot, est_method = est_method,
      min_pboot = min_pboot, estimates = estimates,
      data = data, rescale = rescale, weighted = weighted, censoring = censoring,
      min_pmix = min_pmix, range_shape1 = range_shape1, range_shape2 = range_shape2,
      parametric = parametric, control = control, save_to = save_to, samples = samples,
      ci_method = ci_method, hc = hc, fun = fun
    ) 
  } else {
    hcp <- hcp_conventional(
      x, value, ci = ci, level = level, nboot = nboot, est_method = est_method,
      min_pboot = min_pboot, estimates = estimates,
      data = data, rescale = rescale, weighted = weighted, censoring = censoring,
      min_pmix = min_pmix, range_shape1 = range_shape1, range_shape2 = range_shape2,
      parametric = parametric, control = control, save_to = save_to, samples = samples,
      ci_method = ci_method, hc = hc, fun = fun
    )
    if(est_method %in% c("arithmetic", "geometric")) {
      return(hcp)
    }
  }
  if(est_method == "multi") {
    est <- hcp_multi(
      x, value, ci = FALSE, level = level, nboot = nboot, min_pboot = min_pboot,
      data = data, rescale = rescale, weighted = weighted, censoring = censoring,
      min_pmix = min_pmix, range_shape1 = range_shape1, range_shape2 = range_shape2,
      parametric = parametric, control = control, save_to = save_to, samples = samples,
      est_method = est_method,
      ci_method = ci_method, hc = hc
    )
  } else {
    est <- hcp_conventional(
      x, value, ci = FALSE, level = level, nboot = nboot, est_method = est_method,
      min_pboot = min_pboot, estimates = estimates,
      data = data, rescale = rescale, weighted = weighted, censoring = censoring,
      min_pmix = min_pmix, range_shape1 = range_shape1, range_shape2 = range_shape2,
      parametric = parametric, control = control, save_to = save_to, samples = samples,
      ci_method = ci_method, hc = hc, fun = fun
    )
  }
  replace_estimates(hcp, est)
}
