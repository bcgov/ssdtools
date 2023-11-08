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

#' @export
ggplot2::waiver

plot_coord_scale <- function(data, xlab, ylab, xbreaks = waiver()) {
  chk_string(xlab)
  chk_string(ylab)

  if (is.waive(xbreaks)) {
    xbreaks <- trans_breaks("log10", function(x) 10^x)
  }

  list(
    coord_trans(x = "log10"),
    scale_x_continuous(xlab,
      breaks = xbreaks,
      labels = comma_signif
    ),
    scale_y_continuous(ylab,
      labels = percent, limits = c(0, 1),
      breaks = seq(0, 1, by = 0.2), expand = c(0, 0)
    )
  )
}

#' Plot Species Sensitivity Data and Distributions
#'
#' Plots species sensitivity data and distributions.
#'
#' @inheritParams params
#' @param shape A string of the column in data for the shape aesthetic.
#' @seealso [`ssd_plot_cdf()`] and [`geom_ssdpoint()`]
#' @export
#' @examples
#' ssd_plot(ssddata::ccme_boron, boron_pred, label = "Species", shape = "Group")
ssd_plot <- function(data, pred, left = "Conc", right = left,
                     label = NULL, shape = NULL, color = NULL, size = 2.5,
                     linetype = NULL, linecolor = NULL,
                     xlab = "Concentration", ylab = "Species Affected",
                     ci = TRUE, ribbon = FALSE, hc = 5L, shift_x = 3,
                     bounds = c(left = 1, right = 1),
                     xbreaks = waiver()) {
  .chk_data(data, left, right, weight = NULL, missing = TRUE)
  chk_null_or(label, vld = vld_string)
  chk_null_or(shape, vld = vld_string)
  chk_null_or(color, vld = vld_string)
  chk_null_or(linetype, vld = vld_string)
  chk_null_or(linecolor, vld = vld_string)
  check_names(data, c(unique(c(left, right)), label, shape))

  check_names(pred, c("percent", "est", "lcl", "ucl", unique(c(linetype, linecolor))))
  chk_whole_numeric(pred$percent)
  chk_range(pred$percent, c(1, 99))
  check_data(pred, values = list(est = 1, lcl = c(1, NA), ucl = c(1, NA)))

  chk_number(shift_x)
  chk_range(shift_x, c(1, 1000))

  chk_flag(ci)
  chk_flag(ribbon)

  if (!is.null(hc)) {
    chk_vector(hc)
    chk_whole_numeric(hc)
    chk_gt(length(hc))
    chk_subset(hc, pred$percent)
  }
  .chk_bounds(bounds)

  pred$percent <- pred$percent / 100

  data <- process_data(data, left, right, weight = NULL)
  data <- bound_data(data, bounds)
  data$y <- ssd_ecd_data(data, "left", "right", bounds = bounds)

  label <- if (!is.null(label)) sym(label) else label
  shape <- if (!is.null(shape)) sym(shape) else shape
  color <- if (!is.null(color)) sym(color) else color
  linetype <- if (!is.null(linetype)) sym(linetype) else linetype
  linecolor <- if (!is.null(linecolor)) sym(linecolor) else linecolor

  gp <- ggplot(data)

  if (ci) {
    if (ribbon) {
      gp <- gp + geom_xribbon(data = pred, aes(xmin = !!sym("lcl"), xmax = !!sym("ucl"), y = !!sym("percent")), alpha = 0.2)
    } else {
      gp <- gp +
        geom_line(data = pred, aes(x = !!sym("lcl"), y = !!sym("percent")), color = "darkgreen") +
        geom_line(data = pred, aes(x = !!sym("ucl"), y = !!sym("percent")), color = "darkgreen")
    }
  }

  if (!is.null(linecolor)) {
    gp <- gp + geom_line(data = pred, aes(x = !!sym("est"), y = !!sym("percent"), linetype = !!linetype, color = !!linecolor))
  } else if (ribbon) {
    gp <- gp + geom_line(data = pred, aes(x = !!sym("est"), y = !!sym("percent"), linetype = !!linetype), color = "black")
  } else {
    gp <- gp + geom_line(data = pred, aes(x = !!sym("est"), y = !!sym("percent"), linetype = !!linetype), color = "red")
  }

  if (!is.null(hc)) {
    gp <- gp + geom_hcintersect(
      data = pred[round(pred$percent * 100) %in% hc, ],
      aes(xintercept = !!sym("est"), yintercept = !!sym("percent"))
    )
  }

  if (!is.null(color)) {
    gp <- gp +
      geom_ssdpoint(data = data, aes(
        x = !!sym("left"), y = !!sym("y"), shape = !!shape,
        color = !!color
      ), stat = "identity") +
      geom_ssdpoint(data = data, aes(
        x = !!sym("right"), y = !!sym("y"), shape = !!shape,
        color = !!color
      ), stat = "identity") +
      geom_ssdsegment(
        data = data, aes(
          x = !!sym("left"), y = !!sym("y"), xend = !!sym("right"), yend = !!sym("y"),
          color = !!color
        ),
        stat = "identity"
      )
  } else {
    gp <- gp +
      geom_ssdpoint(
        data = data, aes(
          x = !!sym("left"), y = !!sym("y"), shape = !!shape
        ),
        stat = "identity"
      ) +
      geom_ssdpoint(data = data, aes(
        x = !!sym("right"), y = !!sym("y"), shape = !!shape
      ), stat = "identity") +
      geom_ssdsegment(data = data, aes(
        x = !!sym("left"), y = !!sym("y"), xend = !!sym("right"), yend = !!sym("y")
      ), stat = "identity")
  }

  gp <- gp + plot_coord_scale(data, xlab = xlab, ylab = ylab, xbreaks = xbreaks)

  if (!is.null(label)) {
    data$right <- data$right * shift_x
    gp <- gp + geom_text(
      data = data, aes(x = !!sym("right"), y = !!sym("y"), label = !!label),
      hjust = 0, size = size, fontface = "italic"
    )
  }

  gp
}
