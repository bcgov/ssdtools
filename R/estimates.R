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
universals::estimates

#' @export
estimates.tmbfit <- function(x,...) {
  pars <- .pars_tmbfit(x)
  log <- grepl("^log_", names(pars))
  pars[log] <- exp(pars[log])
  logit <- grepl("^logit_", names(pars))
  pars[logit] <- plogis(pars[logit])
  
  names(pars) <- sub("^log(it){0,1}_", "", names(pars))
  pars <- pars[str_order(names(pars))]
  as.list(pars)
}

#' @export
estimates.fitdists <- function(x, ...) {
  y <- lapply(x, estimates)
  names(y) <- names(x)
  y
}

