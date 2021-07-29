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

#' Subset fitdists
#'
#' @inheritParams params
#' @export
#' @examples
#' boron_dists <- ssd_fit_dists(ssdtools::boron_data)
#' subset(boron_dists, c("gamma", "lnorm"))
subset.fitdists <- function(x, select = names(x), ...) {
  chk_s3_class(select, "character")
  chk_vector(select)
  chk_unique(select)
  chk_named(x)
  chk_superset(names(x), select)

  chk_unused(...)

  attrs <- .attrs_fitdists(x)

  class <- class(x)
  x <- x[names(x) %in% select]
  class(x) <- class
  
  .attrs_fitdists(x) <- attrs
  x
}
