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

is.tmbfit <- function(x) {
  inherits(x, "tmbfit")
}

#' Is fitdists Object
#'
#' Tests whether x is a fitdists Object.
#' @inheritParams params
#'
#' @return A flag specifying whether x is a fitdists Object.
#' @export
#'
#' @examples
#' fits <- ssd_fit_dists(ssddata::ccme_boron)
#' is.fitdists(fits)
is.fitdists <- function(x) {
  inherits(x, "fitdists")
}
