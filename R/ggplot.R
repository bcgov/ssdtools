#    Copyright 2015 Province of British Columbia
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

#' Plot Species Sensitivity Data
#'
#' Uses the empirical cumulative density/distribution to visualize species sensitivity data.
#'
#' @inheritParams ggplot2::layer
#' @inheritParams ggplot2::geom_point
#' @seealso [geom_ssd()] and [ssd_plot_cdf()]
#' @export
#' @examples
#' ggplot2::ggplot(boron_data, ggplot2::aes(x = Conc)) +
#'   stat_ssd()
stat_ssd <- function(mapping = NULL, data = NULL, geom = "point",
                     position = "identity", na.rm = FALSE, show.legend = NA,
                     inherit.aes = TRUE, ...) {
  layer(
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
#' @seealso [geom_ssd()] and [ssd_plot_cdf()]
#' @export
#' @examples
#' ggplot2::ggplot(boron_data, ggplot2::aes(x = Conc, xend = Conc * 2)) +
#'   stat_ssd()
stat_ssdcens <- function(mapping = NULL, data = NULL, geom = "ssdcens",
                     position = "identity", na.rm = FALSE, show.legend = NA,
                     inherit.aes = TRUE, ...) {
  layer(
    stat = StatSsdcens, data = data, mapping = mapping, geom = geom,
    position = position, show.legend = show.legend, inherit.aes = inherit.aes,
    params = list(na.rm = na.rm, ...)
  )
}

#' Ribbons Plot
#'
#' For each y value, `geom_xribbon` displays an x interval defined
#' by `xmin` and `xmax`.
#'
#' @inheritParams ggplot2::layer
#' @inheritParams ggplot2::geom_point
#' @family ggplot
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
#' @seealso [ssd_plot_cdf()]
#' @family ggplot
#' @export
#' @examples
#' ggplot2::ggplot(boron_data, ggplot2::aes(x = Conc)) +
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

#' Plot Censored Species Sensitivity Data
#'
#' Uses the empirical cumulative density/distribution to visualize species sensitivity data.
#'
#' @inheritParams ggplot2::layer
#' @inheritParams ggplot2::geom_segment
#' @seealso [ssd_plot_cdf()]
#' @family ggplot
#' @export
#' @examples
#' ggplot2::ggplot(boron_data, ggplot2::aes(x = Conc, xend = Conc * 2)) +
#'   geom_ssdcens()
geom_ssdcens <- function(mapping = NULL, data = NULL, stat = "ssdcens",
                     position = "identity", na.rm = FALSE, show.legend = NA,
                     inherit.aes = TRUE, 
                     lineend = "butt",
                     ...) {
  layer(
    geom = GeomSsdcens, data = data, mapping = mapping, stat = stat,
    position = position, show.legend = show.legend, inherit.aes = inherit.aes,
    params = list(lineend = lineend, na.rm = na.rm, ...)
  )
}

#' Hazard Concentration Intersection
#'
#' For each x and y value, `geom_hcintersect()` plots the intersection.
#'
#' @inheritParams ggplot2::layer
#' @inheritParams ggplot2::geom_path
#' @inheritParams params
#' @family ggplot
#' @export
#' @examples
#' ggplot2::ggplot(boron_data, ggplot2::aes(x = Conc)) +
#'   geom_ssd() +
#'   geom_hcintersect(xintercept = 1.5, yintercept = 0.05)
geom_hcintersect <- function(mapping = NULL, data = NULL, xintercept, yintercept,
                             na.rm = FALSE, show.legend = NA, ...) {
  if (!missing(xintercept)) {
    data <- data.frame(xintercept = xintercept)
    mapping <- aes(xintercept = xintercept)
    show.legend <- FALSE
  }
  
  if (!missing(yintercept)) {
    if (!missing(xintercept)) {
      data$yintercept <- yintercept
      mapping$yintercept <- yintercept
    } else {
      data <- data.frame(yintercept = yintercept)
      mapping <- aes(yintercept = yintercept)
    }
    show.legend <- FALSE
  }
  
  layer(
    geom = GeomHcintersect, data = data, mapping = mapping, stat = StatIdentity,
    position = PositionIdentity, show.legend = show.legend, inherit.aes = FALSE,
    params = list(na.rm = na.rm, ...)
  )
}
