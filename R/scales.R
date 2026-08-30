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

#' Label numbers with significant digits and comma
#'
#' @inheritParams params
#'
#' @return A "labelling" function that takes a vector x and
#' returns a character vector of `length(x)` giving a label for each input value.
#' @seealso [scales::label_comma()]
#' @export
#'
#' @examples
#' ggplot2::ggplot(data = ssddata::anon_e, ggplot2::aes(x = Conc / 10)) +
#'   geom_ssdpoint() +
#'   ggplot2::scale_x_log10(labels = ssd_label_comma())
ssd_label_comma <- function(
  digits = 3,
  ...,
  big.mark = ",",
  decimal.mark = getOption("OutDec", ".")
) {
  chk_unused(...)
  chk_number(digits)
  chk_string(big.mark)
  chk_string(decimal.mark)

  function(x) {
    x <- signif(x, digits = digits)
    y <- prettyNum(x, big.mark = big.mark, decimal.mark = decimal.mark)
    y
  }
}

#' Label numbers with significant digits and comma.
#' If `hc_value` is present in breaks, put on new line and make bold.
#'
#' @inheritParams params
#'
#' @return A "labelling" function that takes a vector x and
#' returns a character vector of `length(x)` giving a label for each input value.
#' The label for `hc_value` is prefixed with a newline so that it is drawn
#' on its own line, and bold by [ssd_element_text_hc()].
#' @seealso [scales::label_comma()] and [ssd_element_text_hc()]
#' @export
#'
#' @examples
#' ggplot2::ggplot(data = ssddata::anon_e, ggplot2::aes(x = Conc / 10)) +
#'   geom_ssdpoint() +
#'   ggplot2::scale_x_log10(labels = ssd_label_comma_hc(1.26)) +
#'   ggplot2::theme(axis.text.x = ssd_element_text_hc())
ssd_label_comma_hc <- function(
  hc_value,
  digits = 3,
  ...,
  big.mark = ",",
  decimal.mark = getOption("OutDec", ".")
) {
  chk_unused(...)
  chk_number(hc_value)

  function(x) {
    label_fun <- ssd_label_comma(
      digits = digits,
      big.mark = big.mark,
      decimal.mark = decimal.mark
    )
    hc_label <- label_fun(hc_value)
    purrr::map_chr(
      label_fun(x),
      ~ {
        if (is.na(.x) || .x != hc_label) {
          return(.x)
        }
        paste0("\n", .x)
      }
    )
  }
}
