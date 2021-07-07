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

#' CCME Species Sensitivity Data for Boron
#'
#' Species Sensitivity Data from
#' the Canadian Council of Ministers of the Environment.
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
#' @seealso [ccme_data]
#' @family boron
#' @examples
#' head(ccme_data)
"boron_data"

#' fitdists for CCME Boron Data
#'
#' A fitdists object for Species Sensitivity Data for
#' Boron.
#' @family boron
#' @examples
#' boron_dists
"boron_dists"

#' fitdist for CCME Boron Data
#'
#' A fitdist object for Species Sensitivity Data for
#' Boron with the lnorm distribution.
#' @family boron
#' @examples
#' boron_lnorm
"boron_lnorm"

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

#' Model Averaged 5 Hazard Concentration for CCME Boron Data
#'
#' A data frame of the predictions based on 10000 bootstrap.
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
#' boron_hc5
"boron_hc5"

#' CCME Species Sensitivity Data
#'
#' Species Sensitivity Data from
#' the Canadian Council of Ministers of the Environment.
#' The taxonomic groups are Amphibian, Fish, Invertebrate and Plant.
#' Plants includes freshwater algae.
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
