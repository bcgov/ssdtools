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

#' Species Sensitivity Distributions
#'
#' Gets a character vector of the names of the available distributions.
#'
#' @param bcanz A flag or NULL specifying whether to only include distributions in the set that is approved by BC, Canada, Australia and New Zealand for official guidelines.
#' @param tails A flag or NULL specifying whether to only include distributions with both tails.
#' @param npars A whole numeric vector specifying which distributions to include based on the number of parameters.
#' @return A unique, sorted character vector of the distributions.
#' @family dists
#' @export
#'
#' @examples
#' ssd_dists()
#' ssd_dists(bcanz = TRUE)
#' ssd_dists(tails = FALSE)
#' ssd_dists(npars = 5)
ssd_dists <- function(bcanz = NULL, tails = NULL, npars = 2:5) {
  chk_null_or(bcanz, vld = vld_flag)
  chk_null_or(tails, vld = vld_flag)

  chk_whole_numeric(npars)
  chk_not_any_na(npars)
  chk_range(npars, c(2L, 5L))

  dists <- ssdtools::dist_data
  if (!is.null(bcanz)) {
    dists <- dists[dists$bcanz == bcanz, ]
  }
  if (!is.null(tails)) {
    dists <- dists[dists$tails == tails, ]
  }
  dists <- dists[dists$npars %in% npars, ]

  dists$dist
}

#' All Species Sensitivity Distributions
#'
#' Gets a character vector of the names of all the available distributions.
#'
#' @return A unique, sorted character vector of the distributions.
#' @family dists
#' @export
#'
#' @examples
#' ssd_dists_all()
ssd_dists_all <- function() {
  ssd_dists(bcanz = NULL, tails = NULL, npars = 2:5)
}
