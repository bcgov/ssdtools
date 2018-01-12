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

remove_errors <- function(dist_fit, name, silent) {
  if(!is.null(dist_fit$error)) {
    if(!silent) warning(name, ": ", dist_fit$error, call. = FALSE)
    return(NULL)
  }
  dist_fit$result
}

#' Fit Distribution
#'
#' @param data A data frame.
#' @param left A string of the column in data with the left concentration values.
#' @param right A string of the column in data with the right concentration values.
#' @param weights A string of the column in data with the weightings (or NULL)
#' @param dist A string of the distribution to fit.
#'
#' @return An object of class fitdist.
#' @export
#'
#' @examples
#' ssd_fit_dist(boron_data)
ssd_fit_dist <- function(
  data, left = "Conc", right = left, weights = NULL, dist = "lnorm") {

  check_data(data, nrow = c(1, .Machine$integer.max))
  check_string(left)
  check_string(right)

  checkor(check_null(weights), check_string(weights))

  check_colnames(data, unique(c(left, right, weights)))
  check_string(dist)

  x <- data[[left]]

  dist %<>% list(data = x, distr = ., method = "mle")

  if(dist$distr == "burr"){
    dist$start <- list(shape1 = 4, shape2 = 1, rate = 1)
    dist$method <- "mme"
    dist$order <- 1:3
    dist$memp  <- function (x, order){ sum(x^order) }
  } else if(dist$dist == "gamma"){
    dist$start <- list(scale = var(x) / mean(x),
                       shape = mean(x)^2 / var(x)^2)
  } else if(dist$distr == "gompertz"){
    fit <- vglm(x~1, gompertz)
    dist$start <- list(shape = exp(unname(coef(fit)[2])),
                       scale = exp(unname(coef(fit)[1])) )
  } else if(dist$distr == "lgumbel"){
    dist$start <- list(location = mean(log(x)),
                       scale = pi*sd(log(x))/sqrt(6))
  } else if(dist$distr == "llog" ){
    dist$start <- list(shape = mean(log(x)), scale = pi*sd(log(x))/sqrt(3))
  } else if(dist$distr == "pareto"){
    fit <- vglm(x~1, paretoff)
    dist$start  <- list(shape = exp(unname(coef(fit))))
    dist$fix.arg<- list(scale = fit@extra$scale)
  } else if(dist$distr %in% c("lnorm", "weibull")){
  } else
    stop("distribution '", dist$distr, "' unrecognised", call. = FALSE)

  fit <- do.call(fitdistrplus::fitdist, dist)
  fit
}

#' Fit Distributions
#'
#' By default fits the "lnorm", "llog", "gompertz", "lgumbel", "gamma" and "weibull" distributions.
#'
#' @inheritParams ssd_fit_dist
#' @param dists A character vector of the distributions to fit.
#' @param silent A flag indicating whether fits should fail silently.
#' @return An object of class fitdists.
#'
#' @export
#' @examples
#' ssd_fit_dists(boron_data)
ssd_fit_dists <- function(
  data, left = "Conc", right = left, weights = NULL,
  dists = c("lnorm", "llog", "gompertz", "lgumbel", "gamma", "weibull"),
  silent = FALSE
) {
  check_data(data, nrow = c(1, .Machine$integer.max))
  check_string(left)
  check_string(right)

  checkor(check_null(weights), check_string(weights))

  check_colnames(data, unique(c(left, right, weights)))
  check_vector(dists, c("burr", "gamma", "gompertz", "lgumbel",
                        "llog", "lnorm", "pareto", "weibull"),
               length = c(1,8), unique = TRUE, named = FALSE)

  safe_fit_dist <- safely(ssd_fit_dist)
  names(dists) <- dists
  dists %<>% map(safe_fit_dist, data = data, left = left, right = right, weights = weights)
  dists %<>% imap(remove_errors, silent = silent)
  dists <- dists[!vapply(dists, is.null, TRUE)]
  class(dists) <- "fitdists"
  dists
}
