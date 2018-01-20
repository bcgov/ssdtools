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
  }
  dist
}

fit_dist_uncensored <- function(data, left, weight, dist) {

  x <- data[[left]]

  dist %<>% list(data = x, distr = ., method = "mle")

  if(!is.null(weight))
    dist$weights <- data[[weight]]

  dist %<>% add_starting_values(x)
  do.call(fitdistrplus::fitdist, dist)
}

fit_dist_censored <- function(data, left, right, weight, dist) {

  if(dist == "burr")
    stop("distribution fitting not defined for censored data with the burr distribution because it requires moment matching estimation", call. = FALSE)

  x <- rowMeans(data[c(left, right)], na.rm = TRUE)

  censdata <- data.frame(left = data[[left]], right = data[[right]])
  dist %<>% list(censdata = censdata, distr = .)

  if(!is.null(weight))
    dist$weights <- data[[weight]]

  dist %<>% add_starting_values(x)
  do.call(fitdistrplus::fitdistcens, dist)
}

remove_errors <- function(dist_fit, name, silent) {
  if(!is.null(dist_fit$error)) {
    if(!silent) warning(name, ": ", dist_fit$error, call. = FALSE)
    return(NULL)
  }
  dist_fit$result
}

#' Fit Distribution
#'
#' Fits a distribution to species sensitivity data.
#'
#' @inheritParams ssd_fit_dists
#' @param dist A string of the distribution to fit.
#'
#' @return An object of class \code{\link[fitdistrplus]{fitdist}}.
#' @seealso \code{\link{ssd_fit_dists}}
#' @export
#'
#' @examples
#' ssd_fit_dist(boron_data)
#' data(fluazinam)
#' ssd_fit_dist(fluazinam, left = "left", right = "right")
ssd_fit_dist <- function(
  data, left = "Conc", right = left, weight = NULL, dist = "lnorm") {

  check_data(data, nrow = c(1, .Machine$integer.max))
  check_string(left)
  check_string(right)

  checkor(check_null(weight), check_string(weight))

  check_colnames(data, unique(c(left, right, weight)))
  check_string(dist)

  if(left == right) {
    fit <-  fit_dist_uncensored(data, left, weight, dist)
  } else
    fit <-  fit_dist_censored(data, left, right, weight, dist)
  fit
}

#' Fit Distributions
#'
#' Fits one or more distributions to species sensitivity data.
#'
#' By default the 'lnorm', 'llog', 'gompertz', 'lgumbel', 'gamma' and 'weibull'
#' distributions are fitted to the data.
#' The ssd_fit_dist and \code{\link{ssd_fit_dist}} functions have also been
#' tested with the 'burr' and 'pareto' distributions.
#'
#' If weight specifies a column in the data frame with positive integers,
#' weighted estimation occurs.
#' However, currently only the resultant parameter estimates are available (via coef).
#'
#' @param data A data frame.
#' @param left A string of the column in data with the left concentration values.
#' @param right A string of the column in data with the right concentration values.
#' @param weight A string of the column in data with the weightings (or NULL)
#' @param dists A character vector of the distributions to fit.
#' @param silent A flag indicating whether fits should fail silently.
#' @return An object of class fitdists (a list of \code{\link[fitdistrplus]{fitdist}} objects).
#'
#' @export
#' @seealso \code{\link{ssd_fit_dist}}
#' @examples
#' ssd_fit_dists(boron_data)
#' data(fluazinam)
#' ssd_fit_dists(fluazinam, left = "left", right = "right")
ssd_fit_dists <- function(
  data, left = "Conc", right = left, weight = NULL,
  dists = c("lnorm", "llog", "gompertz", "lgumbel", "gamma", "weibull"),
  silent = FALSE
) {
  check_vector(dists, length = c(1,.Machine$integer.max), unique = TRUE, named = FALSE)
  check_flag(silent)

  safe_fit_dist <- safely(ssd_fit_dist)
  names(dists) <- dists
  dists %<>% map(safe_fit_dist, data = data, left = left, right = right, weight = weight)
  dists %<>% imap(remove_errors, silent = silent)
  dists <- dists[!vapply(dists, is.null, TRUE)]
  if(left == right) {
    class(dists) <- "fitdists"
  } else
    class(dists) <- c("fitdistscens", "fitdists")
  dists
}
