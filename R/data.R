# Copyright 2015-2023 Province of British Columbia
# Copyright 2021 Environment and Climate Change Canada
# Copyright 2023-2025 Australian Government Department of Climate Change,
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

#' Model Averaged Predictions for CCME Boron Data
#'
#' A data frame of the predictions based on 1,000 bootstrap iterations.
#'
#' \describe{
#'   \item{proportion}{The proportion of species affected (int).}
#'   \item{est}{The estimated concentration (dbl).}
#'   \item{se}{The standard error of the estimate (dbl).}
#'   \item{lcl}{The lower confidence limit (dbl).}
#'   \item{se}{The upper confidence limit (dbl).}
#'   \item{dist}{The distribution (chr).}
#' }
#' @family boron
#' @keywords internal
#' @examples
#' \dontrun{
#' fits <- ssd_fit_dists(ssddata::ccme_boron)
#' withr::with_seed(50, {
#'   boron_pred <- predict(fits, ci = TRUE)
#' })
#' head(boron_pred)
#' }
"boron_pred"

#' Distribution Data
#'
#' A data frame of information on the implemented distributions.
#'
#' \describe{
#'   \item{dist}{The distribution (chr).}
#'   \item{bcanz}{Whether the distribution belongs to the set of distributions approved by BC, Canada, Australia and New Zealand for official guidelines (flag).}
#'   \item{tails}{Whether the distribution has both tails (flag).}
#'   \item{npars}{The number of parameters (int).}
#'   \item{valid}{Whether the distribution has a valid likelihood that allows it to be fit with other distributions for modeling averaging (flag).}
#'   \item{bound}{Whether one or more parameters have boundaries (flag).}
#' }
#' @family dists
#' @keywords internal
#' @examples
#' dist_data
"dist_data"
