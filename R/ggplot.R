# Name ggplot grid object
# Convenience function to name grid objects
#
# @keyword internal
ggname <- function(prefix, grob) {
  grob$name <- grobName(grob, prefix)
  grob
}

#' Base ggproto classes for ggplot2
#'
#' If you are creating a new geom, stat, position, or scale in another package,
#' you'll need to extend from `ggplot2::Geom`, `ggplot2::Stat`,
#' `ggplot2::Position`, or `ggplot2::Scale`.
#'
#' @seealso ggproto
#' @keywords internal
#' @name ggplot2-ggproto
NULL

#' @rdname ggplot2-ggproto
#' @format NULL
#' @usage NULL
#' @export
StatSsd <- ggplot2::ggproto(
  "StatSsd", ggplot2::Stat,
  compute_panel = function(data, scales) {
    data$density <- ssd_ecd(data$x)
    data
  },
  default_aes = ggplot2::aes(y = ..density..),
  required_aes = "x"
)

#' @rdname ggplot2-ggproto
#' @format NULL
#' @usage NULL
#' @export
StatFitdist <- ggplot2::ggproto(
  "StatFitdist", ggplot2::Stat,
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

#' @rdname ggplot2-ggproto
#' @format NULL
#' @usage NULL
#' @export
GeomFitdist <- ggplot2::ggproto(
  "GeomFitdist", ggplot2::GeomLine
)

#' @rdname ggplot2-ggproto
#' @format NULL
#' @usage NULL
#' @export
GeomP5 <- ggproto("GeomP5", Geom,
  draw_panel = function(data, panel_params, coord) {

    pieces <- data.frame(x = c(0.01, data$xintercept, data$xintercept),
                         y = c(0.05, 0.05, 0.00))

    data <- cbind(data, pieces)
    GeomPath$draw_panel(data, panel_params, coord)
  },

  default_aes = aes(colour = "black", size = 0.5, linetype = "dotted", alpha = NA),
  required_aes = "xintercept",

  draw_key = draw_key_path
)

#' @rdname ggplot2-ggproto
#' @format NULL
#' @usage NULL
#' @export
GeomXribbon <- ggproto("GeomXribbon", Geom,
  default_aes = aes(colour = NA, fill = "grey20", size = 0.5, linetype = 1,
    alpha = NA),

  required_aes = c("y", "xmin", "xmax"),

  draw_key = draw_key_polygon,

  handle_na = function(data, params) {
    data
  },

  draw_group = function(data, panel_params, coord, na.rm = FALSE) {
    if (na.rm) data <- data[stats::complete.cases(data[c("y", "xmin", "xmax")]), ]
    data <- data[order(data$group, data$y), ]

    # Check that aesthetics are constant
    aes <- unique(data[c("colour", "fill", "size", "linetype", "alpha")])
    if (nrow(aes) > 1) {
      stop("Aesthetics can not vary with a ribbon")
    }
    aes <- as.list(aes)

    missing_pos <- !stats::complete.cases(data[c("y", "xmin", "xmax")])
    ids <- cumsum(missing_pos) + 1
    ids[missing_pos] <- NA

    positions <- plyr::summarise(data,
      y = c(y, rev(y)), x = c(xmax, rev(xmin)), id = c(ids, rev(ids)))
    munched <- coord_munch(coord, positions, panel_params)

    ggname("geom_ribbon", polygonGrob(
      munched$x, munched$y, id = munched$id,
      default.units = "native",
      gp = gpar(
        fill = alpha(aes$fill, aes$alpha),
        col = aes$colour,
        lwd = aes$size * .pt,
        lty = aes$linetype)
    ))
  }
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
#' ggplot2::ggplot(ccme_data[ccme_data$Chemical == "Boron",], ggplot2::aes(x = Concentration)) +
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
#' ggplot2::ggplot(ccme_data[ccme_data$Chemical == "Boron",], ggplot2::aes(x = Concentration)) +
#'   stat_ssd() +
#'   stat_fitdist()
stat_fitdist <- function(mapping = NULL, data = NULL, geom = "line",
                     position = "identity", na.rm = FALSE, show.legend = NA,
                     inherit.aes = TRUE, dist = "lnorm", ...) {
  ggplot2::layer(
    stat = StatFitdist, data = data, mapping = mapping, geom = geom,
    position = position, show.legend = show.legend, inherit.aes = inherit.aes,
    params = list(na.rm = na.rm, dist = dist, ...)
  )
}

plot_coord_scale <- function(data, xlab, ylab) {
  check_string(xlab)
  check_string(ylab)

  list(
    coord_trans(x = "log10"),
    scale_x_continuous(xlab, breaks = scales::trans_breaks("log10", function(x) 10^x),
                       labels = comma_signif),
    scale_y_continuous(ylab, labels = percent, limits = c(0, 1),
                       breaks = seq(0,1,by = 0.2), expand = c(0,0))
  )
}

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
