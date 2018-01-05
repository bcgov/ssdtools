#    Copyright 2015 Province of British Columbia
#
#    Licensed under the Apache License, Version 2.0 (the "License");
#    you may not use this file except in compliance with the License.
#    You may obtain a copy of the License at
#
#       http://www.apache.org/licenses/LICENSE-2.0
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
#'
#' Additional information on each of the chemicals is available from the
#' CCME website.
#' \describe{
#'   \item{Boron}{\url{http://ceqg-rcqe.ccme.ca/download/en/324/}}
#'   \item{Cadmium}{\url{http://ceqg-rcqe.ccme.ca/download/en/148/}}
#'   \item{Chloride}{\url{http://ceqg-rcqe.ccme.ca/download/en/337/}}
#'   \item{Endosulfan}{\url{http://ceqg-rcqe.ccme.ca/download/en/327/}}
#'   \item{Glyphosate}{\url{http://ceqg-rcqe.ccme.ca/download/en/182/}}
#'   \item{Uranium}{\url{http://ceqg-rcqe.ccme.ca/download/en/328/}}
#'   \item{Silver}{\url{http://ceqg-rcqe.ccme.ca/download/en/355/}}
#' }
#'
#' @format A tbl data frame:
#' \describe{
#'   \item{Chemical}{The chemical <chr>.}
#'   \item{Species}{The species binomial name <chr>.}
#'   \item{Conc}{The chemical concentration <dbl>.}
#'   \item{Group}{The taxonomic group <fctr>.}
#' }
#' @examples
#' head(ccme_data)
"ccme_data"

#' fitdist for CCME Boron Data
#'
#' A fitdist object for Species Sensitivity Data for
#' Boron with the lnorm distribution.
#'
#' @examples
#' boron_lnorm
"boron_lnorm"

#' fitdists for CCME Boron Data
#'
#' A fitdists object for Species Sensitivity Data for
#' Boron.
#'
#' @examples
#' boron_lnorm
"boron_dists"
