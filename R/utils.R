# Copyright 2023 Province of British Columbia
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
#' @param ... Additional arguments passed to [scales::comma].
#' @inheritParams params
#' @return A character vector.
#' @export
#' @examples
#' comma_signif(c(0.1, 1, 10, 1000))
#' scales::comma(c(0.1, 1, 10, 1000))
comma_signif <- function(x, digits = 3, ...) {
  if (vld_used(...)) {
    lifecycle::deprecate_warn("0.3.3", "comma_signif(...)")
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

#' Empirical Cumulative Density for Species Sensitivity Data
#'
#' @inheritParams params
#' @return A numeric vector of the empirical cumulative density for the rows
#' in data.
#' @seealso [`ssd_ecd()`] and [`ssd_data()`]
#' @export
#'
#' @examples
#' ssd_ecd_data(ssddata::ccme_boron)
ssd_ecd_data <- function(
    data, left = "Conc", right = left, bounds = c(left = 1, right = 1)) {
  .chk_data(data, left, right)
  .chk_bounds(bounds)

  if (!nrow(data)) {
    return(double(0))
  }

  data <- process_data(data, left = left, right = right)
  data <- bound_data(data, bounds)
  x <- rowMeans(log(data[c("left", "right")]))
  ssd_ecd(x)
}

#' Sort Species Sensitivity Data
#'
#' Sorts Species Sensitivity Data by empirical cumulative density (ECD).
#'
#' Useful for sorting data before using [geom_ssdpoint()] and [geom_ssdsegment()]
#' to construct plots for censored data with `stat = identity` to
#' ensure order is the same for the various components.
#'
#' @inheritParams params
#'
#' @return data sorted by the empirical cumulative density.
#' @seealso [`ssd_ecd_data()`] and [`ssd_data()`]
#' @export
#'
#' @examples
#' ssd_sort_data(ssddata::ccme_boron)
ssd_sort_data <- function(data, left = "Conc", right = left) {
  ecd <- ssd_ecd_data(data, left = left, right = right)
  data[order(ecd), , drop = FALSE]
}
