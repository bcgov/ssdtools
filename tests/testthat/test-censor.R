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

test_that("ssd_censor only add right by default", {
  data <- ssddata::ccme_boron
  data$right <- data$Conc
  expect_identical(ssd_censor_data(ssddata::ccme_boron), data)
})

test_that("ssd_censor no rows", {
  data <- ssddata::ccme_boron
  data$right <- data$Conc
  expect_identical(ssd_censor_data(ssddata::ccme_boron[0,]), data[0,])
})

test_that("ssd_censor c(2.5, Inf)", {
  expect_snapshot_data(ssd_censor_data(ssddata::ccme_boron, censoring = c(2.5, Inf)), "boron_25")
})

test_that("ssd_censor c(0, 10)", {
  expect_snapshot_data(ssd_censor_data(ssddata::ccme_boron, censoring = c(0, 10)), "boron_10")
})

test_that("ssd_censor c(2.5, 10)", {
  expect_snapshot_data(ssd_censor_data(ssddata::ccme_boron, censoring = c(2.5, 10)), "boron_2510")
})
