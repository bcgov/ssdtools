#' Goodness of Fit
#'
#' @param x The object.
#' @param ... Unused.
#'
#' @return A tbl data frame of the gof statistics.
#' @export
#' @examples
#' ssd_gof(boron_lnorm)
#' ssd_gof(boron_dists)
ssd_gof <- function(x, ...) {
  UseMethod("ssd_gof")
}

#' @export
ssd_gof.fitdist <- function(x, ...) {
  dist <- x$distname
  n <- nobs(x)
  k <- npars(x)
  x %<>% fitdistrplus::gofstat()

  aicc <- x$aic  + 2 * k * (k + 1) / (n - k - 1)

  dplyr::data_frame(dist = dist, ad = x$ad, ks = x$ks, cvm = x$cvm,
                    aic = x$aic, aicc = aicc, bic = x$bic)
}

#' @export
ssd_gof.fitdists <- function(x, ...) {
  map_df(x, ssd_gof)
}
