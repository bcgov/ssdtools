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

context("plot")

test_that("plot geoms", {
  setup(pdf(tempfile(fileext = ".pdf")))
  teardown(dev.off())
  data <- boron_data
  data$yintercept <- 0.10
  gp <- ggplot(boron_data, aes(x = Conc)) +
    stat_ssd() +
    geom_ssd() +
    geom_hcintersect(xintercept = 1, yintercept = 0.05) +
    geom_hcintersect(yintercept = 0.05) +
    geom_xribbon(
      data = boron_pred,
      aes_string(xmin = "lcl", xmax = "ucl", y = "percent")
    )
  expect_is(gp, "ggplot")
})

test_that("plot", {
  setup(pdf(tempfile(fileext = ".pdf")))
  teardown(dev.off())

  expect_silent(plot(boron_lnorm))
  expect_silent(plot(fluazinam_lnorm))
  expect_silent(plot(boron_dists))
})

test_that("cfplot", {
  setup(pdf(tempfile(fileext = ".pdf")))
  teardown(dev.off())

  expect_silent(ssd_plot_cf(boron_data))
})

test_that("ssd_plot_cdf", {
  setup(pdf(tempfile(fileext = ".pdf")))
  teardown(dev.off())

  expect_is(ssd_plot_cdf(boron_lnorm), "ggplot")
  expect_is(ssd_plot_cdf(boron_dists), "ggplot")
  fluazinam_lnorm$censdata$right[3] <- fluazinam_lnorm$censdata$left[3] * 1.5
  fluazinam_lnorm$censdata$left[5] <- NA
  expect_is(ssd_plot_cdf(fluazinam_lnorm), "ggplot")
})

test_that("autoplot", {
  setup(pdf(tempfile(fileext = ".pdf")))
  teardown(dev.off())

  expect_is(ggplot2::autoplot(boron_lnorm), "ggplot")
  expect_is(ggplot2::autoplot(boron_dists), "ggplot")
  expect_is(ggplot2::autoplot(fluazinam_lnorm), "ggplot")
})

test_that("ssd_plot", {
  setup(pdf(tempfile(fileext = ".pdf")))
  teardown(dev.off())

  expect_is(ssd_plot(boron_data, boron_pred), "ggplot")
  expect_is(ssd_plot(boron_data, boron_pred, ribbon = TRUE, label = "Species"), "ggplot")

  data(fluazinam, package = "fitdistrplus")
  expect_is(ssd_plot(fluazinam, fluazinam_pred,
    left = "left", right = "right"
  ), "ggplot")
})
