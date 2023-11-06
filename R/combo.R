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

#' @describeIn ssd_p Cumulative Distribution Function for 
#' Weighted Combination of Distributions
#' @export
ssd_pcombo <- function(q, wt_est, lower.tail = TRUE, log.p = FALSE) {
  chk_numeric(q)
  chk_vector(q)

  check_wt_est(wt_est)
  chk_flag(lower.tail)
  chk_flag(log.p)
  
  if (!length(q)) {
    return(numeric(0))
  }

  f <- ma_fun(wt_est, fun = "q")
  root <- uniroot(f = f, q = q, lower = 0, upper = 1)$root
  root
}

#' @describeIn ssd_q Quantile Function for 
#' Weighted Combination of Distributions
#' @export
ssd_qcombo <- function(p, wt_est, lower.tail = TRUE, log.p = FALSE, upper_q = 1) {
  chk_numeric(p)
  chk_vector(p)

  check_wt_est(wt_est)
  chk_flag(lower.tail)
  chk_flag(log.p)
  
  if (!length(p)) {
    return(numeric(0))
  }

  f <- ma_fun(wt_est, fun = "p")
  root <- uniroot(f = f, p = p, lower = 0, upper = upper_q)$root
  root
}

#' @describeIn ssd_r Random Generation for 
#' Weighted Combination of Distributions
#' @export
ssd_rcombo <- function(n, wt_est, upper_q = 1) {
  chk_count(n)
  if(n == 0L) return(numeric(0))
  p <- runif(n)
  ssd_qcombo(p, wt_est, upper_q = upper_q)
}
