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

#' @describeIn ssd_p Cumulative Distribution Function for Multiple Distributions
#' @export
#' @examples
#' 
#' # multi 
#' ssd_pmulti(1)
ssd_pmulti <- function(q, wt_est = ssd_emulti(), lower.tail = TRUE, log.p = FALSE) {
  chk_atomic(q)
  chk_vector(q)
  
  check_wt_est(wt_est)
  chk_flag(lower.tail)
  chk_flag(log.p)
  
  if (!length(q)) {
    return(numeric(0))
  }
  
  q <- as.numeric(q)
  
  f <- ma_fun(wt_est, fun = "p")
  p <- rep(NA_real_, length(q))
  for(i in seq_along(p)) {
    p[i] <- f(q[i], p = 0)
  }
  if(!lower.tail) {
    p <- 1 - p
  }
  if(log.p) {
    p <- log(p)
  }
  p
}

#' @describeIn ssd_q Quantile Function for Multiple Distributions
#' @export
#' @examples
#' 
#' # multi 
#' ssd_qmulti(0.5)
ssd_qmulti <- function(p, wt_est = ssd_emulti(), lower.tail = TRUE, log.p = FALSE) {
  chk_atomic(p)
  chk_vector(p)
  
  check_wt_est(wt_est)
  chk_flag(lower.tail)
  chk_flag(log.p)
  
  if (!length(p)) {
    return(numeric(0))
  }
  
  p <- as.numeric(p)
  
  if(log.p) {
    p <- exp(p)
  }
  if(!lower.tail) {
    p <- 1 - p
  }
  
  ranges <- range_fun(p, wt_est, fun = "q")
  lower <- ranges$lower
  upper <- ranges$upper
  
  f <- ma_fun(wt_est, fun = "p")
  q <- rep(NA_real_, length(p))
  for(i in seq_along(p)) {
    if(is.na(lower[i]) || lower[i] == upper[i]) {
      q[i] <- lower[i]
    } else {
      q[i] <- uniroot(f = f, p = p[i], lower = lower[i], upper = upper[i])$root
    }
  }
  q
}

#' @describeIn ssd_r Random Generation for Multiple Distributions
#' @export
#' @examples
#' 
#' # multi 
#' set.seed(50)
#' hist(ssd_rmulti(1000), breaks = 100)
ssd_rmulti <- function(n, wt_est = ssd_emulti()) {
  chk_vector(n)
  if(!length(n)) {
    return(numeric(0))
  }
  if(length(n) > 1) {
    n <- length(n)
  }
  chk_count(n)
  if(n == 0L) return(numeric(0))
  p <- runif(n)
  ssd_qmulti(p, wt_est)
}

#' @describeIn ssd_e Default Parameter Values for Multiple Distributions
#' @inheritParams params
#' @export
#' @examples
#'
#' ssd_emulti()
ssd_emulti <- function(dists = ssd_dists(bcanz = TRUE)) {
  chk_character(dists)
  chk_not_any_na(dists)
  chk_subset(dists, ssd_dists())
  check_dim(dists)
  
  edists <- paste0("ssd_e", dists, ("()"))
  es <- purrr::map(edists, function(x) eval(parse(text = x)))
  names(es) <- dists
  des <- purrr::imap(es, function(x, y) {
    tibble::tibble(dist = y, term = names(x), est = x)
  })
  das <- dplyr::bind_rows(des)
  nas <- tidyr::nest(das, .by = "dist")
  was <- dplyr::mutate(nas, weight = 1/nrow(nas))
  sas <- dplyr::select(was, "dist", "weight", "data")
  sas
}
