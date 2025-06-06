hcp_ind_weight <- function(hcp, weight) {
  hcp <- mapply(
    function(x, y) {
      x$wt <- y
      x
    },
    x = hcp, y = weight,
    USE.NAMES = FALSE, SIMPLIFY = FALSE
  )
  hcp <- bind_rows(hcp)
  hcp[c("dist", "value", "est", "se", "lcl", "ucl", "wt", "nboot", "pboot", "samples")]
}

hcp_ind <- function(x, value, ci, level, nboot, min_pboot, estimates,
                    data, rescale,
                    weighted, censoring, min_pmix, range_shape1,
                    range_shape2, parametric,
                    control, est_method, ci_method, hc, save_to, samples, fun) {
  
  hcp <- purrr::map(
    x, hcp_tmbfit, weight = 1,
    value = value, ci = ci, level = level, nboot = nboot,
    min_pboot = min_pboot,
    data = data, rescale = rescale, weighted = weighted, censoring = censoring,
    min_pmix = min_pmix, range_shape1 = range_shape1, range_shape2 = range_shape2,
    parametric = parametric, est_method = est_method, ci_method = ci_method, average = FALSE, control = control,
    hc = hc, save_to = save_to, samples = samples, fun = fun
  )
  
  weight <- purrr::map_dbl(estimates, function(x) x$weight)
  
  hcp_ind_weight(hcp, weight = weight)
}
