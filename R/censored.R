# Copyright 2023 Environment and Climate Change Canada
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
#
#' Is Censored
#'
#' Tests if an object has censored data.
#'
#' @inheritParams params
#' @return A flag indicating whether an object is censored.
#' @export
ssd_is_censored <- function(x, ...) {
  UseMethod("ssd_is_censored")
}

#' @description Test if a data frame is censored.
#' @inheritParams params
#' @rdname ssd_is_censored
#' @export
#' @examples
#'
#' ssd_is_censored(ssddata::ccme_boron)
#' ssd_is_censored(data.frame(Conc = 1, right = 2), right = "right")
ssd_is_censored.data.frame <- function(x, left = "Conc", right = left, ...) {
  chk_unused(...)
  .chk_data(x, left, right, weight = NULL, nrow = 0L)

  if (!nrow(x)) {
    return(NA)
  }
  data <- process_data(x, left, right, weight = NULL)
  .is_censored(censoring(data))
}

#' @description Test if a fitdists object is censored.
#' @inheritParams params
#' @rdname ssd_is_censored
#' @export
#' @examples
#'
#' fits <- ssd_fit_dists(ssddata::ccme_boron)
#' ssd_is_censored(fits)
ssd_is_censored.fitdists <- function(x, ...) {
  chk_unused(...)
  .is_censored(.censoring_fitdists(x))
}
