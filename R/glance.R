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

#' @export
generics::glance

.glance_tmbfit <- function(x, nobs) {
  dist <- .dist_tmbfit(x)
  npars <- npars(x)
  log_lik <- logLik(x)
  aic <- 2 * npars - 2 * log_lik
  aicc <- aic + 2 * npars * (npars + 1) / (nobs - npars - 1)
  
  tibble(
    dist = dist,
    npars = npars,
    nobs = nobs,
    log_lik = log_lik,
    aic = aic,
    aicc = aicc
  )
}

#' Construct a tibble::tibble() with a single row "glance" for each tmbfit model.
#'
#' Turns a fitdists object into a glance tibble.
#' 
#' @param x A fitdists object to be converted into a tidy tibble::tibble().
#' @param ... Must be unused.
#'  
#' @export
glance.fitdists <- function(x, ...) {
  nobs <- nobs(x)
  tbl <- lapply(x, .glance_tmbfit, nobs = nobs)
  tbl <- bind_rows(tbl)
  tbl$delta <- tbl$aicc - min(tbl$aicc)
  if(is.na(tbl$delta[1]) && all(tbl$npars == tbl$npars[1])) {
    tbl$delta <- tbl$aicc - min(tbl$aicc)
  }
  tbl$weight <- exp(-tbl$delta / 2) / sum(exp(-tbl$delta / 2))
  tbl
}
