ma_est <- function(est, wt, est_method) {
  if(est_method == "geometric") {
    return(exp(weighted.mean(log(est), w = wt)))
  }
  weighted.mean(est, w = wt)
}

ma_cl <- function(cl, wt, est_method) {
  if(est_method == "geometric") {
    return(exp(weighted.mean(log(cl), w = wt)))
  }
  weighted.mean(cl, w = wt)
}

hcp_ma <- function(hcp, weight, nboot, est_method, ci_method) {
  hcp <- hcp |>
    dplyr::bind_rows() |>
    dplyr::group_by(.data$value) |>
    dplyr::mutate(weight = weight) |>
    dplyr::summarise(
      est = ma_est(.data$est, .data$weight, est_method = est_method),
      lcl = ma_cl(.data$lcl, .data$weight, est_method = est_method),
      ucl = ma_cl(.data$ucl, .data$weight, est_method = est_method),
      se = ma_cl(.data$se, .data$weight, est_method = est_method),
      pboot = min(.data$pboot),
      samples = list(unlist(.data$samples))) |>
    dplyr::ungroup()
  
  hcp$dist <- "average"
  hcp$wt <- 1
  hcp$nboot <- nboot
  dplyr::arrange(hcp, .data$value)
}

hcp_conventional <- function(x, value, ci, level, nboot, est_method, min_pboot, estimates,
                             data, rescale, weighted, censoring, min_pmix,
                             range_shape1, range_shape2, parametric, control,
                             save_to, samples, ci_method, hc, fun) {
  
  weight <- purrr::map_dbl(estimates, function(x) x$weight)
  
  hcp <- purrr::map2(
    x, weight, hcp_tmbfit, value = value, ci = ci, level = level, nboot = nboot,
    min_pboot = min_pboot, data = data, rescale = rescale, weighted = weighted, censoring = censoring,
    min_pmix = min_pmix, range_shape1 = range_shape1, range_shape2 = range_shape2,
    parametric = parametric, est_method = est_method, ci_method = ci_method, average = TRUE, control = control,
    hc = hc, save_to = save_to, samples = samples, fun = fun
  )
  
  hcp_ma(hcp, weight, nboot = nboot, est_method = est_method, ci_method = ci_method)
}
