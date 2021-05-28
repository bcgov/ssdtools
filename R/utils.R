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

#' Comma and Significance Formatter
#' 
#' By default the numeric vectors are first rounded to three significant figures.
#' Then scales::comma is only applied to values greater than or equal to 1000
#' to ensure that labels are permitted to have different numbers of decimal places.
#'
#' @param x A numeric vector to format.
#' @param digits A whole number specifying the number of significant figures
#' @param ... Additional arguments passed to [scales::comma].
#'
#' @return A character vector.
#' @export
#'
#' @examples
#' comma_signif(c(0.1, 1, 10, 1000))
#' scales::comma(c(0.1, 1, 10, 1000))
comma_signif <- function(x, digits = 3, ...) {
  if(vld_used(...)) {
    deprecate_soft("0.3.3", "comma_signif(...)")
  }

  x <- signif(x, digits = digits)
  y <- as.character(x)
  bol <- !is.na(x) & as.numeric(x) >= 1000
  y[bol] <- comma(x[bol], ...)
  y
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

is_bounds <- function(dist) {
  fun <- paste0("b", dist)
  exists(fun, mode = "function")
}

bind_rows <- function(x) {
  x <- do.call("rbind", x)
  as_tibble(x)
}
