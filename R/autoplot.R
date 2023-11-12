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

#' @export
ggplot2::autoplot

#' Plot a fitdists Object
#'
#' A wrapper on [`ssd_plot_cdf()`].
#'
#' @inheritParams params
#' @return A ggplot object.
#' @seealso [`ssd_plot_cdf()`]
#' @export
#' @examples
#' fits <- ssd_fit_dists(ssddata::ccme_boron)
#' autoplot(fits)
autoplot.fitdists <- function(object, ...) {
  ssd_plot_cdf(object, ...)
}
