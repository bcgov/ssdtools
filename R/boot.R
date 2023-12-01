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

boot_filename <- function(i, dist) {
  paste0("boot_", sprintf("%09s", i), "_", dist, ".csv")
}

boot_filepath <- function(i, dist, save_to) {
  file.path(save_to, boot_filename(i, dist))
}

sample_parameters <- function(i, dist, fun, data, args, pars, weighted, censoring, min_pmix, range_shape1, range_shape2, parametric, control, save_to) {
  new_data <- generate_data(dist,
    data = data, args = args, weighted = weighted, censoring = censoring,
    parametric = parametric
  )

  if(!is.null(save_to)) {
    if(!requireNamespace("readr", quietly = TRUE)) {
      err("Package 'readr' must be installed.")
    }
    readr::write_csv(new_data, boot_filepath(i, dist, save_to))
  }

  if (dist == "lnorm_lnorm") {
    pars <- slnorm_lnorm(new_data)
  }
  if(dist == "multi") {
    dist <- names(pars)
  }

  fit <- fun(new_data, dist,
    min_pmix = min_pmix, range_shape1 = range_shape1,
    range_shape2 = range_shape2, control = control, pars = pars, hessian = FALSE,
    censoring = censoring, weighted = weighted
  )$result
  
  if (is.null(fit)) {
    return(NULL)
  }
  estimates(fit, multi = TRUE)
}

boot_estimates <- function(fun, dist, estimates, pars, nboot, data, weighted, censoring, range_shape1, range_shape2, min_pmix, parametric, control, save_to) {
  sfun <- safely(fun)

  args <- list(n = nrow(data))
  args <- c(args, estimates)

  data <- data[c("left", "right", "weight")]
  
  seeds <- seed_streams(nboot)

  estimates <- future_map(1:nboot, sample_parameters,
    dist = dist, fun = sfun,
    data = data, args = args, pars = pars,
    weighted = weighted, censoring = censoring, min_pmix = min_pmix,
    range_shape1 = range_shape1, range_shape2 = range_shape2,
    parametric = parametric, control = control, save_to = save_to,
    .options = furrr::furrr_options(seed = seeds)
  )

  estimates[!vapply(estimates, is.null, TRUE)]
}
