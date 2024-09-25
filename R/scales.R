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
ssd_label_comma <- function(digits = 3, ..., big.mark = ",") {
  chk_number(digits)
  chk_string(big.mark)
  chk_unused(...)
  
  function(x) {
    x <- signif(x, digits = digits)
    y <- as.character(x)
    bol <- !is.na(x) & as.numeric(x) >= 1000
    y[bol] <- stringr::str_replace_all(y[bol], "(\\d{1,1})(\\d{3,3}(?<=\\.|$))", paste0("\\1", big.mark, "\\2"))
    y
  }
}
