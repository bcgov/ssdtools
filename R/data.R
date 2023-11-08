# Copyright 2023 Province of British Columbia
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
#'   \item{percent}{The percent of species affected (int).}
#'   \item{est}{The estimated concentration (dbl).}
#'   \item{se}{The standard error of the estimate (dbl).}
#'   \item{lcl}{The lower confidence limit (dbl).}
#'   \item{se}{The upper confidence limit (dbl).}
#'   \item{dist}{The distribution (chr).}
#' }
#' @family boron
#' @examples
#' head(boron_pred)
"boron_pred"

#' Distribution Data
#'
#' A data frame of information on the implemented distributions.
#'
#' \describe{
#'   \item{dist}{The distribution (chr).}
#'   \item{npars}{The number of parameters (int).}
#'   \item{tails}{Whether the distribution has both tails (flag).}
#'   \item{stable}{Whether the distribution is numerically stable (flag).}
#'   \item{bcanz}{Whether the distribution belongs to the set of distributions approved by BC, Canada, Australia and New Zealand for official guidelines (flag).}
#' }
#' @family dists
#' @examples
#' dist
"dist_data"
