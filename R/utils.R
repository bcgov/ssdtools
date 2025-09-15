# Copyright 2015-2023 Province of British Columbia
# Copyright 2021 Environment and Climate Change Canada
# Copyright 2023-2024 Australian Government Department of Climate Change,
# Energy, the Environment and Water
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
#' `r lifecycle::badge("deprecated")`
#'
#' Deprecated for `ssd_label_comma()`
#'
#' @param x A numeric vector to format.
#' @inheritParams params
#' @return A character vector.
#' @seealso [ssd_label_comma()]
#' @keywords internal
#' @export
#' @examples
#' \dontrun{
#' comma_signif(c(0.1, 1, 10, 1000, 10000))
#' }
comma_signif <- function(x, digits = 3, ..., big.mark = ",") {
  lifecycle::deprecate_soft(
    "2.0.0", "comma_signif()", "ssd_label_comma()",
    details = "Use `labels = ssd_label_comma()` instead of `labels = comma_signif` when constructing `ggplot` objects."
  )

  chk_numeric(x)
  chk_number(digits)
  chk_string(big.mark)
  chk_unused(...)

  x <- signif(x, digits = digits)
  y <- as.character(x)
  bol <- !is.na(x) & as.numeric(x) >= 1000
  y[bol] <- stringr::str_replace_all(y[bol], "(\\d{1,1})(\\d{3,3}(?<=\\.|$))", paste0("\\1", big.mark, "\\2"))
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
  if (!missing(ties.method)) {
    lifecycle::deprecate_warn("2.3.0", "ssd_ecd(ties.method)")
  }
  chk_numeric(x)
  if (!length(x)) return(numeric())
  if (length(x) == 1L) return(0.5)
  if (anyNA(x)) return(rep(NA_real_, length(x)))
  rank <- rank(x, ties.method = "first")
  stats::ppoints(length(x))[rank]
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
    data, left = "Conc", right = left, ..., bounds = c(left = 1, right = 1)) {
  .chk_data(data, left, right)
  .chk_bounds(bounds)
  chk_unused(...)

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
