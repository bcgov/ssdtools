hcp_wb <- function(hcp, weight, level, samples, nboot, min_pboot) {
  hcp <- hcp |>
    dplyr::bind_rows() |>
    dplyr::group_by(.data$value) |>
    dplyr::mutate(weight = weight) |>
    dplyr::summarise(
      pboot = min(.data$pboot),
      samples = list(unlist(.data$samples))) |>
    dplyr::ungroup()
  
  ## uses weighted bootstrap to get se, lcl and ucl
  quantiles <- purrr::map(hcp$samples, stats::quantile, probs = probs(level))
  quantiles <- purrr::transpose(quantiles)
  
  hcp |> 
    dplyr::mutate(
      lcl = unlist(quantiles[[1]]),
      ucl = unlist(quantiles[[2]]),
      se = purrr::map_dbl(.data$samples, sd),
      pboot = pmin(purrr::map_dbl(.data$samples, length) / nboot, 1))
}

hcp_weighted <- function(x, value, ci, level, nboot, est_method, min_pboot, estimates,
                         data, rescale, weighted, censoring, min_pmix,
                         range_shape1, range_shape2, parametric, control,
                         save_to, samples, ci_method, hc, fun) {
  
  # FIXME: ensure always sum to nboot!
  if (ci) {
    atleast1 <- round(glance(x, wt = TRUE)$wt * nboot) >= 1L
    x <- subset(x, names(x)[atleast1])
    estimates <- estimates[atleast1]
  }
  weight <- purrr::map_dbl(estimates, function(x) x$weight)
  nboots <- round(nboot * weight)

  hcp <- purrr::map2(
    x, nboots, hcp_tmbfit, value = value, ci = ci, level = level,
    min_pboot = min_pboot, data = data, rescale = rescale, weighted = weighted, censoring = censoring,
    min_pmix = min_pmix, range_shape1 = range_shape1, range_shape2 = range_shape2,
    parametric = parametric, est_method = est_method, ci_method = ci_method, average = TRUE, control = control,
    hc = hc, save_to = save_to, samples = TRUE, fun = fun
  )
  
  hcp_wb(hcp, weight = weight, level = level, samples = samples, nboot = nboot, min_pboot = min_pboot)
}
