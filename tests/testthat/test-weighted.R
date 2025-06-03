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

test_that("weighted errors", {
  data <- ssddata::ccme_boron

  data$Weight <- 1
  data$Weight[rank(data$Conc) > 6] <- 0

  expect_error(
    ssd_fit_dists(data, dists = "lnorm", weight = "Weight"),
    "^`data` has 22 rows with zero weight in 'Weight'\\.$"
  )

  data$Weight[rank(data$Conc) > 6] <- -1

  expect_error(
    ssd_fit_dists(data, dists = "lnorm", weight = "Weight"),
    "^`data\\$Weight` must have values between 0 and Inf\\.$"
  )

  data$Weight[rank(data$Conc) > 6] <- Inf

  expect_error(
    ssd_fit_dists(data, dists = "lnorm", weight = "Weight"),
    "^`data` has 22 rows with Inf weight in 'Weight'\\.$"
  )
})

test_that("weighted works", {
  data <- ssddata::ccme_boron

  data$Weight <- 1
  data$Weight[rank(data$Conc) > 6] <- 1 / 10

  fitall <- ssd_fit_dists(data, dists = "lnorm")
  hcall <- ssd_hc(fitall)
  expect_snapshot_data(hcall, "hcall")

  fit1 <- ssd_fit_dists(subset(data, Weight == 1), dists = "lnorm")
  hc1 <- ssd_hc(fit1)
  expect_snapshot_data(hc1, "hc1")

  fit1w <- ssd_fit_dists(subset(data, Weight == 1), dists = "lnorm", weight = "Weight")
  hc1w <- ssd_hc(fit1w)
  expect_snapshot_data(hc1w, "hc1w")

  fitallw10 <- ssd_fit_dists(data, dists = "lnorm", weight = "Weight")
  hcallw10 <- ssd_hc(fitallw10)
  expect_snapshot_data(hcallw10, "hcallw10")

  data$Weight[rank(data$Conc) > 6] <- 1 / 100

  fitallw100 <- ssd_fit_dists(data, dists = "lnorm", weight = "Weight")
  hcallw100 <- ssd_hc(fitallw100)
  expect_snapshot_data(hcallw100, "hcallw100")

  data$Weight[rank(data$Conc) > 6] <- 1 / 1000

  fitallw1000 <- ssd_fit_dists(data, dists = "lnorm", weight = "Weight")
  hcallw1000 <- ssd_hc(fitallw1000)
  expect_snapshot_data(hcallw1000, "hcallw1000")
})

test_that("weighted2", {
  data <- ssddata::ccme_boron

  data$Weight <- 2

  fit2 <- ssd_fit_dists(data, dists = "lnorm", weight = "Weight")
  hc2 <- ssd_hc(fit2)
  expect_snapshot_data(hc2, "hc2")
})
