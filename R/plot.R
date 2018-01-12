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
    data.frame(x = pred$est, density = pred$prop)
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
GeomHc5 <- ggproto("GeomHc5", Geom,
  draw_panel = function(data, panel_params, coord) {

    pieces <- data.frame(x = c(0.0001, data$xintercept, data$xintercept),
                         y = c(0.05, 0.05, -Inf))

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

#' Plot Species Sensitivy Data
#'
#' Uses the empirical cumulative density/distribution to visualize species sensitivity data.
#'
#' @inheritParams ggplot2::layer
#' @inheritParams ggplot2::geom_point
#' @seealso \code{\link{geom_ssd}}
#' @export
#' @examples
#' ggplot2::ggplot(boron_data, ggplot2::aes(x = Conc)) +
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
#' ggplot2::ggplot(boron_data, ggplot2::aes(x = Conc)) +
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
#' ggplot2::ggplot(boron_data, ggplot2::aes(x = Conc)) +
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
#' For each x value, `geom_hc5` displays the fifth percentile.
#'
#' @inheritParams ggplot2::layer
#' @inheritParams ggplot2::geom_path
#' @param xintercept The x-value for the fifth percentil..
#' @export
#' @examples
#' ggplot2::ggplot(boron_data, ggplot2::aes(x = Conc)) +
#'   geom_ssd() +
#'   geom_hc5(xintercept = 1.5)
geom_hc5 <- function(mapping = NULL, data = NULL, xintercept,
                    na.rm = FALSE, show.legend = NA, ...) {

  if (!missing(xintercept)) {
    data <- data.frame(xintercept = xintercept)
    mapping <- aes(xintercept = xintercept)
    show.legend <- FALSE
  }

  layer(
    geom = GeomHc5,  data = data, mapping = mapping, stat = StatIdentity,
    position = PositionIdentity, show.legend = show.legend, inherit.aes = FALSE,
    params = list(na.rm = na.rm, ...)
  )
}


plot_fitdist <- function(x, breaks = "default", ...) {
  par(oma=c(0,0,2,0))
  plot(x, breaks = breaks, ...)
  title(paste("Distribution:", x$distname), outer = TRUE)
}

#' @export
plot.fitdists <- function(x, breaks = "default", ...) {
  walk(x, plot_fitdist, breaks = breaks, ...)
  invisible()
}

#' Autoplot
#'
#' @param object The object to plot.
#' @param ci A flag indicating wether to plot confidence intervals
#' @param hc5 A flag indicating whether to plot the HC5.
#' @param xlab A string of the x-axis label.
#' @param ylab A string of the x-axis label.
#' @param ... Unused.
#' @export
#' @examples
#' autoplot(boron_lnorm)
autoplot.fitdist <- function(object, ci = FALSE, hc5 = TRUE,
                             xlab = "Concentration", ylab = "Species Affected",
                             ...) {
  check_flag(ci)
  check_flag(hc5)
  check_string(xlab)
  check_string(ylab)

  data <- data.frame(x = object$data)

  pred <- predict(object, nboot = if(ci) 1001 else 10)

  gp <- ggplot(pred, aes_string(x = "est"))

  if(ci) gp <- gp + geom_xribbon(aes_string(xmin = "lcl", xmax = "ucl", y = "prop"), alpha = 0.3)

  gp <- gp + geom_line(aes_string(y = "prop")) +
    geom_ssd(data = data, aes_string(x = "x")) +
    plot_coord_scale(data, xlab = xlab, ylab = ylab)

  if(hc5) gp <- gp + geom_hc5(xintercept = pred$est[pred$prop == 0.05], linetype = "dotted")
  gp
}

#' Autoplot
#'
#' @inheritParams autoplot.fitdist
#' @export
#' @examples
#' \dontrun{
#' autoplot(boron_dists)
#' }
autoplot.fitdists <- function(object, xlab = "Concentration", ylab = "Species Affected", ...) {
  check_string(xlab)
  check_string(ylab)

  pred <- predict(object, nboot = 10, average = FALSE)
  pred$Distribution <- pred$dist

  data <- data.frame(x = object[[1]]$data)

  gp <- ggplot(pred, aes_string(x = "est")) +
    geom_line(aes_string(y = "prop", color = "Distribution",
                         linetype = "Distribution")) +
    geom_ssd(data = data, aes_string(x = "x")) +
    plot_coord_scale(data, xlab = xlab, ylab = ylab)

  gp
}

#' SSD Plot
#' @inheritParams autoplot.fitdist
#' @param data A data frame.
#' @param pred A data frame of the predictions.
#' @param left A string of the column in data with the concentrations.
#' @param label A string of the column in data with the labels.
#' @param shape A string of the column in data for the shape aesthetic.
#' @param color A string of the column in data for the color aesthetic.
#' @param size A number for the size of the labels.
#' @param shift_x The value to multiply the label x values by.
#' @export
#' @examples
#' ssd_plot(boron_data, boron_pred, label = "Species", shape = "Group")
ssd_plot <- function(data, pred, left = "Conc",
                     label = NULL, shape = NULL, color = NULL, size = 2.5,
                     xlab = "Concentration", ylab = "Percent of Species Affected",
                     ci = TRUE, hc5 = TRUE, shift_x = 3) {
  check_data(data)
  check_data(pred,
             values = list(
               prop = c(0,1),
               est = 1,
               lcl = 1,
               ucl = 1))

  check_vector(shift_x, values = c(1, 1000))

  check_string(left)
  checkor(check_string(label), check_null(label))
  checkor(check_string(shape), check_null(shape))
  check_flag(ci)
  check_flag(hc5)

  check_colnames(data, left)

  gp <- ggplot(pred, aes_string(x = "est"))

  if(ci) gp <- gp + geom_xribbon(aes_string(xmin = "lcl", xmax = "ucl", y = "prop"), alpha = 0.2)

  if(!is.null(label)) {
    check_colnames(data, label)
    data <- data[order(data[[label]]),]
  }
  gp <- gp + geom_line(aes_string(y = "prop")) +
    geom_hc5(data = data, xintercept = pred$est[pred$prop == 0.05]) +
    geom_ssd(data = data, aes_string(x = left, shape = shape, color = color)) +
    plot_coord_scale(data, xlab = xlab, ylab = ylab)

  if(!is.null(label)) {
    data$prop <- ssd_ecd(data[[left]])
    data[[left]] %<>% magrittr::multiply_by(shift_x)
    gp <- gp + geom_text(data = data, aes_string(x = left, y = "prop", label = label),
                         color = "grey50", hjust = 0, size = size)
  }

  gp
}

#' Cullen and Frey Plot
#'
#' Plots a Cullen and Frey graph of the skewness and kurtosis
#'
#' @inheritParams ssd_fit_dist
#' @seealso \code{\link[fitdistrplus]{descdist}}
#' @export
#'
#' @examples
#' ssd_cfplot(boron_data)
ssd_cfplot <- function(data, left = "Conc") {
  check_data(data)
  check_string(left)
  check_colnames(data, left)

  fitdistrplus::descdist(data[[left]], boot = 100L)
  invisible()
}
