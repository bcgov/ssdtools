group_samples <- function(hcp) {
  bind_rows(hcp) |>
    dplyr::group_by(.data$value) |>
    dplyr::summarise(samples = list(unlist(.data$samples))) |>
    dplyr::ungroup()
}

hcp_average2 <- function(hcp, weight, value, nboot, est_method) {
  samples <- group_samples(hcp)
  
  hcp <- lapply(hcp, function(x) x[c("value", "est", "se", "lcl", "ucl", "pboot")])
  hcp <- lapply(hcp, as.matrix)
  hcp <- Reduce(function(x, y) {
    abind(x, y, along = 3)
  }, hcp)
  suppressMessages(min <- apply(hcp, c(1, 2), min))
  suppressMessages(hcp <- apply(hcp, c(1, 2), weighted_mean, w = weight, geometric = est_method == "geometric"))
  min <- as.data.frame(min)
  hcp <- as.data.frame(hcp)
  tib <- tibble(
    dist = "average", value = value, est = hcp$est, se = hcp$se,
    lcl = hcp$lcl, ucl = hcp$ucl, wt = rep(1, length(value)),
    nboot = nboot, pboot = min$pboot
  )
  tib <- dplyr::inner_join(tib, samples, by = "value")
  dplyr::arrange(tib, .data$value)
}

## uses weighted bootstrap to get se, lcl and ucl
hcp_weighted <- function(hcp, level, samples, min_pboot) {
  quantiles <- purrr::map(hcp$samples, stats::quantile, probs = probs(level))
  quantiles <- purrr::transpose(quantiles)
  hcp$lcl <- unlist(quantiles[[1]])
  hcp$ucl <- unlist(quantiles[[2]])
  hcp$se <- purrr::map_dbl(hcp$samples, sd)
  hcp$pboot <- pmin(purrr::map_dbl(hcp$samples, length) / hcp$nboot, 1)
  fail <- hcp$pboot < min_pboot
  hcp$lcl[fail] <- NA_real_
  hcp$ucl[fail] <- NA_real_
  hcp$se[fail] <- NA_real_
  if (!samples) {
    hcp$samples <- list(numeric(0))
  }
  hcp
}

hcp_conventional <- function(x, value, ci, level, nboot, est_method, min_pboot, estimates,
                                  data, rescale, weighted, censoring, min_pmix,
                                  range_shape1, range_shape2, parametric, control,
                                  save_to, samples, ci_method, hc, fun) {
  
  if (ci &&  ci_method == "weighted_samples") {
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
    hc = hc, save_to = save_to, samples = samples || ci_method == "weighted_samples", fun = fun
  )
  
  hcp <- hcp_average2(hcp, weight, value, nboot = nboot, est_method = est_method)
  if (ci_method != "weighted_samples") {
    if (!samples) {
      hcp$samples <- list(numeric(0))
    }
    return(hcp)
  }
  hcp_weighted(hcp, level = level, samples = samples, min_pboot = min_pboot)
}
