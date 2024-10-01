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

test_that("print tmbfit", {
  fits <- ssd_fit_dists(ssddata::ccme_boron, dists = "lnorm")
  expect_snapshot_output(print(fits$lnorm))
})

test_that("print fitdists", {
  fits <- ssd_fit_dists(ssddata::ccme_boron, dists = "lnorm")
  expect_snapshot_output(print(fits))
})

test_that("summary fitdists with left censored, rescaled, weighted data", {
  data <- ssddata::ccme_boron
  data$Mass <- seq_len(nrow(data))
  data$Other <- data$Conc
  data$Conc[2] <- NA
  fits <- ssd_fit_dists(data, right = "Other", weight = "Mass", rescale = TRUE, dists = "lnorm")
  expect_snapshot_output(print(fits))
})

test_that("summary fitdists with inconsistently censored data", {
  data <- ssddata::ccme_boron
  data$Conc2 <- data$Conc
  data$Conc[1] <- 1
  data$Conc2[1] <- 2
  fits <- ssd_fit_dists(data, right = "Conc2", dists = "lnorm")
  expect_snapshot_output(print(fits))
})

test_that("summary fitdists with right censored, rescaled, weighted data", {
  data <- ssddata::ccme_boron
  data$Mass <- seq_len(nrow(data))
  data$Other <- data$Conc
  data$Other[1] <- Inf
  expect_error(fits <- ssd_fit_dists(data, right = "Other", weight = "Mass", rescale = TRUE, dists = "lnorm"))
  # expect_snapshot_output(print(fits))
})

test_that("print fitdists with multiple distributions", {
  fits <- ssd_fit_dists(ssddata::ccme_boron)
  expect_snapshot_output(print(fits))
})
