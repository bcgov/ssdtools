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

test_that("ssd_plot", {
  expect_snapshot_plot(ssd_plot(ssddata::ccme_boron, boron_pred), "boron_pred")
  expect_snapshot_plot(ssd_plot(ssddata::ccme_boron, boron_pred, label = "Species"), "boron_pred_label")
  expect_snapshot_plot(ssd_plot(ssddata::ccme_boron, boron_pred,
    label = "Species",
    shift_x = 2
  ), "boron_pred_shift_x")
  testthat::skip_on_ci()
  testthat::skip_on_cran()
  expect_snapshot_plot(ssd_plot(ssddata::ccme_boron, boron_pred, ribbon = TRUE), "boron_pred_ribbon")
})

test_that("ssd_plot censored data", {
  data <- ssddata::ccme_boron
  data$Other <- data$Conc * 2
  expect_snapshot_plot(ssd_plot(data, boron_pred, right = "Other"), "boron_cens_pred")
  expect_snapshot_plot(ssd_plot(data, boron_pred, right = "Other", label = "Species"), "boron_cens_pred_species")
  testthat::skip_on_ci()
  testthat::skip_on_cran()
  expect_snapshot_plot(ssd_plot(data, boron_pred, right = "Other", ribbon = TRUE), "boron_cens_pred_ribbon")
})

test_that("ssd_plot aes", {
  data <- ssddata::ccme_boron
  expect_snapshot_plot(ssd_plot(data, boron_pred, color = "Group"), "boron_color")
  expect_snapshot_plot(ssd_plot(data, boron_pred, shape = "Group"), "boron_shape")
})

test_that("ssd_plot xbreaks", {
  expect_snapshot_plot(ssd_plot(ssddata::ccme_boron, boron_pred, xbreaks = c(1, 2)), "boron_breaks")
})

test_that("ssd_plot can't handles missing values all", {
  data <- ssddata::ccme_boron
  data$Conc <- NA_real_
  expect_error(ssd_plot(data, boron_pred))
})

test_that("ssd_plot fills in missing order", {
  data <- ssddata::ccme_boron
  data <- data[order(data$Conc), ]
  data$Other <- data$Conc
  data$Conc[1] <- NA
  data$Other[nrow(data)] <- NA
  expect_snapshot_plot(
    ssd_plot(data, boron_pred, right = "Other", bounds = c(right = 2)),
    "missing_order"
  )
})
