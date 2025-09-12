# Copyright 2015-2023 Province of British Columbia
# Copyright 2021 Environment and Climate Change Canada
# Copyright 2023-2024 Australian Government Department of Climate Change,
# Energy, the Environment and Water
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

plot_coord_scale <- function(data, xlab, ylab, trans, big.mark, suffix, xbreaks = waiver(), xlimits = NULL, hc_value = NULL) {
  chk_string(xlab)
  chk_string(ylab)

  if (is.waive(xbreaks)) {
    xbreaks <- switch(trans,
      "log10" = function(x) unique(c(scales::log10_trans()$breaks(x), hc_value)),
      "log" = function(x) unique(c(scales::log_trans()$breaks(x), hc_value)),
      "identity" = function(x) unique(c(scales::identity_trans()$breaks(x), hc_value))
    )
  } else {
    xbreaks <- unique(c(xbreaks, hc_value))
  }

  ssd_label_fun <- ssd_label_comma(big.mark = big.mark)
  if (!is.null(hc_value)) {
    ssd_label_fun <- ssd_label_comma_hc(hc_value, big.mark = big.mark)
  }

  list(
    coord_transform(x = trans),
    scale_x_continuous(xlab,
      breaks = xbreaks,
      minor_breaks = NULL,
      labels = ssd_label_fun,
      limits = xlimits
    ),
    scale_y_continuous(ylab,
      labels = label_percent(suffix = suffix), limits = c(0, 1),
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
ssd_plot <- function(data, pred, left = "Conc", right = left, ...,
                     label = NULL, shape = NULL, color = NULL, size,
                     linetype = NULL, linecolor = NULL,
                     xlab = "Concentration", ylab = "Species Affected",
                     ci = TRUE, ribbon = TRUE, hc = 0.05,
                     shift_x = 3, add_x = 0,
                     bounds = c(left = 1, right = 1),
                     big.mark = ",", suffix = "%",
                     trans = "log10", xbreaks = waiver(),
                     xlimits = NULL, text_size = 11, label_size = 2.5,
                     theme_classic = FALSE) {
  if (lifecycle::is_present(size)) {
    lifecycle::deprecate_soft("2.1.0", "ssd_plot(size)", "ssd_plot(label_size)", id = "size")
    chk_number(size)
    label_size <- size
  }
  .chk_data(data, left, right, weight = NULL, missing = TRUE)
  chk_unused(...)
  chk_null_or(label, vld = vld_string)
  chk_null_or(shape, vld = vld_string)
  chk_null_or(color, vld = vld_string)
  chk_null_or(linetype, vld = vld_string)
  chk_null_or(linecolor, vld = vld_string)
  check_names(data, c(unique(c(left, right)), label, shape))

  check_names(pred, c("proportion", "est", "lcl", "ucl", unique(c(linetype, linecolor))))
  chk_numeric(pred$proportion)
  chk_range(pred$proportion)
  check_data(pred, values = list(est = 1, lcl = c(1, NA), ucl = c(1, NA)))

  chk_number(shift_x)
  chk_range(shift_x, c(1, 1000))
  chk_number(add_x)
  chk_range(add_x, c(-1000, 1000))

  chk_flag(ci)
  chk_flag(ribbon)

  if (!is.null(hc)) {
    chk_vector(hc)
    chk_gt(length(hc))
    chk_subset(hc, pred$proportion)
  }
  chk_string(big.mark)
  chk_string(suffix)
  .chk_bounds(bounds)
  chk_subset(trans, c("log10", "log", "identity"))
  chk_number(text_size)
  chk_null_or(xlimits, vld = vld_numeric)
  chk_null_or(xlimits, vld = vld_length, length = 2L)
  chk_flag(theme_classic)

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
      gp <- gp + geom_xribbon(data = pred, aes(xmin = !!sym("lcl"), xmax = !!sym("ucl"), y = !!sym("proportion")), alpha = 0.2)
    } else {
      gp <- gp +
        geom_line(data = pred, aes(x = !!sym("lcl"), y = !!sym("proportion")), color = "darkgreen") +
        geom_line(data = pred, aes(x = !!sym("ucl"), y = !!sym("proportion")), color = "darkgreen")
    }
  }

  if (!is.null(linecolor)) {
    gp <- gp + geom_line(data = pred, aes(x = !!sym("est"), y = !!sym("proportion"), linetype = !!linetype, color = !!linecolor))
  } else if (ribbon) {
    gp <- gp + geom_line(data = pred, aes(x = !!sym("est"), y = !!sym("proportion"), linetype = !!linetype), color = "black")
  } else {
    gp <- gp + geom_line(data = pred, aes(x = !!sym("est"), y = !!sym("proportion"), linetype = !!linetype), color = "red")
  }

  if (!is.null(hc)) {
    gp <- gp + geom_hcintersect(
      data = pred[pred$proportion %in% hc, ],
      aes(xintercept = !!sym("est"), yintercept = !!sym("proportion"))
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

  hc_value <- NULL
  if (!is.null(hc)) {
    hc_value <- pred$est[pred$proportion %in% hc]
  }
  gp <- gp + plot_coord_scale(data,
    xlab = xlab, ylab = ylab, big.mark = big.mark, suffix = suffix,
    trans = trans, xbreaks = xbreaks, xlimits = xlimits, hc_value = hc_value
  )

  if (!is.null(label)) {
    data$right <- (data$right + add_x) * shift_x
    gp <- gp + geom_text(
      data = data, aes(x = !!sym("right"), y = !!sym("y"), label = !!label),
      hjust = 0, size = label_size, fontface = "italic"
    )
  }

  if (theme_classic) {
    gp <- gp + ggplot2::theme_classic()
  }

  gp <- gp +
    theme(
      text = element_text(size = text_size),
      axis.text.x = ggtext::element_markdown()
    )

  gp
}
