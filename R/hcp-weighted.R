hcp_ma2 <- function(hcp, weight, est_method, ci_method) {
  hcp <- hcp |>
    dplyr::bind_rows() |>
    dplyr::group_by(.data$value) |>
    dplyr::mutate(weight = weight) |>
    dplyr::summarise(
      pboot = min(.data$pboot),
      samples = list(unlist(.data$samples))) |>
    dplyr::ungroup()

  dplyr::arrange(hcp, .data$value)
}

## uses weighted bootstrap to get se, lcl and ucl
hcp_wb <- function(hcp, level, samples, nboot, min_pboot) {
  quantiles <- purrr::map(hcp$samples, stats::quantile, probs = probs(level))
  quantiles <- purrr::transpose(quantiles)
  hcp$lcl <- unlist(quantiles[[1]])
  hcp$ucl <- unlist(quantiles[[2]])
  hcp$se <- purrr::map_dbl(hcp$samples, sd)
  hcp$pboot <- pmin(purrr::map_dbl(hcp$samples, length) / nboot, 1)
  fail <- hcp$pboot < min_pboot
  hcp$lcl[fail] <- NA_real_
  hcp$ucl[fail] <- NA_real_
  hcp$se[fail] <- NA_real_
  if (!samples) {
    hcp$samples <- list(numeric(0))
  }
  hcp
}

hcp_weighted <- function(x, value, ci, level, nboot, est_method, min_pboot, estimates,
                             data, rescale, weighted, censoring, min_pmix,
                             range_shape1, range_shape2, parametric, control,
                             save_to, samples, ci_method, hc, fun) {
  
  if (ci) {
    atleast1 <- round(glance(x, wt = TRUE)$wt * nboot) >= 1L
    x <- subset(x, names(x)[atleast1])
    estimates <- estimates[atleast1]
  }
  weight <- purrr::map_dbl(estimates, function(x) x$weight)
  
  hcp <- purrr::map2(
    x, weight, hcp_tmbfit, value = value, ci = ci, level = level, nboot = nboot,
    min_pboot = min_pboot, data = data, rescale = rescale, weighted = weighted, censoring = censoring,
    min_pmix = min_pmix, range_shape1 = range_shape1, range_shape2 = range_shape2,
    parametric = parametric, est_method = est_method, ci_method = ci_method, average = TRUE, control = control,
    hc = hc, save_to = save_to, samples = samples, fun = fun
  )
  
  hcp <- hcp_ma2(hcp, weight, est_method = est_method, ci_method = ci_method)
  hcp <- hcp_wb(hcp, level = level, samples = samples, nboot = nboot, min_pboot = min_pboot)
  if (!samples) {
    hcp$samples <- list(numeric(0))
  }
  hcp
}
