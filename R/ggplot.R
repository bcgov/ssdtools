#' Empirical Cumulative Density Stat
#' @format NULL
#' @usage NULL
#' @export
StatEcd <- ggplot2::ggproto(
  "StatEcd", ggplot2::Stat,
  compute_group = function(data, scales) {
    data$density <- (rank(data$x) - 0.5) / length(data$x)
    data
  },
  default_aes = ggplot2::aes(y = ..density..),
  required_aes = "x"
)

#' Cumulative Density Function Stat
#' @format NULL
#' @usage NULL
#' @export
StatCdf <- ggplot2::ggproto(
  "StatCdf", ggplot2::Stat,
  compute_group = function(data, scales, dist) {
    fit <- ssd_fit_dist(data$x, dist = dist)
    pred <- predict(fit, nboot = 10)
    data.frame(x = pred$est, density = pred$prob)
  },
  default_aes = ggplot2::aes(y = ..density..),
  required_aes = "x"
)

#' ECD Geom
#' @format NULL
#' @usage NULL
#' @export
GeomEcd <- ggplot2::ggproto(
  "GeomEcd", ggplot2::GeomPoint
)

#' Calculate Empirical Cumulative Density
#'
#' The empirical cumulative density/distribution provides a way to visualize species sensitivity data.
#'
#' @inheritParams ggplot2::layer
#' @inheritParams ggplot2::geom_point
#' @export
#' @examples
#' ggplot2::ggplot(ccme_data[ccme_data$Chemical == "Boron",], ggplot2::aes(x = Conc)) +
#'   stat_ecd()
stat_ecd <- function(mapping = NULL, data = NULL, geom = "point",
                     position = "identity", na.rm = FALSE, show.legend = NA,
                     inherit.aes = TRUE, ...) {
  ggplot2::layer(
    stat = StatEcd, data = data, mapping = mapping, geom = geom,
    position = position, show.legend = show.legend, inherit.aes = inherit.aes,
    params = list(na.rm = na.rm, ...)
  )
}

#' Calculate Empirical Cumulative Density
#'
#' The empirical cumulative density/distribution provides a way to visualize species sensitivity data.
#'
#' @inheritParams ggplot2::layer
#' @inheritParams ggplot2::geom_point
#' @export
#' @examples
#' ggplot2::ggplot(ccme_data[ccme_data$Chemical == "Boron",], ggplot2::aes(x = Conc)) +
#'   geom_ecd()
geom_ecd <- function(mapping = NULL, data = NULL, stat = "ecd",
                     position = "identity", na.rm = FALSE, show.legend = NA,
                     inherit.aes = TRUE, ...) {
  ggplot2::layer(
    geom = GeomEcd, data = data, mapping = mapping, stat = stat,
    position = position, show.legend = show.legend, inherit.aes = inherit.aes,
    params = list(na.rm = na.rm, ...)
  )
}

#' Estimates Cumulative Density Function
#'
#' Estimates the cumulative density/distribution function (CDF) for x
#' based on a univariate distribution.
#'
#' @inheritParams ggplot2::layer
#' @inheritParams ggplot2::geom_point
#' @inheritParams ssd_fit_dist
#' @seealso \code{\link{ssd_fit_dist}}
#' @export
#' @examples
#' ggplot2::ggplot(ccme_data[ccme_data$Chemical == "Boron",], ggplot2::aes(x = Conc)) +
#'   stat_ecd() +
#'   stat_cdf()
stat_cdf <- function(mapping = NULL, data = NULL, geom = "line",
                     position = "identity", na.rm = FALSE, show.legend = NA,
                     inherit.aes = TRUE, dist = "lnorm", ...) {
  ggplot2::layer(
    stat = StatCdf, data = data, mapping = mapping, geom = geom,
    position = position, show.legend = show.legend, inherit.aes = inherit.aes,
    params = list(na.rm = na.rm, dist = dist, ...)
  )
}
