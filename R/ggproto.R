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

