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

ma_funp <- function(wt_est_nest) {
  funs <- paste0("ssd_p", wt_est_nest$dist)
  wts <- wt_est_nest$weight / sum(wt_est_nest$weight)
  args <- purrr::map_chr(wt_est_nest$data, est_args)
  fun_args <- paste0(wts, " * ", funs, "(x, ", args, ")", collapse = " + ")
  
  func <- paste0("function(x, p = 0) {(", fun_args, ") -  p}")
  eval(parse(text = func))
}

range_funq <- function(x, wt_est_nest) {
  funs <- paste0("ssd_q", wt_est_nest$dist)
  args <- purrr::map_chr(wt_est_nest$data, est_args)
  fun_args <- paste0(funs, "(x, ", args, ")", collapse = ", ")
  func <- paste0("list(", fun_args, ")", collapse = "")
  list <- eval(parse(text = func))
  tlist <- purrr::transpose(list)
  tlist <- purrr::map(tlist, unlist)
  min <- purrr::map_dbl(tlist, min)
  max <- purrr::map_dbl(tlist, max)
  list(lower = min, upper = max)
}

.ssd_hcp_root <- function(value, wt_est_nest, ci, level, nboot, min_pboot,
                          data, rescale, weighted, censoring, min_pmix,
                          range_shape1, range_shape2, parametric, control, hc) {
  if(hc) {
    est <- ssd_qmulti(value, wt_est_nest)
    est <- est * rescale
  } else {
    est <- value/rescale
    est <- ssd_pmulti(est, wt_est_nest)
    est <- est * 100
  }
  
  tibble(
    est = est,
    se = NA_real_,
    lcl = NA_real_,
    ucl = NA_real_,
    pboot = NA_real_
  )
}
