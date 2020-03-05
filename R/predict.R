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

#' Predict fitdist
#'
#' @inheritParams params
#' @export
#' @examples
#' predict(boron_lnorm, percent = c(5L, 50L))
predict.fitdist <- function(object, percent = 1:99, ci = FALSE, level = 0.95,
                            nboot = 1000, parallel = NULL, ncpus = 1,
                            ...) {
  chk_unused(...)
  if(missing(ci)) {
    deprecate_soft("0.1.0", "ssdtools::predict(ci = )", details = "In particular, the `ci` has been switched from TRUE to FALSE. To retain the previous behaviour of calculating confidence intervals set `ci = TRUE`.", 
                   id = "predict")
  }
  
  ssd_hc(object,
         percent = percent, ci = ci, level = level,
         nboot = nboot, parallel = parallel, ncpus = ncpus
  )
}

#' Predict censored fitdist
#'
#' @inheritParams params
#' @export
#' @examples
#' predict(fluazinam_lnorm, percent = c(5L, 50L))
predict.fitdistcens <- function(object, percent = 1:99, ci = FALSE, level = 0.95,
                                nboot = 1000, parallel = NULL, ncpus = 1,
                                ...) {
  chk_unused(...)
  if(missing(ci)) {
    deprecate_soft("0.1.0", "ssdtools::predict(ci = )", details = "In particular, the `ci` has been switched from TRUE to FALSE. To retain the previous behaviour of calculating confidence intervals set `ci = TRUE`.", 
                   id = "predict")
  }
  ssd_hc(object,
         percent = percent, ci = ci, level = level,
         nboot = nboot, parallel = parallel, ncpus = ncpus
  )
}

#' Predict fitdists
#'
#' @inheritParams params
#' @export
#' @examples
#' predict(boron_dists)
predict.fitdists <- function(object, percent = 1:99, ci = FALSE,
                             level = 0.95, nboot = 1000, parallel = NULL, ncpus = 1,
                             average = TRUE, ic = "aicc",
                             ...) {
  chk_unused(...)
  if(missing(ci)) {
    deprecate_soft("0.1.0", "ssdtools::predict(ci = )", details = "In particular, the `ci` has been switched from TRUE to FALSE. To retain the previous behaviour of calculating confidence intervals set `ci = TRUE`.", 
                   id = "predict")
  }
  ssd_hc(object,
         percent = percent, ci = ci, level = level,
         nboot = nboot, parallel = parallel, ncpus = ncpus,
         average = average, ic = ic
  )
}

#' Predict censored fitdists
#'
#' @inheritParams params
#' @export
#' @examples
#' predict(fluazinam_dists)
predict.fitdistscens <- function(object, percent = 1:99, ci = FALSE,
                                 level = 0.95, nboot = 1000, parallel = NULL, ncpus = 1,
                                 average = TRUE, ic = "aic", ...) {
  chk_unused(...)
  if(missing(ci)) {
    deprecate_soft("0.1.0", "ssdtools::predict(ci = )", details = "In particular, the `ci` has been switched from TRUE to FALSE. To retain the previous behaviour of calculating confidence intervals set `ci = TRUE`.", 
                   id = "predict")
  }
  ssd_hc(object,
         percent = percent, ci = ci, level = level,
         nboot = nboot, parallel = parallel, ncpus = ncpus,
         average = average, ic = ic
  )
}
