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

#' Is Computable Standard Errors
#'
#' Generic function to test if all parameters have numerically computable standard errors.
#'
#' @inheritParams params
#' @return A flag for each distribution indicating if all parameters have numerically computable standard errors.
#' @export
ssd_computable <- function(x, ...) {
  UseMethod("ssd_computable")
}

#' @describeIn ssd_computable Is Computable Standard for tmbfit Object
#' @return A flag indicating if all parameters have numerically computable standard errors.
#' @inheritParams params
#' @export
#'
#' @examples
#' fits <- ssd_fit_dists(ssddata::ccme_boron,
#'   dists = c("lnorm", "lnorm_lnorm", "burrIII3")
#' )
#' ssd_computable(fits$lnorm)
#' ssd_computable(fits$lnorm_lnorm)
#' ssd_computable(fits$burrIII3)
#'
ssd_computable.tmbfit <- function(x, ...) {
  chk_unused(...)
  if (is.null(x$flags$computable)) {
    return(NA)
  }
  x$flags$computable
}

#' @describeIn ssd_computable Is At Boundary for fitdists Object
#' @return A logical vector for each distribution indicating if all parameters have numerically computable standard errors.
#' @inheritParams params
#' @export
#'
#' @examples
#' fits <- ssd_fit_dists(ssddata::ccme_boron,
#'   dists = c("lnorm", "lnorm_lnorm", "burrIII3")
#' )
#' ssd_computable(fits)
#'
ssd_computable.fitdists <- function(x, ...) {
  chk_unused(...)
  x <- vapply(x, ssd_computable, TRUE)
  x
}
