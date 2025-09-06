# Copyright 2025 Australian Government Department of Climate Change,
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

#' Is At Boundary
#'
#' Generic function to test if one or more parameters is at boundary.
#'
#' @inheritParams params
#' @return A flag for each distribution indicating if one or more parameters at boundary.
#' @export
ssd_at_boundary <- function(x, ...) {
  UseMethod("ssd_at_boundary")
}

#' @describeIn ssd_at_boundary Is At Boundary for tmbfit Object
#' @return A flag indicating if one or more parameters at boundary.
#' @inheritParams params
#' @export
#' 
#' @examples
#' fits <- ssd_fit_dists(ssddata::ccme_boron, 
#'   dists = c("lnorm", "lnorm_lnorm", "burrIII3")
#' )
#' ssd_at_boundary(fits$lnorm)
#' ssd_at_boundary(fits$lnorm_lnorm)
#' ssd_at_boundary(fits$burrIII3)
#' 
ssd_at_boundary.tmbfit <- function(x, ...) {
  chk_unused(...)
  if(is.null(x$flags$at_boundary)) {
    return(NA)
  }
  x$flags$at_boundary
}

#' @describeIn ssd_at_boundary Is At Boundary for fitdists Object
#' @return A logical vector for each distribution indicating if one or more parameters at boundary.
#' @inheritParams params
#' @export
#' 
#' @examples
#' fits <- ssd_fit_dists(ssddata::ccme_boron, 
#'   dists = c("lnorm", "lnorm_lnorm", "burrIII3")
#' )
#' ssd_at_boundary(fits)
#' 
ssd_at_boundary.fitdists <- function(x, ...) {
  chk_unused(...)
  x <- vapply(x, ssd_at_boundary, TRUE)
  x
}
