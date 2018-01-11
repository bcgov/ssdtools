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

check_dists <- function(x, x_name = substitute(x)) {
  x_name %<>% deparse()
  check_vector(x, ssd_dists(all = TRUE), length = c(1,length(ssd_dists(all = TRUE))),
               unique = TRUE, named = FALSE)
}

#' Get the Number of Parameters
#'
#' @param object The object.
#' @param ... Unused.
#'
#' @return A count indicating the number of parameters.
#' @export
#' @examples
#' npars(boron_lnorm)
npars <- function(object, ...) {
  UseMethod("npars")
}

#' @export
npars.fitdist <- function(object, ...) length(object$estimate)

is_fitdist <- function(x) inherits(x, "fitdist")

is_fitdists <- function(x) inherits(x, "fitdists")

#' Number of Observations
#'
#' @param object The object.
#' @param ... Unused.
#' @export
#' @examples
#' nobs(boron_lnorm)
nobs.fitdist <- function(object, ...) object$n

#' @export
nobs.fitdists <- function(object, ...) {
  ns <- vapply(object, nobs, 1L)
  if(!all(ns == ns[1]))
    stop("the fitdists must have the same number of observations", call. = FALSE)
  ns[1]
}

comma_signif <- function(x, digits = 1, ...) {
  x %<>% signif(digits = digits)
  scales::comma(x, ...)
}

#' Empirical Cumulative Density
#'
#' @inheritParams base::rank
#' @return A numeric vector of the empirical cumulative density.
#' @export
#'
#' @examples
#' ssd_ecd(1:10)
ssd_ecd <- function(x, ties.method = "first") {
  (rank(x, ties.method = ties.method) - 0.5) / length(x)
}

#' Distribution Names
#'
#' Returns a sorted character vector of the recognized distribution names.
#'
#' @param all A flag indicating whether to return all the distribution names.
#' @return A sorted character vector of the distribution names.
#' @export
#'
#' @examples
#' ssd_dists()
#' ssd_dists(all = TRUE)
ssd_dists <- function(all = FALSE) {
  check_flag(all)
  if(!all) {
    return(c("gamma", "gompertz", "lgumbel",
             "llog", "lnorm", "weibull"))
  }
  return(c("burr", "gamma", "gompertz", "lgumbel",
           "llog", "lnorm", "pareto", "weibull"))
}

#' @export
print.fitdists <- function(x, ...) {
  walk(x, print)
}

