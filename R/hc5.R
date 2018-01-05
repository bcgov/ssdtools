#' Get HC5
#'
#' @param object The object.
#' @param ... Unused.
#'
#' @return A data frame of the hc5 estimate with se and upper and lower confidence intervals.
#' @export
#' @examples
#' ssd_hc5(boron_lnorm)
ssd_hc5 <- function(object, ...) {
  UseMethod("ssd_hc5")
}

#' @export
ssd_hc5.fitdist <- function(object, nboot = 1001, level = 0.95, ...) {
  predict(object, probs = 0.05, nboot = nboot, level = level)
}

#' @export
ssd_hc5.fitdists <- function(object, nboot = 1001, IC = AIC, level = 0.95, ...) {
    predict(object, probs = 0.05, nboot = nboot, IC = IC, level = level)
}
