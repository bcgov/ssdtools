# Copyright 2015-2023 Province of British Columbia
# Copyright 2021 Environment and Climate Change Canada
# Copyright 2023-2024 Australian Government Department of Climate Change, 
# Energy, the Environment and Water
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

#' Censor Data
#' 
#' Censors data to a specified range based on the `censoring` argument.
#' The function is useful for creating test data sets.
#'
#' @inheritParams params
#'
#' @return A tibble of the censored data.
#' @export
#'
#' @examples
#' ssd_censor_data(ssddata::ccme_boron, censoring = c(2.5, Inf))
ssd_censor_data <- function(data, left = "Conc", ..., right = left, censoring = c(0, Inf)) {
  .chk_data(data, left, right)
  chk_unused(...)
  chk_numeric(censoring)
  chk_vector(censoring)
  chk_length(censoring, 2L)
  chk_not_any_na(censoring)

  if (left == right) {
    right <- "right"
    data$right <- data[[left]]
  }

  processed <- process_data(data, left, right)
  censored <- censor_data(processed, censoring)
  data[[left]] <- censored$left
  data[[right]] <- censored$right
  data
}

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

censor_data <- function(data, censoring) {
  if (!.is_censored(censoring)) {
    return(data)
  }
  
  data$right[data$left < censoring[1]] <- min(censoring)
  data$left[data$left < censoring[1]] <- 0
  data$left[data$right > censoring[2]] <- max(censoring)
  data$right[data$right > censoring[2]] <- Inf
  data
}

censoring <- function(data) {
  censoring <- c(0, Inf)

  censored <- data[data$left != data$right, ]
  data <- data[data$left == data$right, ]

  if (!nrow(censored)) {
    return(censoring)
  }

  if (any(censored$left != 0 & !is.infinite(censored$right))) {
    return(c(NA_real_, NA_real_))
  }

  censoring[1] <- max(0, censored$right[censored$left == 0])
  censoring[2] <- min(Inf, censored$left[is.infinite(censored$right)])

  if (censoring[1] >= censoring[2]) {
    return(c(NA_real_, NA_real_))
  }

  if (any(data$right < censoring[1]) || any(data$left > censoring[2])) {
    return(c(NA_real_, NA_real_))
  }

  censoring
}
