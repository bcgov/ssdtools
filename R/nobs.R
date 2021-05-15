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
#    
# 

#' @importFrom stats nobs
#' @export
stats::nobs

.nobs_data <- function(data) {
  if(is_censored_data(data)) return(NA_integer_)
  nrow(data)
}

#' Number of Observations
#'
#' @inheritParams params
#' @seealso [stats::nobs()]
#' @export
#' @examples
#' stats::nobs(boron_lnorm)
nobs.fitdist <- function(object, ...) object$n

#' Number of Observations
#'
#' @inheritParams params
#' @seealso [stats::nobs()]
#' @export
nobs.tmbfit <- function(object, ...) .nobs_data(.data_tmbfit(object))

#' @rdname nobs.fitdist 
#' @export
#' @examples
#' stats::nobs(fluazinam_lnorm)
nobs.fitdistcens <- function(object, ...) NA_integer_

#' @export
nobs.fitdists <- function(object, ...) nobs(object[[1]])
