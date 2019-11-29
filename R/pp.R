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

#' Percent Protected
#'
#' Gets percent species protected at specified concentrations.
#'
#' @param x The object.
#' @param conc A numeric vector of the concentrations.
#' @param ... Unused.
#' @return A numeric vector of percent values between 0 and 100.
#' @export
ssd_pp <- function(x, ...) {
  UseMethod("ssd_pp")
}

#' @describeIn ssd_pp Percent Protected ssd_pp
#' @export
#' @examples
#' ssd_pp(boron_lnorm, c(0, 1, 30, Inf))
ssd_pp.fitdist <- function(x, conc, ...) {
  chk_unused(...)
  
  args <- as.list(x$estimate)
  args$q <- conc
  
  what <- paste0("p", x$distname)
  
  p <- do.call(what, args)
  p * 100
}
