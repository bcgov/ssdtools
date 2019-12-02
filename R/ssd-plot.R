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

#' SSD Plot
#' @inheritParams ssd_plot_cdf.fitdist
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
#' @param ci A flag specifying whether to plot confidence intervals.
#' @param hc A count between 1 and 99 indicating the percent hazard concentration (or NULL).
#' @export
#' @examples
#' ssd_plot(boron_data, boron_pred, label = "Species", shape = "Group")
ssd_plot <- function(data, pred, left = "Conc", right = left,
                     label = NULL, shape = NULL, color = NULL, size = 2.5,
                     xlab = "Concentration", ylab = "Percent of Species Affected",
                     ci = TRUE, ribbon = FALSE, hc = 5L, shift_x = 3) {
  chk_s3_class(data, "data.frame")
  chk_s3_class(pred, "data.frame")
  chk_superset(colnames(pred), c("percent", "est", "lcl", "ucl"))
  chk_numeric(pred$percent)
  chk_range(pred$percent, c(1, 99))
  chk_numeric(pred$est)
  chk_numeric(pred$lcl)
  chk_numeric(pred$ucl)

  chk_number(shift_x)
  chk_range(shift_x, c(1, 1000))

  chk_string(left)
  chk_string(right)
  if (!is.null(label)) chk_string(label)
  if (!is.null(shape)) chk_string(shape)
  chk_flag(ci)
  chk_flag(ribbon)
  if (!is.null(hc)) {
    chk_vector(hc)
    chk_numeric(hc)
    chk_gt(length(hc))
    chk_subset(hc, pred$percent)
  }

  chk_superset(colnames(data), c(left, right, label, shape))

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
    chk_superset(colnames(data), label)
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
