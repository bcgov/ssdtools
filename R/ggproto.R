# Copyright 2023 Province of British Columbia
#
#    Licensed under the Apache License, Version 2.0 (the "License");
#    you may not use this file except in compliance with the License.
#    You may obtain a copy of the License at
#
#       https://www.apache.org/licenses/LICENSE-2.0
#
#    Unless required by applicable law or agreed to in writing, software
#    distributed under the License is distributed on an "AS IS" BASIS,
#    WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
#    See the License for the specific language governing permissions and
#    limitations under the License.

#' ggproto Classes for Plotting Species Sensitivity Data and Distributions
#'
#' @seealso [`ggplot2::ggproto()`] and [`ssd_plot_cdf()`]
#' @name ssdtools-ggproto
NULL

#' @rdname ssdtools-ggproto
#' @export
StatSsdpoint <- ggproto(
  "StatSsdpoint", Stat,
  required_aes = "x",
  default_aes = aes(y = ..density..),
  compute_panel = function(data, scales) {
    data$density <- ssd_ecd(data$x)
    data
  }
)

#' @rdname ssdtools-ggproto
#' @export
StatSsdsegment <- ggproto(
  "StatSsdsegment", Stat,
  required_aes = c("x", "xend"),
  default_aes = aes(y = ..density.., yend = ..density..),
  compute_panel = function(data, scales) {
    data$density <- ssd_ecd(rowMeans(data[c("x", "xend")], na.rm = TRUE))
    data
  }
)

#' @rdname ssdtools-ggproto
#' @export
GeomSsdpoint <- ggproto(
  "GeomSsdpoint", GeomPoint
)

#' @rdname ssdtools-ggproto
#' @export
GeomSsdsegment <- ggproto(
  "GeomSsdsegment", GeomSegment
)

#' @rdname ssdtools-ggproto
#' @export
GeomHcintersect <- ggproto(
  "GeomHcintersect", Geom,
  required_aes = c("xintercept", "yintercept"),
  default_aes = aes(colour = "black", linewidth = 0.5, linetype = "dotted", alpha = NA),
  draw_key = draw_key_path,
  draw_panel = function(data, panel_params, coord) {
    data$group <- seq_len(nrow(data))
    data$x <- data$xintercept
    data$y <- data$yintercept
    start <- data
    start$x <- 0.0001
    end <- data
    end$y <- -Inf

    data <- rbind(start, data, end)
    GeomPath$draw_panel(data, panel_params, coord)
  }
)

#' @rdname ssdtools-ggproto
#' @export
GeomXribbon <- ggproto(
  "GeomXribbon", Geom,
  required_aes = c("y", "xmin", "xmax"),
  default_aes = aes(
    colour = NA, fill = "grey20", linewidth = 0.5, linetype = 1, alpha = NA
  ),
  draw_key = draw_key_polygon,
  handle_na = function(data, params) {
    data
  },
  draw_group = function(data, panel_params, coord, na.rm = FALSE) {
    if (na.rm) data <- data[complete.cases(data[c("y", "xmin", "xmax")]), ]
    data <- data[order(data$group, data$y), ]

    # Check that aesthetics are constant
    aes <- unique(data[c("colour", "fill", "linewidth", "linetype", "alpha")])
    if (nrow(aes) > 1) {
      err("Aesthetics can not vary with a ribbon.")
    }
    aes <- as.list(aes)

    missing_pos <- !complete.cases(data[c("y", "xmin", "xmax")])
    ids <- cumsum(missing_pos) + 1
    ids[missing_pos] <- NA

    positions <- plyr::summarise(data,
      y = c(y, rev(y)), x = c(xmax, rev(xmin)), id = c(ids, rev(ids))
    )
    munched <- coord_munch(coord, positions, panel_params)

    ggname("geom_ribbon", polygonGrob(
      munched$x, munched$y,
      id = munched$id,
      default.units = "native",
      gp = gpar(
        fill = alpha(aes$fill, aes$alpha),
        col = aes$colour,
        lwd = aes$linewidth * .pt,
        lty = aes$linetype
      )
    ))
  }
)
