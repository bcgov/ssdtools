#    Copyright 2015 Province of British Columbia
#
#    Licensed under the Apache License, Version 2.0 (the "License");
#    you may not use this file except in compliance with the License.
#    You may obtain a copy of the License at
#
#       http://www.apache.org/licenses/LICENSE-2.0
#
#    Unless required by applicable law or agreed to in writing, software
#    distributed under the License is distributed on an "AS IS" BASIS,
#    WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
#    See the License for the specific language governing permissions and
#    limitations under the License.

add_starting_values <- function(dist, x) {
  if (!exists(paste0("s", dist$distr))) {
    return(dist)
  }
  
  start <- do.call(paste0("s", dist$distr), list(x = x))
  c(dist, start)
}

fit_dist_uncensored <- function(data, left, weight, dist) {
  x <- data[[left]]
  
  dist <- list(data = x, distr = dist, method = "mle")
  
  if (!is.null(weight)) {
    dist$weights <- data[[weight]]
  }
  
  dist <- add_starting_values(dist, x)
  do.call(fitdistrplus::fitdist, dist)
}

fit_dist_censored <- function(data, left, right, weight, dist) {
  x <- rowMeans(data[c(left, right)], na.rm = TRUE)
  
  censdata <- data.frame(left = data[[left]], right = data[[right]])
  dist <- list(censdata = censdata, distr = dist)
  
  if (!is.null(weight)) {
    dist$weights <- data[[weight]]
  }
  
  dist <- add_starting_values(dist, x)
  do.call(fitdistrplus::fitdistcens, dist)
}

remove_errors <- function(dist_fit, name, computable, silent) {
  if (!is.null(dist_fit$error)) {
    if (!silent) wrn("Distribution ", name, " failed to fit: ", dist_fit$error)
    return(NULL)
  }
  sd <- dist_fit$result$sd
  if (is.null(sd) || any(is.na(sd))) {
    if (!silent) wrn("Distribution ", name, " failed to compute standard errors (try rescaling the data or increasing the sample size).")
    if (computable) {
      return(NULL)
    }
  }
  dist_fit$result
}

ssd_fit_dist <- function(
  data, left = "Conc", right = left, weight = NULL, dist = "lnorm") {
  chk_s3_class(data, "data.frame")
  chk_gte(nrow(data), 6)
  chk_string(left)
  chk_string(right)
  
  if (!is.null(weight)) chk_string(weight)
  
  chk_superset(colnames(data), c(left, right, weight))
  chk_string(dist)
  
  if (left == right) {
    fit <- fit_dist_uncensored(data, left, weight, dist)
  } else {
    fit <- fit_dist_censored(data, left, right, weight, dist)
  }
  fit
}

#' Fit Distributions
#'
#' Fits one or more distributions to species sensitivity data.
#'
#' By default the 'burrIII2', 'gamma' and 'lnorm'
#' distributions are fitted to the data.

#' The ssd_fit_dists function has also been
#' tested with the 'burrIII3', 'gompertz', 'lgumbel', 'llogis', 'pareto'
#' and 'weibull' distributions.
#'
#' If weight specifies a column in the data frame with positive integers,
#' weighted estimation occurs.
#' However, currently only the resultant parameter estimates are available (via coef).
#'
#' If the `right` argument is different to the `left` argument then the data are considered to be censored.
#' It may be possible to use artificial censoring to improve the estimates in the extreme tails
#' (Liu et al 2018).
#' @inheritParams params
#' @return An object of class fitdists (a list of \code{\link[fitdistrplus]{fitdist}} objects).
#'
#' @export
#' @references
#' Liu, Y., Salibián-Barrera, M., Zamar, R.H., and Zidek, J.V. 2018. Using artificial censoring to improve extreme tail quantile estimates. Journal of the Royal Statistical Society: Series C (Applied Statistics).
#'
#' @examples
#' ssd_fit_dists(boron_data)
#' data(fluazinam, package = "fitdistrplus")
#' ssd_fit_dists(fluazinam, left = "left", right = "right")
ssd_fit_dists <- function(
  data, left = "Conc", right = left, weight = NULL,
  dists = c("burrIII2", "gamma", "lnorm"),
  computable = TRUE,
  silent = FALSE) {
  chk_s3_class(dists, "character")
  chk_unique(dists)
  chk_gt(length(dists))
  chk_flag(computable)
  chk_flag(silent)

  if(sum(c("llog", "burrIII2", "llogis") %in% dists) > 1) {
    err("Distributions 'llog', 'burrIII2' and 'llogis' are identical. Please just use 'llogis'.")
  }
  
  if("llog" %in% dists) {
    .Deprecated("'llogis'", msg = "Distribution 'llog' has been deprecated for 'llogis'. Please use 'llogis'.")
  }
  if("burrIII2" %in% dists) {
    .Deprecated("'burrIII2'", msg = "Distribution 'burrIII2' has been deprecated for 'llogis'. Please use 'llogis'.")
  }
  
  safe_fit_dist <- safely(ssd_fit_dist)
  names(dists) <- dists
  dists <- lapply(dists, safe_fit_dist, data = data, left = left, right = right, weight = weight)
  dists <- mapply(remove_errors, dists, names(dists),
                  MoreArgs = list(computable = computable, silent = silent), SIMPLIFY = FALSE
  )
  dists <- dists[!vapply(dists, is.null, TRUE)]
  if (!length(dists)) err("All distributions failed to fit.")
  if (left == right) {
    class(dists) <- "fitdists"
  } else {
    class(dists) <- c("fitdistscens", "fitdists")
  }
  dists
}
