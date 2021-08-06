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

#' CCME Species Sensitivity Data
#'
#' Species Sensitivity Data from
#' the Canadian Council of Ministers of the Environment.
#' The taxonomic groups are Amphibian, Fish, Invertebrate and Plant.
#' Plants includes freshwater algae.
#' Please use `[ssddata::ccme_data]` instead.
#'
#' Additional information on each of the chemicals is available from the
#' CCME website.
#' \describe{
#'   \item{Boron}{<http://ceqg-rcqe.ccme.ca/download/en/324/>}
#'   \item{Cadmium}{<http://ceqg-rcqe.ccme.ca/download/en/148/>}
#'   \item{Chloride}{<http://ceqg-rcqe.ccme.ca/download/en/337/>}
#'   \item{Endosulfan}{<http://ceqg-rcqe.ccme.ca/download/en/327/>}
#'   \item{Glyphosate}{<http://ceqg-rcqe.ccme.ca/download/en/182/>}
#'   \item{Uranium}{<http://ceqg-rcqe.ccme.ca/download/en/328/>}
#'   \item{Silver}{<http://ceqg-rcqe.ccme.ca/download/en/355/>}
#' }
#'
#' \describe{
#'   \item{Chemical}{The chemical (chr).}
#'   \item{Species}{The species binomial name (chr).}
#'   \item{Conc}{The chemical concentration (dbl).}
#'   \item{Group}{The taxonomic group (fctr).}
#'   \item{Units}{The units (chr).}
#' }
#' @examples
#' head(ccme_data)
"ccme_data"

#' CCME Species Sensitivity Data for Boron
#'
#' Species Sensitivity Data from
#' the Canadian Council of Ministers of the Environment.
#' Please use `[ssddata::ccme_data]` instead.
#' 
#' Additional information is available from <http://ceqg-rcqe.ccme.ca/download/en/324/>.
#' 
#' The columns are as follows
#'
#' \describe{
#'   \item{Chemical}{The chemical (chr).}
#'   \item{Species}{The species binomial name (chr).}
#'   \item{Concentration}{The chemical concentration (dbl).}
#'   \item{Units}{The units (chr).}
#'   \item{Group}{The taxonomic group (fctr).}
#' }
#' @seealso [`ccme_data()`]
#' @family boron
#' @examples
#' head(ccme_data)
"boron_data"

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
