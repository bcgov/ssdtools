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

.censoring_fitdists <- function(fits) {
  attr(fits, "censoring", exact = TRUE)
}

.cols_fitdists <- function(fits) {
  attr(fits, "cols", exact = TRUE)
}

.control_fitdists <- function(fits) {
  attr(fits, "control", exact = TRUE)
}

.data_fitdists <- function(fits) {
  attr(fits, "data", exact = TRUE)
}

.org_data_fitdists <- function(fits) {
  attr(fits, "org_data", exact = TRUE)
}

.min_pmix_fitdists <- function(fits) {
  attr(fits, "min_pmix", exact = TRUE)
}

.range_shape1_fitdists <- function(fits) {
  attr(fits, "range_shape1", exact = TRUE)
}

.range_shape2_fitdists <- function(fits) {
  attr(fits, "range_shape2", exact = TRUE)
}

.rescale_fitdists <- function(fits) {
  attr(fits, "rescale", exact = TRUE)
}

.weighted_fitdists <- function(fits) {
  attr(fits, "weighted", exact = TRUE)
}

.unequal_fitdists <- function(fits) {
  attr(fits, "unequal", exact = TRUE)
}

`.censoring_fitdists<-` <- function(fits, value) {
  attr(fits, "censoring") <- value
  fits
}

`.cols_fitdists<-` <- function(fits, value) {
  attr(fits, "cols") <- value
  fits
}

`.control_fitdists<-` <- function(fits, value) {
  attr(fits, "control") <- value
  fits
}

`.data_fitdists<-` <- function(fits, value) {
  attr(fits, "data") <- value
  fits
}

`.org_data_fitdists<-` <- function(fits, value) {
  attr(fits, "org_data") <- value
  fits
}

`.min_pmix_fitdists<-` <- function(fits, value) {
  attr(fits, "min_pmix") <- value
  fits
}

`.range_shape1_fitdists<-` <- function(fits, value) {
  attr(fits, "range_shape1") <- value
  fits
}

`.range_shape2_fitdists<-` <- function(fits, value) {
  attr(fits, "range_shape2") <- value
  fits
}

`.rescale_fitdists<-` <- function(fits, value) {
  attr(fits, "rescale") <- value
  fits
}

`.weighted_fitdists<-` <- function(fits, value) {
  attr(fits, "weighted") <- value
  fits
}

`.unequal_fitdists<-` <- function(fits, value) {
  attr(fits, "unequal") <- value
  fits
}

.attrs_fitdists <- function(fits) {
  attrs <- attributes(fits)
  attrs[c(
    "censoring", "cols", "control", "data", "org_data", "min_pmix", "range_shape1",
    "range_shape2", "rescale", "weighted", "unequal"
  )]
}

`.attrs_fitdists<-` <- function(fits, value) {
  .censoring_fitdists(fits) <- value$censoring
  .control_fitdists(fits) <- value$control
  .cols_fitdists(fits) <- value$cols
  .data_fitdists(fits) <- value$data
  .org_data_fitdists(fits) <- value$org_data
  .min_pmix_fitdists(fits) <- value$min_pmix
  .range_shape1_fitdists(fits) <- value$range_shape1
  .range_shape2_fitdists(fits) <- value$range_shape2
  .rescale_fitdists(fits) <- value$rescale
  .weighted_fitdists(fits) <- value$weighted
  .unequal_fitdists(fits) <- value$unequal
  fits
}
