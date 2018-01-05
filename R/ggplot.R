#' @rdname ggplot2-ggproto
#' @format NULL
#' @usage NULL
#' @export
StatSsd <- ggplot2::ggproto(
  "StatSsd", ggplot2::Stat,
  compute_group = function(data, scales) {
    data$density <- (rank(data$x) - 0.5) / length(data$x)
    data
  },
  default_aes = ggplot2::aes(y = ..density..),
  required_aes = "x"
)

#' @rdname ggplot2-ggproto
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

#' @rdname ggplot2-ggproto
#' @format NULL
#' @usage NULL
#' @export
GeomSsd <- ggplot2::ggproto(
  "GeomSsd", ggplot2::GeomPoint
)

#' Plot Species Sensitivy Data
#'
#' Uses the empirical cumulative density/distribution to visualize species sensitivity data.
#'
#' @inheritParams ggplot2::layer
#' @inheritParams ggplot2::geom_point
#' @seealso \code{\link{geom_ssd}}
#' @export
#' @examples
#' ggplot2::ggplot(ccme_data[ccme_data$Chemical == "Boron",], ggplot2::aes(x = Conc)) +
#'   stat_ssd()
stat_ssd <- function(mapping = NULL, data = NULL, geom = "point",
                     position = "identity", na.rm = FALSE, show.legend = NA,
                     inherit.aes = TRUE, ...) {
  ggplot2::layer(
    stat = StatSsd, data = data, mapping = mapping, geom = geom,
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
#' ggplot2::ggplot(ccme_data[ccme_data$Chemical == "Boron",], ggplot2::aes(x = Conc)) +
#'   geom_ssd()
geom_ssd <- function(mapping = NULL, data = NULL, stat = "ssd",
                     position = "identity", na.rm = FALSE, show.legend = NA,
                     inherit.aes = TRUE, ...) {
  ggplot2::layer(
    geom = GeomSsd, data = data, mapping = mapping, stat = stat,
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
#'   stat_ssd() +
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
