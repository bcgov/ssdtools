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

.chk_data <- function(data, left, right, weight = NULL, nrow = 0, missing = FALSE) {
  chk_string(left)
  chk_string(right)
  chk_null_or(weight, vld = vld_string)

  chk_not_subset(left, c("right", "weight"))
  chk_not_subset(right, c("left", "weight"))
  chk_null_or(weight, vld = vld_not_subset, values = c("left", "right"))

  chk_whole_number(nrow)

  org_data <- data
  values <- setNames(list(c(0, Inf, NA)), left)
  if (left != right) {
    values <- c(values, setNames(list(c(0, Inf, NA)), right))
  }
  if (!is.null(weight)) {
    values <- c(values, setNames(list(c(0, Inf)), weight))
  }

  check_names(data, names = names(values))
  if (is.null(weight)) {
    data$weight <- rep(1, nrow(data))
    weight <- "weight"
  } else if (is.integer(data[[weight]])) {
    data[[weight]] <- as.double(data[[weight]])
  }
  check_data(data, values, nrow = c(nrow, Inf))
  if (any(!is.na(data[[right]]) & !is.na(data[[left]]) & data[[right]] < data[[left]])) {
    msg <- paste0(
      "`data$", right, "` must have values greater than or equal to `data$",
      left, "`"
    )
    abort_chk(msg)
  }

  data <- data[c(left, right, weight)]
  colnames(data) <- c("left", "right", "weight")

  if (!missing) {
    missing <- (is.na(data$left) | data$left == 0 | is.infinite(data$left)) &
      (is.na(data$right) | data$right == 0 | is.infinite(data$right))

    if (any(missing)) {
      msg <- paste0("`data` has %n row%s with effectively missing values in '", left, "'")
      if (right != left && any(data$left != data$right)) {
        msg <- paste0(msg, " and '", right, "'")
      }
      abort_chk(msg, n = sum(missing))
    }
  }
  zero_weight <- data$weight == 0
  if (any(zero_weight)) {
    abort_chk("`data` has %n row%s with zero weight in '", weight, "'", n = sum(zero_weight))
  }
  org_data
}

.chk_bounds <- function(bounds) {
  chk_numeric(bounds)
  chk_gte(bounds)
  chk_named(bounds)
  chk_subset(names(bounds), c("left", "right"))
  chk_unique(names(bounds))
  invisible(bounds)
}
