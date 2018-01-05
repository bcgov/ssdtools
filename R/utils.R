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
