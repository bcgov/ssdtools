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


test_that("ssd_pal is function", {
  expect_true(chk::vld_function(ssd_pal()))
})

test_that("scale_colour_ssd is ggproto", {
  expect_true(ggplot2::is.ggproto(scale_colour_ssd()))
})

test_that("scale_color_ssd is ggproto", {
  color <- scale_color_ssd()
  colour <- scale_colour_ssd()
  expect_output(expect_identical(str(color), str(colour)))
})

test_that("stat_ssd deprecated", {
  lifecycle::expect_defunct(ggplot2::ggplot(ssddata::ccme_boron, ggplot2::aes(x = Conc)) +
    stat_ssd())
})

test_that("plot stat_ssd", {
  expect_defunct(ggplot2::ggplot(ssddata::ccme_boron, ggplot2::aes(x = Conc)) +
    stat_ssd())
})

test_that("geom_ssd deprecated", {
  expect_defunct(ggplot2::ggplot(ssddata::ccme_boron, ggplot2::aes(x = Conc)) +
    geom_ssd())
})

test_that("plot geom_ssd", {
  expect_defunct(ggplot2::ggplot(ssddata::ccme_boron, ggplot2::aes(x = Conc)) +
    geom_ssd())
})

test_that("plot geom_ssdpoint", {
  gp <- ggplot2::ggplot(ssddata::ccme_boron, ggplot2::aes(x = Conc)) +
    geom_ssdpoint()
  expect_snapshot_plot(gp, "geom_ssdpoint")
})

test_that("plot geom_ssdpoint identity stat", {
  data <- ssddata::ccme_boron
  data$New <- (seq_len(nrow(data)) - 0.5) / nrow(data)
  gp <- ggplot2::ggplot(data, ggplot2::aes(x = Conc, y = New)) +
    geom_ssdpoint(stat = "identity")
  expect_snapshot_plot(gp, "geom_ssdpoint_identity")
})

test_that("plot geom_ssdsegment", {
  gp <- ggplot2::ggplot(ssddata::ccme_boron, ggplot2::aes(x = Conc, xend = Conc * 2)) +
    geom_ssdsegment()
  expect_snapshot_plot(gp, "geom_ssdsegment")
})

test_that("plot geom_ssdsegment identity", {
  data <- ssddata::ccme_boron
  data$New <- (seq_len(nrow(data)) - 0.5) / nrow(data)
  gp <- ggplot2::ggplot(data, ggplot2::aes(
    x = Conc, xend = Conc * 2,
    y = New, yend = New
  )) +
    geom_ssdsegment(stat = "identity")
  expect_snapshot_plot(gp, "geom_ssdsegment_identity")
})

test_that("plot geom_ssdsegment arrow", {
  gp <- ggplot2::ggplot(ssddata::ccme_boron, ggplot2::aes(x = Conc, xend = Conc * 2)) +
    geom_ssdsegment(arrow = grid::arrow())
  expect_snapshot_plot(gp, "geom_ssdsegment_arrow")
})

test_that("plot geom_ssdsegment no data", {
  gp <- ggplot2::ggplot(ssddata::ccme_boron[FALSE, ], ggplot2::aes(x = Conc, xend = Conc * 2)) +
    geom_ssdsegment()
  expect_snapshot_plot(gp, "geom_ssdsegment_nodata")
})

test_that("plot geom_hcintersect", {
  gp <- ggplot2::ggplot(ssddata::ccme_boron, ggplot2::aes(x = Conc)) +
    geom_hcintersect(xintercept = 1, yintercept = 0.05)
  expect_snapshot_plot(gp, "geom_hcintersect")
})

test_that("plot geom_hcintersect aes", {
  data <- ssddata::ccme_boron
  data$yintercept <- 0.10
  gp <- ggplot2::ggplot(data, ggplot2::aes(x = Conc)) +
    geom_hcintersect(aes(xintercept = 1, yintercept = yintercept))
  expect_snapshot_plot(gp, "geom_hcintersect_aes")
})

test_that("plot geom_xribbon", {
  gp <- ggplot2::ggplot(boron_pred) +
    geom_xribbon(
      ggplot2::aes(xmin = lcl, xmax = ucl, y = proportion)
    )
  expect_snapshot_plot(gp, "geom_xribbon")
})
