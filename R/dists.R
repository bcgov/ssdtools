#    Copyright 2015 Province of British Columbia
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

#' Distributions
#' 
#' Implemented Distributions
#'
#' @return A character vector of the implemented distributions
#' @export
#'
#' @examples
#' ssd_dists()
ssd_dists <- function() {
  c("burrIII3", "gamma", "gompertz", "lgumbel", 
    "llogis", "lnorm", "mx_llogis_llogis", "weibull")
}
