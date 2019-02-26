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


#' Is fitdist
#'
#' Tests whether an object is a fitdist.
#' @param x The object to test.
#'
#' @return A flag.
#' @export
#'
#' @examples
#' is.fitdist(boron_lnorm)
#' is.fitdist(boron_dists)
#' is.fitdist(boron_dists[["lnorm"]])
is.fitdist <- function(x) {
  inherits(x, "fitdist")
}

#' Is censored fitdist
#'
#' Tests whether an object is a censored fitdist.
#' @param x The object to test.
#'
#' @return A flag.
#' @export
#'
#' @examples
#' is.fitdistcens(boron_lnorm)
#' is.fitdistcens(fluazinam_lnorm)
is.fitdistcens <- function(x) {
  inherits(x, "fitdistcens")
}

#' Is fitdists
#'
#' Tests whether an object is a fitdists.
#' @param x The object to test.
#'
#' @return A flag.
#' @export
#'
#' @examples
#' is.fitdists(boron_lnorm)
#' is.fitdists(boron_dists)
is.fitdists <- function(x) {
  inherits(x, "fitdists") & !is.fitdistcens(x)
}

#' Is censored fitdists
#'
#' Tests whether an object is a censored fitdists.
#' @param x The object to test.
#'
#' @return A flag.
#' @export
#'
#' @examples
#' is.fitdistscens(boron_dists)
#' is.fitdistscens(fluazinam_lnorm)
#' is.fitdistscens(fluazinam_dists)
is.fitdistscens <- function(x) {
  inherits(x, "fitdistscens")
}

#' Number of Observations
#'
#' @param object The object.
#' @param ... Unused.
#' @export
#' @examples
#' stats::nobs(boron_lnorm)
nobs.fitdist <- function(object, ...) object$n

#' Number of Observations
#'
#' @param object The object.
#' @param ... Unused.
#' @export
#' @examples
#' stats::nobs(boron_lnorm)
nobs.fitdistcens <- function(object, ...) nrow(object$censdata)

#' @export
nobs.fitdists <- function(object, ...) {
  ns <- vapply(object, stats::nobs, 1L)
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

#' @describeIn npars Get the Number of parameters
#' @export
npars.fitdist <- function(x, ...) length(x$estimate)

#' @describeIn npars Get the Number of parameters
#' @export
npars.fitdistcens <- function(x, ...) length(x$estimate)

#' @describeIn npars Get the Number of parameters
#' @export
npars.fitdists <- function(x, ...) vapply(x, npars, 1L)

#' Comma and Significance Formatter
#'
#' @inheritParams scales::comma
#' @inheritParams base::signif
#'
#' @return A function that returns a character vector.
#' @seealso \code{\link[scales]{comma}}
#' @export
#'
#' @examples
#' comma_signif(1199)
comma_signif <- function(x, digits = 1, ...) {
  x <- signif(x, digits = digits)
  y <- as.character(x)
  bol <- !is.na(x) & as.numeric(x) >= 1
  y[bol] <- scales::comma(x[bol], ...)
  y
}

ggname <- function(prefix, grob) {
  grob$name <- grid::grobName(grob, prefix)
  grob
}

#' @export
print.fitdists <- function(x, ...) {
  lapply(x, print)
  invisible(x)
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
