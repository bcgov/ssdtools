#    Copyright 2015 Province of British Columbia
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
  capture.output(x <- do.call(fitdistrplus::fitdist, dist))
  x
}

fit_dist_censored <- function(data, left, right, weight, dist) {
  x <- rowMeans(data[c(left, right)], na.rm = TRUE)

  censdata <- data.frame(left = data[[left]], right = data[[right]])
  dist <- list(censdata = censdata, distr = dist)

  if (!is.null(weight)) {
    dist$weights <- data[[weight]]
  }

  dist <- add_starting_values(dist, x)
  capture.output(x <- do.call(fitdistrplus::fitdistcens, dist))
  x
}

remove_errors <- function(dist_fit, name, computable, silent) {
  if (!is.null(dist_fit$error)) {
    if (!silent) wrn("Distribution ", name, " failed to fit: ", dist_fit$error)
    return(NULL)
  }
  sd <- dist_fit$result$sd
  if (is.null(sd) || any(is.na(sd))) {
    if (computable) {
      if (!silent) wrn("Distribution ", name, " failed to compute standard errors (try rescaling the data or increasing the sample size).")
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
#' By default the 'llogis', 'gamma' and 'lnorm'
#' distributions are fitted to the data.

#' The ssd_fit_dists function has also been
#' tested with the 'gompertz', 'lgumbel' and 'weibull' distributions.
#'
#' If weight specifies a column in the data frame with positive integers,
#' weighted estimation occurs.
#' However, currently only the resultant parameter estimates are available (via coef).
#'
#' If the `right` argument is different to the `left` argument then the data are considered to be censored.
#'
#' The fits are performed using [fitdistrplus::fitdist()]
#' (and [fitdistrplus::fitdistcens()] in the case of censored data).
#' The method used is "mle" (maximum likelihood estimation)
#' which means that numerical optimization is carried out in
#' [fitdistrplus::mledist()] using [stats::optim()]
#' unless finite bounds are supplied in the (lower and upper) in which
#' it is carried out using [stats::constrOptim()].
#' In both cases the "Nelder-Mead" method is used.
#'
#' @inheritParams params
#' @return An object of class fitdists (a list of [fitdistrplus::fitdist()] objects).
#'
#' @export
#' @examples
#' ssd_fit_dists(boron_data)
#' data(fluazinam, package = "fitdistrplus")
#' ssd_fit_dists(fluazinam, left = "left", right = "right")
ssd_fit_dists <- function(
                          data, left = "Conc", right = left, weight = NULL,
                          dists = c("llogis", "gamma", "lnorm"),
                          computable = FALSE,
                          silent = FALSE) {
  chk_s3_class(dists, "character")
  chk_unique(dists)
  chk_gt(length(dists))
  chk_flag(computable)
  chk_flag(silent)

  if (sum(c("llog", "burrIII2", "llogis") %in% dists) > 1) {
    err("Distributions 'llog', 'burrIII2' and 'llogis' are identical. Please just use 'llogis'.")
  }

  if ("llog" %in% dists) {
    deprecate_soft("0.1.0", "dllog()", "dllogis()", id = "xllog", 
                   details = "The 'llog' distribution has been deprecated for the identical 'llogis' distribution.")
  }
  if ("burrIII2" %in% dists) {
    deprecate_soft("0.1.2", "xburrIII2()",
                   details = "The 'burrIII2' distribution has been deprecated for the identical 'llogis' distribution.", id = "xburrIII2")
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
