is.waive <- function(x) inherits(x, "waiver")

empty <- function (df) {
  is.null(df) || nrow(df) == 0 || ncol(df) == 0 || is.waive(df)
}

rename <- function (x, replace) 
{
  current_names <- names(x)
  old_names <- names(replace)
  missing_names <- setdiff(old_names, current_names)
  if (length(missing_names) > 0) {
    replace <- replace[!old_names %in% missing_names]
    old_names <- names(replace)
  }
  names(x)[match(old_names, current_names)] <- as.vector(replace)
  x
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
  data$right[is.na(data$right) | !is.finite(data$right)] <- upper
  data
}

is_censored <- function(data) {
  left <- any(is.na(data$left)) | any(data$left == 0)
  right <- any(is.na(data$right)) | any(!is.finite(data$right))
  left || right
}

process_data <- function(data, left, right, weight = NULL) {  
  if(is.null(weight)) {
    weight <- "weight"
    data$weight <- 1
  }
  
  data <- data[c(left, right, weight)]
  colnames(data) <- c("left", "right", "weight")
  
  data$left[is.na(data$left)] <- 0
  data$right[is.na(data$right)] <- Inf
  data
}

is_at_boundary <- function(fit) {
  dist <- .dist_tmbfit(fit)
  if(!is_bounds(dist)) return(FALSE)
  bounds <- bdist(dist)
  pars <- .pars_tmbfit(fit)
  
  lower <- as.numeric(bounds$lower[names(pars)])
  upper <- as.numeric(bounds$upper[names(pars)])
  
  any(pars == lower | pars == upper)
}

adjust_data <- function(data, rescale, reweight, silent) {
  censored <- is_censored(data)
  
  if(reweight) {
    data$weight <- data$weight / max(data$weight)
  }
  # need warning and FAQ about weights
  weighted <- any(data$weight != 1)
  
  if(rescale) {
    rescale <- c(data$left, data$right)
    rescale <- max(rescale[is.finite(rescale)])
    data$left <- data$left / rescale
    data$right <- data$right / rescale
  } else 
    rescale <- 1
  
  list(data = data, censored = censored, rescale = rescale, weighted = weighted)
}
