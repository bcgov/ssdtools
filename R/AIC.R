#' Get the AICc value or table.
#'
#' @param object The object.
#' @param ... Optional.
#'
#' @export
AICc <- function(object, ...) {
  UseMethod("AICc")
}

#' @export
AIC.fitdist <- function(object, ..., k = 2) {
  check_vector(k, c(0, Inf), length = 1)

  args <- list(...)
  if(!length(args)) {
    penalty <- k
    k <- npars(object)
    n <- nobs(object)
    return(penalty * k - 2 * object$loglik)
  }
  lapply(args, function(x) {if(!is_fitdist(x)) stop("all objects must inherit from fitdist"); x})
  names(args) <- names(pryr::named_dots(...))
  object_name <- deparse(substitute(object))
  object %<>% list() %>% setNames(object_name)
  args %<>% c(object, .)
  class(args) <- "fitdists"
  AIC(args, k = k)
}

#' @export
AICc.fitdist <- function(object, ...) {
  aic <- AIC(object, ...)
  n <- nobs(object)
  if(!length(list(...))) {
    k <- npars(object)
    c <- 2 * k * (k + 1) / (n - k - 1)
    return(aic + c)
  }
  colnames(aic)[2] <- "AICc"
  k <- aic$df
  c <- 2 * k * (k + 1) / (n - k - 1)
  aic$AICc <- aic$AICc + c
  aic
}

#' @export
BIC.fitdist <- function(object, ...) {
  aic <- AIC(object, ..., k = log(nobs(object)))
  if(!length(list(...))) return(aic)
  colnames(aic)[2] <- "BIC"
  aic
}

#' @export
AIC.fitdists <- function(object, ..., k = 2) {
  args <- list(...)
  if(length(args)) {
    lapply(args, function(x) {if(!is_fitdists(x)) stop("all objects must inherit from fitdists"); x})
    object %<>% c(unlist(args, recursive = FALSE))
    class(object) <- "fitdists"
  }
  check_named(object, unique = TRUE)
  n <- nobs(object)
  AIC <- map_dbl(object, AIC, k = k)
  df <- map_int(object, npars)
  aic <- data.frame(df = df, AIC = AIC)
  rownames(aic) <- names(object)
  aic
}

#' @export
AICc.fitdists <- function(object, ...) {
  aic <- AIC(object, ...)
  colnames(aic)[2] <- "AICc"
  n <- nobs(object)
  k <- aic$df
  c <- 2 * k * (k + 1) / (n - k - 1)
  aic$AICc <- aic$AICc + c
  aic
}

#' @export
BIC.fitdists <- function(object, ...) {
  aic <- AIC(object, ..., k = log(nobs(object)))
  colnames(aic)[2] <- "BIC"
  aic
}
