# Copyright 2023 Environment and Climate Change Canada
#
#    Licensed under the Apache License, Version 2.0 (the "License");
#    you may not use this file except in compliance with the License.
#    You may obtain a copy of the License at
#
#       https://www.apache.org/licenses/LICENSE-2.0
#
#    Unless required by applicable law or agreed to in writing, software
#    distributed under the License is distributed on an "AS IS" BASIS,
#    WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
#    See the License for the specific language governing permissions and
#    limitations under the License.

warn_min_pboot <- function(x, min_pboot) {
  if (any(!is.na(x$pboot) & is.na(x$se) & x$nboot >= 2)) {
    wrn("One or more pboot values less than ", min_pboot, " (decrease min_pboot with caution).")
  }
  x
}

replace_min_pboot_na <- function(x, min_pboot) {
  x[!is.na(x$pboot) & x$pboot < min_pboot, c("se", "lcl", "ucl")] <- NA_real_
  x
}

sample_nonparametric <- function(data) {
  data[sample(nrow(data), replace = TRUE), ]
}

sample_parametric <- function(dist, args = args, weighted = weighted, censoring = censoring) {
  what <- paste0("ssd_r", dist)
  args$chk <- FALSE
  sample <- do.call(what, args)
  data <- data.frame(left = sample, right = sample)
  data$weight <- weighted
  censor_data(data, censoring)
}

generate_data <- function(dist, data, args, weighted, censoring, parametric) {
  if (!parametric) {
    return(sample_nonparametric(data))
  }
  sample_parametric(dist, args = args, weighted = weighted, censoring = censoring)
}

boot_filename <- function(i, dist, prefix, ext) {
  paste0(prefix, "_", stringr::str_pad(i, width = 9, pad = "0"), "_", dist, ext)
}

boot_filepath <- function(i, dist, save_to, prefix = "data", ext = ".csv") {
  file.path(save_to, boot_filename(i, dist, prefix = prefix, ext = ext))
}

sample_parameters <- function(i, dist, fun, data, args, pars, weighted, censoring, min_pmix, range_shape1, range_shape2, parametric, control, save_to, wts = NULL) {
  new_data <- generate_data(dist,
    data = data, args = args, weighted = weighted, censoring = censoring,
    parametric = parametric
  )

  if(!is.null(save_to)) {
    readr::write_csv(new_data, boot_filepath(i, dist, save_to))
  }

  if (dist == "lnorm_lnorm") {
    pars <- slnorm_lnorm(new_data)
  }
  if(dist == "multi") {
    dist2 <- names(pars)
  } else {
    dist2 <- dist
  }

  fit <- fun(new_data, dist2,
    min_pmix = min_pmix, range_shape1 = range_shape1,
    range_shape2 = range_shape2, control = control, pars = pars, hessian = FALSE,
    censoring = censoring, weighted = weighted
  )$result
  
  if (is.null(fit)) {
    return(NULL)
  }
  est <- estimates(fit, multi = TRUE)
  
  if(!is.null(save_to)) {
    saveRDS(est, boot_filepath(i, dist, save_to, prefix = "estimates", ext = ".rds"))
  }
  
  if(!is.null(wts)) {
    est[names(wts)] <- unname(wts)
  }
  est
}

boot_estimates <- function(fun, dist, estimates, pars, nboot, data, weighted, censoring, range_shape1, range_shape2, min_pmix, parametric, control, save_to, fix_weights) {
  sfun <- safely(fun)

  args <- list(n = nrow(data))
  args <- c(args, estimates)

  data <- data[c("left", "right", "weight")]
  
  seeds <- seed_streams(nboot)
  
  if(fix_weights) {
    wts <- estimates[stringr::str_detect(names(estimates), "\\.weight$")]
  } else {
    wts <- NULL
  }
  
  if(!is.null(save_to)) {
    if(!requireNamespace("readr", quietly = TRUE)) {
      err("Package 'readr' must be installed.")
    }
    readr::write_csv(data, boot_filepath(0, dist, save_to))
    saveRDS(estimates, boot_filepath(0, dist, save_to, prefix = "estimates", ext = ".rds"))
  }
  
  estimates <- future_map(1:nboot, sample_parameters,
    dist = dist, fun = sfun,
    data = data, args = args, pars = pars,
    weighted = weighted, censoring = censoring, min_pmix = min_pmix,
    range_shape1 = range_shape1, range_shape2 = range_shape2,
    parametric = parametric, control = control, save_to = save_to,
    wts = wts,
    .options = furrr::furrr_options(seed = seeds)
  )
  names(estimates) <- 1:length(estimates)
  estimates[!vapply(estimates, is.null, TRUE)]
}
