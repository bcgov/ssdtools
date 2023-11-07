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
#' @examples
#' 
#' # multi 
#' fit <- ssd_fit_dists(data = ssddata::ccme_boron)
#' wt_est <- ssd_wt_est(fit)
#' ssd_pmulti(1, wt_est)
ssd_pmulti <- function(q, wt_est, lower.tail = TRUE, log.p = FALSE) {
  chk_numeric(q)
  chk_vector(q)

  check_wt_est(wt_est)
  chk_flag(lower.tail)
  chk_flag(log.p)
  
  if (!length(q)) {
    return(numeric(0))
  }

  f <- ma_fun(wt_est, fun = "q")
  p <- rep(NA_real_, length(q))
  # FIXME: vectorize
  # FIXME: deal with edge cases of negative and infinite q
  for(i in seq_along(p)) {
    p[i] <- uniroot(f = f, q = q[i], lower = 0, upper = 1)$root
  }
  if(!lower.tail) {
    p <- 1 - p
  }
  if(log.p) {
    p <- log(p)
  }
  p
}

#' @describeIn ssd_q Quantile Function for 
#' Weighted Combination of Distributions
#' @export
#' @examples
#' 
#' # multi 
#' fit <- ssd_fit_dists(data = ssddata::ccme_boron)
#' wt_est <- ssd_wt_est(fit)
#' ssd_qmulti(0.5, wt_est, upper_q = 100)
ssd_qmulti <- function(p, wt_est, lower.tail = TRUE, log.p = FALSE, upper_q = 1) {
  chk_numeric(p)
  chk_vector(p)

  check_wt_est(wt_est)
  chk_flag(lower.tail)
  chk_flag(log.p)
  
  chk_number(upper_q)
  
  if (!length(p)) {
    return(numeric(0))
  }

  if(log.p) {
    p <- exp(p)
  }
  if(!lower.tail) {
    p <- 1 - p
  }

  f <- ma_fun(wt_est, fun = "p")
  q <- rep(NA_real_, length(p))
  # FIXME: vectorize  
  # FIXME: deal with edge cases of negative and q >= 1
  for(i in seq_along(p)) {
    q[i] <- uniroot(f = f, p = p[i], lower = 0, upper = upper_q)$root
  }
  q
}

#' @describeIn ssd_r Random Generation for 
#' Weighted Combination of Distributions
#' @export
#' @examples
#' 
#' # multi 
#' fit <- ssd_fit_dists(data = ssddata::ccme_boron)
#' wt_est <- ssd_wt_est(fit)
#' set.seed(50)
#' hist(ssd_rmulti(1000, wt_est, upper_q = 1000), breaks = 100)
ssd_rmulti <- function(n, wt_est, upper_q = 1) {
  chk_count(n)
  if(n == 0L) return(numeric(0))
  p <- runif(n)
  ssd_qmulti(p, wt_est, upper_q = upper_q)
}
