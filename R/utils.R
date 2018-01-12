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
}

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
  ns <- map_int(object, nobs)
  if(!all(ns == ns[1]))
    stop("the fitdists must have the same number of observations", call. = FALSE)
  names(ns) <- NULL
  ns[1]
}

#' Get the Number of Parameters
#'
#' @param x The object.
#' @param ... Unused.
#'
#' @return A count indicating the number of parameters.
#' @export
#' @examples
#' npars(boron_lnorm)
#' npars(boron_dists)
npars <- function(x, ...) {
  UseMethod("npars")
}

#' @export
npars.fitdist <- function(x, ...) length(x$estimate)

#' @export
npars.fitdists <- function(x, ...) map_int(x, npars)

comma_signif <- function(x, digits = 1, ...) {
  x %<>% signif(digits = digits)
  scales::comma(x, ...)
}

# Name ggplot grid object
# Convenience function to name grid objects
#
# @keyword internal
ggname <- function(prefix, grob) {
  grob$name <- grobName(grob, prefix)
  grob
}

#' @export
print.fitdists <- function(x, ...) {
  walk(x, print)
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
