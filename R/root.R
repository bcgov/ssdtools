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

est_args <- function(x) {
  paste(x$term, "=", x$est, collapse = ", ")
}

ma_funp <- function(wt_est) {
  funs <- paste0("ssd_p", wt_est$dist)
  wts <- wt_est$weight / sum(wt_est$weight)
  args <- purrr::map_chr(wt_est$data, est_args)
  fun_args <- paste0(wts, " * ", funs, "(x, ", args, ")", collapse = " + ")
  
  func <- paste0("function(x, p = 0) {(", fun_args, ") -  p}")
  eval(parse(text = func))
}

range_funq <- function(x, wt_est) {
  funs <- paste0("ssd_q", wt_est$dist)
  args <- purrr::map_chr(wt_est$data, est_args)
  fun_args <- paste0(funs, "(x, ", args, ")", collapse = ", ")
  func <- paste0("list(", fun_args, ")", collapse = "")
  list <- eval(parse(text = func))
  tlist <- purrr::transpose(list)
  tlist <- purrr::map(tlist, unlist)
  min <- purrr::map_dbl(tlist, min)
  max <- purrr::map_dbl(tlist, max)
  list(lower = min, upper = max)
}

.ssd_hcp_multi <- function(value, wt_est, ci, level, nboot, min_pboot,
                           data, rescale, weighted, censoring, min_pmix,
                           range_shape1, range_shape2, parametric, control, hc) {
  
  args <- list()
  if(hc) {
    args$p <- value
    what <- paste0("ssd_qmulti")
  } else {
    args$q <- value / rescale
    what <- paste0("ssd_pmulti")
  }
  args$wt_est <- wt_est
  est <- do.call(what, args)

  # FIXME: multiply somewhere else?
  if(!hc) {
    est <- est * 100
  }

  if(!ci) {
    return(tibble(
      est = est,
      se = NA_real_,
      lcl = NA_real_,
      ucl = NA_real_,
      pboot = NA_real_
    ))
  }
  .NotYetImplemented()
  # seeds <- seed_streams(nboot)
  # bootn <- 1:nboot
  # future_map(
  #   bootn, .ssd_hcp_multi,
  #   wt_est = wt_est, 
  #   data = data, rescale = rescale, weighted = weighted, censoring = censoring,
  #   min_pmix = min_pmix, range_shape1 = range_shape1, range_shape2 = range_shape2,
  #   parametric = parametric, control = control, hc = hc,
  #   .options = furrr::furrr_options(seed = seeds))
  
  # this is what doing for other one....
  # censoring <- censoring / rescale
  # fun <- safely(fit_tmb)
  # estimates <- boot_estimates(
  #   x, fun = fun, nboot = nboot, data = data, weighted = weighted,
  #   censoring = censoring, min_pmix = min_pmix,
  #   range_shape1 = range_shape1,
  #   range_shape2 = range_shape2,
  #   parametric = parametric,
  #   control = control
  # )
  # x <- value
  # if(!hc) {
  #   x <- x / rescale
  # }
  # cis <- cis_estimates(estimates, what, level = level, x = x)
  # hcp <- ci_hcp(cis, estimates = estimates, value = value, dist = dist, 
  #               est = est, rescale = rescale, nboot = nboot, hc = hc)
  # replace_min_pboot_na(hcp, min_pboot)
  
# level = level,
#  min_pboot = min_pboot,
  
  # 
  # need to bootstrap with ci = TRUE treating all as one including non-parametric.
  # draw from ssd_rmulti and then fit all...
}
