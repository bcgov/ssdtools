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

test_that("ssd_plot", {
  expect_snapshot_plot(ssd_plot(boron_data, boron_pred), "boron_pred")
  expect_snapshot_plot(ssd_plot(boron_data, boron_pred, ribbon = TRUE), "boron_pred_ribbon")
  expect_snapshot_plot(ssd_plot(boron_data, boron_pred, label = "Species"), "boron_pred_label")
})

test_that("ssd_plot censored data", {
  data <- boron_data
  data$Other <- data$Conc * 2
  expect_snapshot_plot(ssd_plot(data, boron_pred, right = "Other"), "boron_cens_pred")
  expect_snapshot_plot(ssd_plot(data, boron_pred, right = "Other", ribbon = TRUE), "boron_cens_pred_ribbon")
  expect_snapshot_plot(ssd_plot(data, boron_pred, right = "Other", label = "Species"), "boron_cens_pred_species")
})

test_that("ssd_plot xbreaks", {
  expect_snapshot_plot(ssd_plot(boron_data, boron_pred, xbreaks = c(1,2)), "boron_breaks")
})
