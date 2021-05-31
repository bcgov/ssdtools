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

#' Species Sensitivity Distributions
#' 
#' Gets a character vector of the names of implemented distributions.
#'
#' @param type A string specifying the distribution type.
#' Possible values are 'all', 'stable' and 'unstable'.
#' @return A unique, sorted character vector of the distributions.
#' @export
#'
#' @examples
#' ssd_dists()
#' ssd_dists("all")
ssd_dists <- function(type = "stable") {
  chk_string(type)
  chk_subset(type, c("all", "stable", "unstable"))

  stable <- c("gamma", "lgumbel", 
              "llogis", "lnorm", "weibull")
  unstable <- c("burrIII3", "gompertz", "mx_llogis_llogis")
  
  dists <- switch(type, 
         all = c(stable, unstable),
         stable = stable,
         unstable = unstable)
  
  dists <- unique(dists)
  dists <- stringr::str_sort(dists)
  dists
}
