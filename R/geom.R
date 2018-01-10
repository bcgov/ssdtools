#' Ribbons Plot
#'
#' For each y value, `geom_ribbon` displays an x interval defined
#' by `xmin` and `xmax`.
#'
#' @inheritParams ggplot2::layer
#' @inheritParams ggplot2::geom_point
#' @export
geom_xribbon <- function(mapping = NULL, data = NULL, stat = "identity",
                         position = "identity", na.rm = FALSE, show.legend = NA,
                         inherit.aes = TRUE, ...) {
  layer(
    geom = GeomXribbon, data = data, mapping = mapping, stat = stat,
    position = position, show.legend = show.legend, inherit.aes = inherit.aes,
    params = list(na.rm = na.rm, ...)
  )
}

#' Plot Species Sensitivity Data
#'
#' Uses the empirical cumulative density/distribution to visualize species sensitivity data.
#'
#' @inheritParams ggplot2::layer
#' @inheritParams ggplot2::geom_point
#' @export
#' @examples
#' ggplot2::ggplot(boron_data, ggplot2::aes(x = Concentration)) +
#'   geom_ssd()
geom_ssd <- function(mapping = NULL, data = NULL, stat = "ssd",
                     position = "identity", na.rm = FALSE, show.legend = NA,
                     inherit.aes = TRUE, ...) {
  layer(
    geom = GeomSsd, data = data, mapping = mapping, stat = stat,
    position = position, show.legend = show.legend, inherit.aes = inherit.aes,
    params = list(na.rm = na.rm, ...)
  )
}

#' Plot fitdist
#'
#' Plots the fit of a univariate distribution as a cumulative density/distribution function.
#'
#' @inheritParams ggplot2::layer
#' @inheritParams ggplot2::geom_point
#' @inheritParams ssd_fit_dist
#' @seealso \code{\link{ssd_fit_dist}}
#' @export
#' @examples
#' ggplot2::ggplot(boron_data, ggplot2::aes(x = Concentration)) +
#'   geom_ssd() +
#'   geom_fitdist()
geom_fitdist <- function(mapping = NULL, data = NULL, stat = "fitdist",
                         position = "identity", na.rm = FALSE, show.legend = NA,
                         inherit.aes = TRUE, ...) {
  layer(
    geom = GeomFitdist, data = data, mapping = mapping, stat = stat,
    position = position, show.legend = show.legend, inherit.aes = inherit.aes,
    params = list(na.rm = na.rm, ...)
  )
}

#' Fifth Percentile Plot
#'
#' For each x value, `geom_p5` displays the fifth percentile.
#'
#' @inheritParams ggplot2::layer
#' @inheritParams ggplot2::geom_path
#' @param xintercept The x-value for the fifth percentil..
#' @export
#' @examples
#' ggplot2::ggplot(boron_data, ggplot2::aes(x = Concentration)) +
#'   geom_ssd() +
#'   geom_p5(xintercept = 1.5)
geom_p5 <- function(mapping = NULL, data = NULL, xintercept,
                    na.rm = FALSE, show.legend = NA, ...) {

  if (!missing(xintercept)) {
    data <- data.frame(xintercept = xintercept)
    mapping <- aes(xintercept = xintercept)
    show.legend <- FALSE
  }

  layer(
    geom = GeomP5,  data = data, mapping = mapping, stat = StatIdentity,
    position = PositionIdentity, show.legend = show.legend, inherit.aes = FALSE,
    params = list(na.rm = na.rm, ...)
  )
}
