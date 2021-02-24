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
#' @inheritParams params
#'
#' @return A flag.
#' @family is
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
#' @inheritParams params
#'
#' @return A flag.
#' @family is
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
#' @inheritParams params
#'
#' @return A flag.
#' @family is
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
#' @inheritParams params
#'
#' @return A flag.
#' @family is
#' @export
#'
#' @examples
#' is.fitdistscens(boron_dists)
#' is.fitdistscens(fluazinam_lnorm)
#' is.fitdistscens(fluazinam_dists)
is.fitdistscens <- function(x) {
  inherits(x, "fitdistscens")
}