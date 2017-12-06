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
