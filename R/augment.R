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
generics::augment

#' Augmented Data from fitdists Object
#'
#' Get a tibble of the original data with augmentation.
#'
#' @inheritParams params
#' @return A tibble of the agumented data.
#' @family generics
#' @seealso [`ssd_data()`]
#' @export
#' @examples
#' fits <- ssd_fit_dists(ssddata::ccme_boron)
#' augment(fits)
augment.fitdists <- function(x, ...) {
  .org_data_fitdists(x)
}
