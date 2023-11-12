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

sample_parameters <- function(i, dist, fun, data, args, pars, weighted, censoring, min_pmix, range_shape1, range_shape2, parametric, control) {
  new_data <- generate_data(dist,
    data = data, args = args, weighted = weighted, censoring = censoring,
    parametric = parametric
  )

  if (dist == "lnorm_lnorm") {
    pars <- slnorm_lnorm(new_data)
  }

  fit <- fun(dist, new_data,
    min_pmix = min_pmix, range_shape1 = range_shape1,
    range_shape2 = range_shape2, control = control, pars = pars, hessian = FALSE
  )$result

  if (is.null(fit)) {
    return(NULL)
  }
  estimates(fit)
}

boot_estimates <- function(x, fun, nboot, data, weighted, censoring, range_shape1, range_shape2, min_pmix, parametric, control) {
  dist <- .dist_tmbfit(x)
  args <- list(n = nrow(data))
  args <- c(args, estimates(x))
  pars <- .pars_tmbfit(x)

  data <- data[c("left", "right", "weight")]

  estimates <- lapply(1:nboot, sample_parameters,
    dist = dist, fun = fun,
    data = data, args = args, pars = pars,
    weighted = weighted, censoring = censoring, min_pmix = min_pmix,
    range_shape1 = range_shape1, range_shape2 = range_shape2,
    parametric = parametric, control = control
  )

  estimates[!vapply(estimates, is.null, TRUE)]
}
