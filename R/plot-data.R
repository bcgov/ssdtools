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

#' Plot Species Sensitivity Data
#'
#' Plots species sensitivity data.
#'
#' @inheritParams params
#' @param shape A string of the column in data for the shape aesthetic.
#' @seealso [`ssd_plot()`] and [`geom_ssdpoint()`]
#' @export
#' @examples
#' ssd_plot_data(ssddata::ccme_boron, label = "Species", shape = "Group")
ssd_plot_data <- function(data, left = "Conc", right = left,
                          label = NULL, shape = NULL, color = NULL, size = 2.5,
                          xlab = "Concentration", ylab = "Species Affected",
                          shift_x = 3,
                          bounds = c(left = 1, right = 1),
                          xbreaks = waiver()) {
  .chk_data(data, left, right, weight = NULL, missing = TRUE)
  chk_null_or(label, vld = vld_string)
  chk_null_or(shape, vld = vld_string)
  check_names(data, c(unique(c(left, right)), label, shape))

  chk_number(shift_x)
  chk_range(shift_x, c(1, 1000))

  .chk_bounds(bounds)

  data <- process_data(data, left, right, weight = NULL)
  data <- bound_data(data, bounds)
  data$y <- ssd_ecd_data(data, "left", "right", bounds = bounds)

  label <- if (!is.null(label)) sym(label) else label
  shape <- if (!is.null(shape)) sym(shape) else shape
  color <- if (!is.null(color)) sym(color) else color

  gp <- ggplot(data)

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
