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

#' Theme Element for Hazard Concentration Axis Labels
#'
#' A [ggplot2::element_text()] that draws multi-line labels in bold.
#' It is required to make the hazard concentration label produced by
#' [ssd_label_comma_hc()] bold.
#'
#' @param ... Arguments passed to [ggplot2::element_text()].
#'
#' @return An object of class `element_text_hc`.
#' @seealso [ssd_label_comma_hc()]
#' @export
#'
#' @examples
#' ggplot2::ggplot(data = ssddata::anon_e, ggplot2::aes(x = Conc / 10)) +
#'   geom_ssdpoint() +
#'   ggplot2::scale_x_log10(labels = ssd_label_comma_hc(1.26)) +
#'   ggplot2::theme(axis.text.x = ssd_element_text_hc())
ssd_element_text_hc <- function(...) {
  element <- ggplot2::element_text(...)
  class(element) <- c("element_text_hc", class(element))
  element
}

#' @exportS3Method ggplot2::element_grob
element_grob.element_text_hc <- function(
  element,
  label = "",
  face = NULL,
  ...
) {
  face <- ifelse(grepl("\n", label, fixed = TRUE), "bold", "plain")
  class(element) <- setdiff(class(element), "element_text_hc")
  ggplot2::element_grob(element, label = label, face = face, ...)
}
