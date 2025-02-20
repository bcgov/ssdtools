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

any_missing <- function(...) {
  x <- unlist(list(...))
  any(is.na(x) & !is.nan(x))
}

is.waive <- function(x) inherits(x, "waiver")

empty <- function(df) {
  is.null(df) || nrow(df) == 0 || ncol(df) == 0 || is.waive(df)
}

ggname <- function(prefix, grob) {
  grob$name <- grobName(grob, prefix)
  grob
}

is_bounds <- function(dist) {
  fun <- paste0("b", dist)
  exists(fun, mode = "function")
}

logit <- function(x) {
  stats::qlogis(x)
}

strip_loglogit <- function(x) {
  sub("^log(it){0,1}_", "", x)
}

bind_rows <- function(x) {
  x <- do.call("rbind", x)
  as_tibble(x)
}

measured_range <- function(x) {
  x <- x[!is.na(x)]
  x <- x[is.finite(x)]
  x <- x[x > 0]
  if (!length(x)) {
    return(c(NA_real_, NA_real_))
  }
  range(x)
}

replace_missing <- function(x, y) {
  y <- y[!names(y) %in% names(x)]
  x <- c(x, y)
  x
}

bound_data <- function(data, bounds) {
  bounds <- replace_missing(bounds, c(left = 1, right = 1))
  range <- measured_range(c(data$left, data$right))

  lower <- range[1] / 10^bounds["left"]
  upper <- range[2] * 10^bounds["right"]

  data$left[is.na(data$left) | data$left == 0] <- lower
  data$right[is.na(data$right) | is.infinite(data$right)] <- upper
  data
}

process_data <- function(data, left, right, weight = NULL) {
  if (is.null(weight)) {
    weight <- "weight"
    data$weight <- rep(1, nrow(data))
  } else {
    data[[weight]] <- as.numeric(data[[weight]])
  }

  data <- rename_data(data, left, right, weight)

  data$left[is.na(data$left)] <- 0
  data$right[is.na(data$right)] <- Inf
  data
}

rename_data <- function(data, left, right, weight) {
  data$left <- data[[left]]
  data$right <- data[[right]]
  data$weight <- data[[weight]]
  if (left != "left") {
    data[[left]] <- NULL
  }
  if (right != "right") {
    data[[right]] <- NULL
  }
  if (weight != "weight") {
    data[[weight]] <- NULL
  }
  data
}

is_at_boundary <- function(fit, data, min_pmix = 0.5, range_shape1 = c(0.05, 20), range_shape2 = c(0.05, 20),
                           regex = ".*") {
  dist <- .dist_tmbfit(fit)
  if (!is_bounds(dist)) {
    return(FALSE)
  }
  bounds <- bdist(dist, data, min_pmix, range_shape1, range_shape2)
  pars <- .pars_tmbfit(fit)
  pars <- pars[grepl(regex, names(pars))]

  lower <- as.numeric(bounds$lower[names(pars)])
  upper <- as.numeric(bounds$upper[names(pars)])

  any(pars == lower | pars == upper)
}

geomid <- function(x) {
  x <- x[is.finite(x)]
  x <- x[x > 0]
  if (!length(x)) {
    return(1)
  }
  exp(mean(log(range(x))))
}

adjust_data <- function(data, rescale, reweight, silent) {
  censoring <- censoring(data)

  if (reweight) {
    data$weight <- data$weight / max(data$weight)
  }
  weighted <- max(data$weight)
  unequal <- any(data$weight != data$weight[1])

  if (rescale) {
    rescale <- c(data$left, data$right)
    rescale <- geomid(rescale)
    data$left <- data$left / rescale
    data$right <- data$right / rescale
  } else {
    rescale <- 1
  }

  list(data = data, censoring = censoring, rescale = rescale, weighted = weighted, unequal = unequal)
}

mean_weighted_values <- function(data, weight = TRUE) {
  data <- as.matrix(data[c("left", "right")])
  x <- rowMeans(data, na.rm = TRUE)
  if (!weight) {
    return(x)
  }
  x <- x[weight > 0]
  weight <- weight[weight > 0]
  weight <- weight / min(weight)
  weight <- round(weight)
  rep(x, weight)
}
