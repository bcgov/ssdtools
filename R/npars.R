
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
#' npars(fluazinam_lnorm)
#' npars(fluazinam_dists)
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
