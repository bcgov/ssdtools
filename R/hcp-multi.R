hcp_multi <- function(x, value, ci, level, nboot, min_pboot,
                           data, rescale, weighted, censoring, min_pmix,
                           range_shape1, range_shape2, parametric, control,
                           save_to, samples, est_method, ci_method, hc) {
  
  estimates <- estimates(x, all_estimates = TRUE)
  dist <- "multi"
  fun <- fits_dists
  pars <- pars_fitdists(x)
  
  hcp <- hcp_tmbfit2(
    x, dist = dist, estimates = estimates, fun = fun, pars = pars,
    value = value, ci = ci, level = level, nboot = nboot, min_pboot = min_pboot,
    data = data, rescale = rescale, weighted = weighted, censoring = censoring,
    min_pmix = min_pmix, range_shape1 = range_shape1, range_shape2 = range_shape2,
    parametric = parametric, control = control, save_to = save_to,
    samples = samples, hc = hc, ci_method = ci_method, est_method = est_method
  )
  hcp$dist <- "average"
  hcp[c("dist", "value", "est", "se", "lcl", "ucl", "wt", "nboot", "pboot", "samples")]
}
