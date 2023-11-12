# Copyright 2023 Province of British Columbia
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

.is_censored <- function(x) {
  !identical(x, c(0, Inf))
}

censoring_text <- function(x) {
  if (!.is_censored(x)) {
    return(NULL)
  }
  if (identical(x, c(NA_real_, NA_real_))) {
    return("inconsistently censored")
  }
  left <- if (x[1] == 0) NULL else paste0("left (", signif(x[1], 4), ")")
  right <- if (is.infinite(x[2])) NULL else paste0("right (", signif(x[2], 4), ")")
  censoring <- c(left, right)
  censoring <- cc(censoring, conj = " and ", brac = "")
  censoring <- paste0(censoring, " censored")
  censoring
}

#' Is Censored
#'
#' Deprecated for [`ssd_is_censored()`].
#'
#' @param x A fitdists object.
#'
#' @return A flag indicating if the data is censored.
#' @export
#' @seealso [`ssd_is_censored()`]
#'
#' @examples
#' fits <- ssd_fit_dists(ssddata::ccme_boron)
#' is_censored(fits)
is_censored <- function(x) {
  lifecycle::deprecate_warn("0.3.7", "is_censored()", "ssd_is_censored()")
  chk_s3_class(x, "fitdists")
  ssd_is_censored(x)
}

censor_data <- function(data, censoring) {
  if (!.is_censored(censoring)) {
    return(data)
  }
  chk_not_any_na(censoring)

  data$left[data$left < censoring[1]] <- 0
  data$right[data$right > censoring[2]] <- Inf
  data
}

censoring <- function(data) {
  censoring <- c(0, Inf)
  data <- data[data$left != data$right, ]

  if (!nrow(data)) {
    return(censoring)
  }

  left <- data$left == 0
  right <- is.infinite(data$right)

  if (any(!left & !right)) {
    return(c(NA_real_, NA_real_))
  }

  censoring[1] <- max(0, data$right[data$left == 0])
  censoring[2] <- min(Inf, censoring[2], data$left[is.infinite(data$right)])

  if (censoring[1] >= censoring[2]) {
    return(c(NA_real_, NA_real_))
  }

  censoring
}
