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

#' Fit Distribution
#'
#' @param x A numeric vector of the data.
#' @param dist A string of the distribution to fit.
#'
#' @return An object of class fitdist.
fit_dist_internal <- function(x, dist = "lnorm") {
  check_vector(x, 1)
  check_string(dist)

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

#' Fit Distribution
#'
#' @param x A numeric vector of the data.
#' @param dist A string of the distribution to fit.
#'
#' @return An object of class fitdist.
#' @export
#'
#' @examples
#' ssd_fit_dist(ccme_data$Concentration[ccme_data$Chemical == "Boron"])
ssd_fit_dist <- function(x, dist = "lnorm") {
  fit_dist_internal(x, dist)
}

remove_errors <- function(dist_fit, name, silent) {
  if(!is.null(dist_fit$error)) {
    if(!silent) warning(name, ": ", dist_fit$error, call. = FALSE)
    return(NULL)
  }
  dist_fit$result
}

#' Fit Distributions
#'
#' By default fits xx distributions.
#'
#' @param x A numeric vector of the data.
#' @param dists A character vector of the distributions to fit.
#' @param silent A flag indicating whether fits should fail without issuing errors.
#' @return An object of class fitdists.
#'
#' @export
#' @examples
#' ssd_fit_dists(ccme_data$Concentration[ccme_data$Chemical == "Boron"])
ssd_fit_dists <- function(x, dists = c("lnorm", "llog", "gompertz", "lgumbel", "gamma", "weibull"), silent = FALSE) {
  check_vector(x, 1)
  check_dists(dists)

  safe_fit_dist <- safely(ssd_fit_dist)
  names(dists) <- dists
  dists %<>% map(safe_fit_dist, x = x)
  dists %<>% imap(remove_errors, silent = silent)
  dists <- dists[!vapply(dists, is.null, TRUE)]
  class(dists) <- "fitdists"
  dists
}

