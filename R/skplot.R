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

#' Plot Skewness-Kurtosis Graph
#'
#' Plots a skewness-kurtosis graph similar to the one proposed by Cullen and Frey with 100 bootstrapped values.
#' @param x A numeric vector.
#' @return An invisible TRUE.
#' @seealso \code{\link[fitdistrplus]{descdist}}
#' @export
#'
#' @examples
#' ssd_skplot(ccme_data$Conc[ccme_data$Chemical == "Cadmium"])
ssd_skplot <- function(x) {
  check_vector(x, 1, length = c(2,Inf))
  x %<>% fitdistrplus::descdist(boot=100L)
  invisible(TRUE)
}
