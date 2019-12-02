#    Copyright 2015 Province of British Columbia
#
#    Licensed under the Apache License, Version 2.0 (the "License");
#    you may not use this file except in compliance with the License.
#    You may obtain a copy of the License at
#
#       http://www.apache.org/licenses/LICENSE-2.0
#
#    Unless required by applicable law or agreed to in writing, software
#    distributed under the License is distributed on an "AS IS" BASIS,
#    WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
#    See the License for the specific language governing permissions and
#    limitations under the License.

ggname <- function(prefix, grob) {
  grob$name <- grid::grobName(grob, prefix)
  grob
}

#' Base ggproto classes for ggplot2
#'
#' @seealso \code{\link[ggplot2]{ggplot2-ggproto}}
#' @name ssdtools-ggproto
NULL

#' @rdname ssdtools-ggproto
#' @format NULL
#' @usage NULL
#' @export
StatSsd <- ggproto(
  "StatSsd", Stat,
  compute_panel = function(data, scales) {
    data$density <- ssd_ecd(data$x)
    data
  },
  default_aes = aes(y = ..density..),
  required_aes = "x"
)

#' @rdname ssdtools-ggproto
#' @format NULL
#' @usage NULL
#' @export
StatSsdcens <- ggproto(
  "StatSsdcens", Stat,
  compute_panel = function(data, scales) {
    data$density <- ssd_ecd(rowMeans(data[c("xmin", "xmax")], na.rm = TRUE))
    data
  },
  default_aes = aes(y = ..density..),
  required_aes = c("xmin", "xmax")
)

#' @rdname ssdtools-ggproto
#' @format NULL
#' @usage NULL
#' @export
GeomSsd <- ggproto(
  "GeomSsd", GeomPoint
)

#' @rdname ssdtools-ggproto
#' @format NULL
#' @usage NULL
#' @export
GeomSsdcens <- ggproto(
  "GeomSsdcens", GeomPoint
)

#' @rdname ssdtools-ggproto
#' @format NULL
#' @usage NULL
#' @export
GeomHcintersect <- ggproto(
  "GeomHcintersect", Geom,
  draw_panel = function(data, panel_params, coord) {
    data$group <- 1:nrow(data)
    data$x <- data$xintercept
    data$y <- data$yintercept
    start <- data
    start$x <- 0.0001
    end <- data
    end$y <- -Inf

    data <- rbind(start, data, end)
    GeomPath$draw_panel(data, panel_params, coord)
  },

  default_aes = aes(colour = "black", size = 0.5, linetype = "dotted", alpha = NA),
  required_aes = c("xintercept", "yintercept"),

  draw_key = draw_key_path
)

#' @rdname ssdtools-ggproto
#' @format NULL
#' @usage NULL
#' @export
GeomXribbon <- ggproto(
  "GeomXribbon", Geom,
  default_aes = aes(
    colour = NA, fill = "grey20", size = 0.5, linetype = 1,
    alpha = NA
  ),

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
      err("Aesthetics can not vary with a ribbon.")
    }
    aes <- as.list(aes)

    missing_pos <- !stats::complete.cases(data[c("y", "xmin", "xmax")])
    ids <- cumsum(missing_pos) + 1
    ids[missing_pos] <- NA

    positions <- plyr::summarise(data,
      y = c(y, rev(y)), x = c(xmax, rev(xmin)), id = c(ids, rev(ids))
    )
    munched <- coord_munch(coord, positions, panel_params)

    ggname("geom_ribbon", grid::polygonGrob(
      munched$x, munched$y,
      id = munched$id,
      default.units = "native",
      gp = grid::gpar(
        fill = alpha(aes$fill, aes$alpha),
        col = aes$colour,
        lwd = aes$size * .pt,
        lty = aes$linetype
      )
    ))
  }
)
