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

test_that("plot stat_ssd", {
  gp <- ggplot2::ggplot(boron_data, ggplot2::aes(x = Conc)) +
    stat_ssd()
  expect_snapshot_plot(gp, "stat_ssd")
})

test_that("plot stat_ssdcens", {
  gp <- ggplot2::ggplot(boron_data, ggplot2::aes(x = Conc, xend = Conc * 2)) +
    stat_ssdcens()
  expect_snapshot_plot(gp, "stat_ssdcens")
})

test_that("plot geom_ssd", {
  gp <- ggplot2::ggplot(boron_data, ggplot2::aes(x = Conc)) +
    geom_ssd()
  expect_snapshot_plot(gp, "geom_ssd")
})

test_that("plot geom_ssdcens", {
  gp <- ggplot2::ggplot(boron_data, ggplot2::aes(x = Conc, xend = Conc * 2)) +
    geom_ssdcens()
  expect_snapshot_plot(gp, "geom_ssdcens")
})

test_that("plot geom_hcintersect", {
  gp <- ggplot2::ggplot(boron_data, ggplot2::aes(x = Conc)) +
    geom_hcintersect(xintercept = 1, yintercept = 0.05)
  expect_snapshot_plot(gp, "geom_hcintersect")
})

test_that("plot geom_hcintersect aes", {
  data <- boron_data
  data$yintercept <- 0.10
  gp <- ggplot2::ggplot(data, ggplot2::aes(x = Conc)) +
    geom_hcintersect(aes(xintercept = 1, yintercept = yintercept))
  expect_snapshot_plot(gp, "geom_hcintersect_aes")
})

test_that("plot geom_xribbon", {
  gp <- ggplot2::ggplot(boron_pred) +
    geom_xribbon(
      ggplot2::aes(xmin = lcl, xmax = ucl, y = percent)
    )
  expect_snapshot_plot(gp, "geom_xribbon")
})

test_that("plot geoms", {
  gp <- ggplot2::ggplot(boron_pred) +
    geom_ssd(data = boron_data, ggplot2::aes(x = Conc)) +
    geom_ssdcens(data = boron_data, ggplot2::aes(x = Conc, xend = Conc * 2)) +
    geom_hcintersect(xintercept = 100, yintercept = 0.5) +
    geom_xribbon(
      ggplot2::aes(xmin = lcl, xmax = ucl, y = percent/100),
      alpha = 1/3
    )
  expect_snapshot_plot(gp, "geoms_all")
})
