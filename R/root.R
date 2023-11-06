#    Copyright 2023 Australian Government Department of 
#    Climate Change, Energy, the Environment and Water
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

wt_est_nest <- function(x) {
  glance <- glance(x)
  tidy <- tidy(x)
  
  wt <- dplyr::select(glance, "dist", "weight")
  est <- dplyr::select(tidy, "dist", "term", "est", "se")
  est_nest <- tidyr::nest(est, .by = "dist")
  dplyr::inner_join(wt, est_nest, by = "dist")
}

est_args <- function(x) {
  paste(x$term, "=", x$est, collapse = ", ")
}

ma_fun <- function(wt_est_nest, fun = "p") {
  funs <- paste0("ssd_", fun, wt_est_nest$dist)
  wts <- wt_est_nest$weight
  args <- purrr::map_chr(wt_est_nest$data, est_args)
  fun_args <- paste0(wts, " * ", funs, "(x, ", args, ")", collapse = " + ")
  
  func <- paste0("function(x, ", fun ,") {(", fun_args, ") - ", fun, "}")
  eval(parse(text = func))
}

hc_upper <- function(p, data) {
  right <- data$right[is.finite(data$right)]
  # TODO: ensure safe upper bound - use p as well?
  max(right) * 10
}

.ssd_hp_root <- function(conc, wt_est_nest, ci, level, nboot, min_pboot,
                         data, rescale, weighted, censoring, min_pmix,
                         range_shape1, range_shape2, parametric, control) {
  
  q <- conc/rescale
  p <- ssd_pcombo(q, wt_est_nest)

  tibble(
    est = p * 100,
    se = NA_real_,
    lcl = NA_real_,
    ucl = NA_real_,
    pboot = NA_real_
  )
}

.ssd_hc_root <- function(proportion, wt_est_nest, ci, level, nboot, min_pboot,
                         data, rescale, weighted, censoring, min_pmix,
                         range_shape1, range_shape2, parametric, control) {
  
  hc_upper <- hc_upper(proportion, data)
  q <- ssd_qcombo(proportion, wt_est_nest, upper_q = hc_upper)  

  tibble(
    est = q * rescale,
    se = NA_real_,
    lcl = NA_real_,
    ucl = NA_real_,
    pboot = NA_real_
  )
}
