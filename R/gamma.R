#    Copyright 2015 Province of British Columbia
#
#    Licensed under the Apache License, Version 2.0 (the "License");
#    you may not use this file except in compliance with the License.
#    You may obtain a copy of the License at
#
#       http://www.apache.org/licenses/LICENSE-2.0
#
#    Unless required by applicable law or agreed to in writing, software
#    distributed under the License is distributed on an "AS IS" BASIS,
#    WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
#    See the License for the specific language governing permissions and
#    limitations under the License.

#' Gamma Distribution
#'
#' Starting values for the
#' Gamma distribution.
#'
#' @param x A numeric vector of values.
#' @return A numeric vector.
#' @seealso \code{\link[stats]{dgamma}}
#' @name gamma
#' @examples
#' x <- seq(0.01, 5, by = 0.01)
#' plot(x, dgamma(x, 1, 1), type = "l")
NULL

#' @rdname gamma
#' @export
sgamma <- function(x) {
  list(start = list(
    scale = var(x, na.rm = TRUE) / mean(x, na.rm = TRUE),
    shape = mean(x, na.rm = TRUE)^2 / var(x, na.rm = TRUE)
  ))
}
