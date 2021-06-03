.chk_data <- function(data, left, right, weight = NULL, nrow = 0) {
  chk_string(left)
  chk_string(right)
  chk_null_or(weight, chk_string)
  
  chk_not_subset(left, c("right", "weight"))
  chk_not_subset(right, c("left", "weight"))
  chk_null_or(weight, chk_not_subset, c("left", "right"))
  
  chk_whole_number(nrow)
  
  org_data <- data
  values <- setNames(list(c(0, Inf, NA)), left)
  if(left != right)
    values <- c(values, setNames(list(c(0, Inf, NA)), right))
  if(!is.null(weight)) {
    values <- c(values, setNames(list(c(0, Inf)), weight))
  }
  
  check_names(data, names = names(values))
  if(is.null(weight)) {
    data$weight <- 1
    weight <- "weight"
  } else if(is.integer(data[[weight]])) {
    data[[weight]] <- as.double(data[[weight]])
  }
  check_data(data, values, nrow = c(nrow, Inf))
  if(any(!is.na(data[[right]]) & !is.na(data[[left]]) & data[[right]] < data[[left]])) {
    msg <- paste0("`data$", right, "` must have values greater than or equal to `data$",
                  left, "`")
    abort_chk(msg)
  }
  
  data <- data[c(left, right, weight)]
  colnames(data) <- c("left", "right", "weight")
  
  missing <- is.na(data$left) & is.na(data$right)
  
  if(any(missing)) {
    msg <- paste0("`data` has %n row%s with missing values in '", left, "'")
    if(right != left && any(data$left != data$right))
      msg <- paste0(msg, " and '", right, "'")
    abort_chk(msg, n = sum(missing))
  }
  zero_weight <- data$weight == 0
  if(any(zero_weight)) {
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

