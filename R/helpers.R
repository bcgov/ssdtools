is.waive <- function(x) inherits(x, "waiver")

empty <- function (df) {
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

bind_rows <- function(x) {
  x <- do.call("rbind", x)
  as_tibble(x)
}

`%||%` <- function(x, y) if (is.null(x) || length(x) == 0) y else x

measured_range <- function(x) {
  x <- x[!is.na(x)]
  x <- x[is.finite(x)]
  x <- x[x > 0]
  if(!length(x)) return(c(NA_real_, NA_real_))
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
  if(is.null(weight)) {
    weight <- "weight"
    data$weight <- rep(1, nrow(data))
  } else
    data[[weight]] <- as.numeric(data[[weight]])
  
  data <- rename_data(data, left, right, weight)
  
  data$left[is.na(data$left)] <- 0
  data$right[is.na(data$right)] <- Inf
  data
}

rename_data <- function(data, left, right, weight) {
  data$left <- data[[left]]
  data$right <- data[[right]]
  data$weight <- data[[weight]]
  if(left != "left") {
    data[[left]] <- NULL
  } 
  if(right != "right") {
    data[[right]] <- NULL
  } 
  if(weight != "weight") {
    data[[weight]] <- NULL
  }
  data
}

is_at_boundary <- function(fit, data) {
  dist <- .dist_tmbfit(fit)
  if(!is_bounds(dist)) return(FALSE)
  bounds <- bdist(dist, data)
  pars <- .pars_tmbfit(fit)
  
  lower <- as.numeric(bounds$lower[names(pars)])
  upper <- as.numeric(bounds$upper[names(pars)])
  
  any(pars == lower | pars == upper)
}

adjust_data <- function(data, rescale, reweight, silent) {
  censoring <- censoring(data)
  
  if(reweight) {
    data$weight <- data$weight / max(data$weight)
  }
  weighted <- max(data$weight)
  unequal <- any(data$weight != data$weight[1])
  
  if(rescale) {
    rescale <- c(data$left, data$right)
    rescale <- max(rescale[is.finite(rescale)])
    data$left <- data$left / rescale
    data$right <- data$right / rescale
  } else 
    rescale <- 1
  
  list(data = data, censoring = censoring, rescale = rescale, weighted = weighted, unequal = unequal)
}

mean_values <- function(data) {
  data <- data[c("left", "right")]
  data <- as.matrix(data)
  rowMeans(data, na.rm = TRUE)
}
