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
      stop("Aesthetics can not vary with a ribbon")
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

plot_coord_scale <- function(data, xlab, ylab) {
  chk_string(xlab)
  chk_string(ylab)

  list(
    coord_trans(x = "log10"),
    scale_x_continuous(xlab,
      breaks = scales::trans_breaks("log10", function(x) 10^x),
      labels = comma_signif
    ),
    scale_y_continuous(ylab,
      labels = scales::percent, limits = c(0, 1),
      breaks = seq(0, 1, by = 0.2), expand = c(0, 0)
    )
  )
}

#' Plot Species Sensitivity Data
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
  layer(
    stat = StatSsd, data = data, mapping = mapping, geom = geom,
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

#' Hazard Concentration Intersection
#'
#' For each x and y value, `geom_hcintersect()` plots the intersection.
#'
#' @inheritParams ggplot2::layer
#' @inheritParams ggplot2::geom_path
#' @param xintercept The x-value for the intersect
#' @param yintercept The y-value for the intersect.
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

plot_fitdist <- function(x, breaks = "default", ...) {
  graphics::par(oma = c(0, 0, 2, 0))
  graphics::plot(x, breaks = breaks, ...)
  graphics::title(paste("Distribution:", x$distname), outer = TRUE)
}

#' @export
plot.fitdists <- function(x, breaks = "default", ...) {
  lapply(x, plot_fitdist, breaks = breaks, ...)
  invisible()
}

#' Autoplot
#'
#' @param object The object to plot.
#' @param ci A flag indicating whether to plot confidence intervals
#' @param hc A count between 1 and 99 indicating the percent hazard concentration to plot (or NULL).
#' @param xlab A string of the x-axis label.
#' @param ylab A string of the x-axis label.
#' @param ... Unused.
#' @export
#' @examples
#' ggplot2::autoplot(boron_lnorm)
autoplot.fitdist <- function(object, ci = FALSE, hc = 5L,
                             xlab = "Concentration", ylab = "Species Affected",
                             ...) {
  chk_flag(ci)
  checkor(check_null(hc), check_scalar(hc, c(1L, 99L)))
  chk_string(xlab)
  chk_string(ylab)

  data <- data.frame(x = object$data)

  pred <- predict(object, nboot = if (ci) 1001 else 10)

  gp <- ggplot(pred, aes_string(x = "est"))

  if (ci) gp <- gp + geom_xribbon(aes_string(xmin = "lcl", xmax = "ucl", y = "percent"), alpha = 0.3)

  gp <- gp + geom_line(aes_string(y = "percent")) +
    geom_ssd(data = data, aes_string(x = "x")) +
    plot_coord_scale(data, xlab = xlab, ylab = ylab)

  if (!is.null(hc)) gp <- gp + geom_hcintersect(xintercept = pred$est[pred$percent == hc], yintercept = hc / 100, linetype = "dotted")
  gp
}

#' Autoplot
#'
#' @inheritParams autoplot.fitdist
#' @export
#' @examples
#' fluazinam_lnorm$censdata$right[3] <- fluazinam_lnorm$censdata$left[3] * 1.5
#' fluazinam_lnorm$censdata$left[5] <- NA
#' ggplot2::autoplot(fluazinam_lnorm)
autoplot.fitdistcens <- function(object, ci = FALSE, hc = 5L,
                                 xlab = "Concentration", ylab = "Species Affected",
                                 ...) {
  chk_flag(ci)
  checkor(check_null(hc), check_scalar(hc, c(1L, 99L)))
  chk_string(xlab)
  chk_string(ylab)

  data <- object$censdata

  data$xmin <- pmin(data$left, data$right, na.rm = TRUE)
  data$xmax <- pmax(data$left, data$right, na.rm = TRUE)
  data$xmean <- rowMeans(data[c("left", "right")], na.rm = TRUE)
  data$arrowleft <- data$right / 2
  data$arrowright <- data$left * 2
  data$y <- ssd_ecd(data$xmean)

  pred <- predict(object, nboot = if (ci) 1001 else 10)

  gp <- ggplot(pred, aes_string(x = "est"))

  if (ci) gp <- gp + geom_xribbon(aes_string(xmin = "lcl", xmax = "ucl", y = "percent"), alpha = 0.3)

  arrow <- arrow(length = unit(0.1, "inches"))

  gp <- gp + geom_line(aes_string(y = "percent")) +
    geom_segment(
      data = data[data$xmin != data$xmax, ],
      aes_string(x = "xmin", xend = "xmax", y = "y", yend = "y")
    ) +
    geom_segment(
      data = data[is.na(data$left), ],
      aes_string(x = "right", xend = "arrowleft", y = "y", yend = "y"),
      arrow = arrow
    ) +
    geom_segment(
      data = data[is.na(data$right), ],
      aes_string(x = "left", xend = "arrowright", y = "y", yend = "y"),
      arrow = arrow
    ) +
    geom_point(data = data, aes_string(x = "xmin", y = "y")) +
    geom_point(
      data = data[data$xmin != data$xmax, ],
      aes_string(x = "xmax", y = "y")
    ) +
    plot_coord_scale(data, xlab = xlab, ylab = ylab)

  if (!is.null(hc)) gp <- gp + geom_hcintersect(xintercept = pred$est[pred$percent == hc], yintercept = hc / 100, linetype = "dotted")
  gp
}

#' Autoplot
#'
#' @inheritParams autoplot.fitdist
#' @inheritParams predict.fitdists
#' @export
#' @examples
#' \dontrun{
#' ggplot2::autoplot(boron_dists)
#' }
autoplot.fitdists <- function(object, xlab = "Concentration", ylab = "Species Affected", ic = "aicc", ...) {
  chk_string(xlab)
  chk_string(ylab)

  pred <- predict(object, ic = ic, nboot = 10, average = FALSE)
  pred$Distribution <- pred$dist

  data <- data.frame(x = object[[1]]$data)

  gp <- ggplot(pred, aes_string(x = "est")) +
    geom_line(aes_string(
      y = "percent/100", color = "Distribution",
      linetype = "Distribution"
    )) +
    geom_ssd(data = data, aes_string(x = "x")) +
    plot_coord_scale(data, xlab = xlab, ylab = ylab)

  gp
}

#' Autoplot
#'
#' @inheritParams autoplot.fitdist
#' @inheritParams predict.fitdists
#' @export
#' @examples
#' \dontrun{
#' ggplot2::autoplot(boron_dists)
#' }
autoplot.fitdistscens <- function(object, xlab = "Concentration", ylab = "Species Affected",
                                  ic = "aic", ...) {
  NextMethod(object = object, xlab = xlab, ylab = ylab, ic = ic, ...)
}

#' SSD Plot
#' @inheritParams autoplot.fitdist
#' @param data A data frame.
#' @param pred A data frame of the predictions.
#' @param left A string of the column in data with the concentrations.
#' @param right A string of the column in data with the right concentration values.
#' @param label A string of the column in data with the labels.
#' @param shape A string of the column in data for the shape aesthetic.
#' @param color A string of the column in data for the color aesthetic.
#' @param size A number for the size of the labels.
#' @param ribbon A flag indicating whether to plot the confidence interval as a grey ribbon as opposed to green solid lines.
#' @param shift_x The value to multiply the label x values by.
#' @export
#' @examples
#' ssd_plot(boron_data, boron_pred, label = "Species", shape = "Group")
ssd_plot <- function(data, pred, left = "Conc", right = left,
                     label = NULL, shape = NULL, color = NULL, size = 2.5,
                     xlab = "Concentration", ylab = "Percent of Species Affected",
                     ci = TRUE, ribbon = FALSE, hc = 5L, shift_x = 3) {
  check_data(data)
  check_data(pred,
    values = list(
      percent = 1:99,
      est = 1,
      lcl = 1,
      ucl = 1
    )
  )

  check_vector(shift_x, values = c(1, 1000))

  chk_string(left)
  chk_string(right)
  checkor(check_string(label), check_null(label))
  checkor(check_string(shape), check_null(shape))
  chk_flag(ci)
  chk_flag(ribbon)
  checkor(check_null(hc), check_vector(hc, pred$percent, only = TRUE, length = TRUE))

  check_colnames(data, unique(c(left, right, label, shape)))

  gp <- ggplot(pred, aes_string(x = "est"))

  if (ci) {
    if (ribbon) {
      gp <- gp + geom_xribbon(aes_string(xmin = "lcl", xmax = "ucl", y = "percent/100"), alpha = 0.2)
    } else {
      gp <- gp +
        geom_line(aes_string(x = "lcl", y = "percent/100"), color = "darkgreen") +
        geom_line(aes_string(x = "ucl", y = "percent/100"), color = "darkgreen")
    }
  }
  if (!is.null(label)) {
    check_colnames(data, label)
    data <- data[order(data[[label]]), ]
  }
  gp <- gp + geom_line(aes_string(y = "percent/100"), color = if (ribbon) "black" else "red")

  if (!is.null(hc)) {
    gp <- gp + geom_hcintersect(data = data, xintercept = pred$est[pred$percent %in% hc], yintercept = hc / 100)
  }

  if (left == right) {
    gp <- gp + geom_ssd(data = data, aes_string(
      x = left, shape = shape,
      color = color
    ))
  } else {
    data$xmin <- pmin(data$left, data$right, na.rm = TRUE)
    data$xmax <- pmax(data$left, data$right, na.rm = TRUE)
    data$xmean <- rowMeans(data[c("left", "right")], na.rm = TRUE)
    data$arrowleft <- data$right / 2
    data$arrowright <- data$left * 2
    data$y <- ssd_ecd(data$xmean)

    arrow <- arrow(length = unit(0.1, "inches"))

    gp <- gp + geom_line(aes_string(y = "percent")) +
      geom_segment(
        data = data[data$xmin != data$xmax, ],
        aes_string(x = "xmin", xend = "xmax", y = "y", yend = "y")
      ) +
      geom_segment(
        data = data[is.na(data$left), ],
        aes_string(x = "right", xend = "arrowleft", y = "y", yend = "y"),
        arrow = arrow
      ) +
      geom_segment(
        data = data[is.na(data$right), ],
        aes_string(x = "left", xend = "arrowright", y = "y", yend = "y"),
        arrow = arrow
      ) +
      geom_point(data = data, aes_string(x = "xmin", y = "y")) +
      geom_point(
        data = data[data$xmin != data$xmax, ],
        aes_string(x = "xmax", y = "y")
      )
  }
  gp <- gp + plot_coord_scale(data, xlab = xlab, ylab = ylab)

  if (!is.null(label)) {
    data$percent <- ssd_ecd(data[[left]])
    data[[left]] <- data[[left]] * shift_x
    gp <- gp + geom_text(
      data = data, aes_string(x = left, y = "percent", label = label),
      hjust = 0, size = size, fontface = "italic"
    )
  }

  gp
}

#' Cullen and Frey Plot
#'
#' Plots a Cullen and Frey graph of the skewness and kurtosis
#' for non-censored data.
#'
#' @inheritParams ssd_fit_dists
#' @seealso \code{\link[fitdistrplus]{descdist}}
#' @export
#'
#' @examples
#' ssd_plot_cf(boron_data)
ssd_plot_cf <- function(data, left = "Conc") {
  check_data(data)
  chk_string(left)
  check_colnames(data, left)

  fitdistrplus::descdist(data[[left]], boot = 100L)
  invisible()
}
