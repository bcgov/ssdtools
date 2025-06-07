hcp_wb <- function(hcp, weight, level, nboot) {
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

get_nboots <- function(weight, nboot) {
  nboots <- as.integer(round(weight * nboot))
  
  while(sum(nboots) != nboot) {
    diff <- nboots/nboot - weight
    if(sum(nboots) < nboot) {
      wch <- which.min(diff)
      nboots[wch] <- nboots[wch] + 1L
    } else {
      wch <- which.max(diff)
      nboots[wch] <- nboots[wch] - 1L
    }
  }
  nboots
}

hcp_weighted <- function(x, value, level, nboot, est_method, min_pboot, estimates,
                         data, rescale, weighted, censoring, min_pmix,
                         range_shape1, range_shape2, parametric, control,
                         save_to, ci_method, hc, fun, ...) {
  
  weight <- glance(x, wt = TRUE)$wt
  nboots <- get_nboots(weight, nboot)
  
  x <- subset(x, names(x)[nboots > 0])
  nboots <- nboots[nboots > 0]
  weight <- glance(x, wt = TRUE)$wt

  hcp <- purrr::map2(
    x, nboots, hcp_tmbfit, value = value, ci = TRUE, level = level,
    min_pboot = min_pboot, data = data, rescale = rescale, weighted = weighted, censoring = censoring,
    min_pmix = min_pmix, range_shape1 = range_shape1, range_shape2 = range_shape2,
    parametric = parametric, est_method = est_method, ci_method = ci_method, average = TRUE, control = control,
    hc = hc, save_to = save_to, samples = TRUE, fun = fun
  )
  
  hcp_wb(hcp, weight = weight, level = level, nboot = nboot)
}
