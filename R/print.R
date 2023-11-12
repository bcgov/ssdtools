# Copyright 2023 Province of British Columbia
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

.print_parameter <- function(parameter, name) {
  txt <- paste0("\n  ", name, " ", signif(parameter))
  cat(txt)
  invisible(parameter)
}

#' @export
print.summary_tmbfit <- function(x, ...) {
  txt <- paste0("Distribution '", x$dist, "'")
  cat(txt)
  mapply(.print_parameter, x$estimates, names(x$estimates))
  cat("\n\n")
  invisible(x)
}

#' @export
print.summary_fitdists <- function(x, ...) {
  lapply(x$fits, print)
  censoring <- censoring_text(x$censoring)
  if (x$unequal) {
    weighted <- "unequally weighted"
  } else if (x$weighted != 1) {
    weighted <- "weighted"
  } else {
    weighted <- NULL
  }
  rescaled <- if (x$rescaled != 1) {
    paste0("rescaled (", signif(x$rescaled, 4), ")")
  } else {
    NULL
  }
  properties <- c(censoring, weighted, rescaled)
  properties <- cc(properties, conj = " and ", brac = "")
  if (length(properties)) properties <- paste0(" ", properties)

  txt <- paste0("Parameters estimated from ", x$nrow, " rows of", properties, " data.")
  cat(txt)
  invisible(x)
}

#' @export
print.tmbfit <- function(x, ...) {
  print(summary(x))
}

#' @export
print.fitdists <- function(x, ...) {
  print(summary(x))
}
