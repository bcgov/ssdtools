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
