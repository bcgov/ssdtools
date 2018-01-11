#' Goodness of Fit
#'
#' @param x The object.
#' @param ... Unused.
#'
#' @return A tbl data frame of the gof statistics.
#' @export
#' @examples
#' ssd_gof(boron_lnorm)
ssd_gof <- function(x, ...) {
  UseMethod("ssd_gof")
}

#' @export
ssd_gof.fitdist <- function(x, ...) {
  dist <- x$distname
  x %<>% fitdistrplus::gofstat()
  dplyr::data_frame(dist = dist, ad = x$ad, ks = x$ks, cvm = x$cvm)
}

ssd_gof.fitdists <- function() {
}
