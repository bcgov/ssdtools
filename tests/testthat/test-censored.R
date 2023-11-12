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

test_that("ssd_is_censored FALSE non-ssd_is_censored data", {
  expect_false(ssd_is_censored(ssddata::ccme_boron))
})

test_that("ssd_is_censored TRUE interval ssd_is_censored data", {
  expect_true(ssd_is_censored(data.frame(Conc = 1, right = 2), right = "right"))
})

test_that("ssd_is_censored missing value if no rows", {
  expect_identical(
    ssd_is_censored(data.frame(Conc = numeric(0), right = numeric(0)), right = "right"),
    NA
  )
})

test_that("ssd_is_censored TRUE left ssd_is_censored data 0", {
  expect_true(ssd_is_censored(data.frame(Conc = 0, right = 2), right = "right"))
})

test_that("ssd_is_censored TRUE left ssd_is_censored data NA", {
  expect_true(ssd_is_censored(data.frame(Conc = NA_real_, right = 2), right = "right"))
})

test_that("ssd_is_censored errors negative left ssd_is_censored data", {
  expect_error(ssd_is_censored(data.frame(Conc = -1, right = 2), right = "right"))
})

test_that("ssd_is_censored TRUE right ssd_is_censored data Inf", {
  expect_true(ssd_is_censored(data.frame(Conc = 1, right = Inf), right = "right"))
})

test_that("ssd_is_censored TRUE right ssd_is_censored data NA", {
  expect_true(ssd_is_censored(data.frame(Conc = 1, right = NA_real_), right = "right"))
})

test_that("ssd_is_censored errors if missing values", {
  expect_error(ssd_is_censored(data.frame(Conc = NA_real_, right = NA_real_), right = "right"))
})

test_that("ssd_is_censored errors if effectively missing values", {
  expect_error(ssd_is_censored(data.frame(Conc = 0, right = Inf), right = "right"))
})


test_that("ssd_is_censored FALSE fitdists uncensored", {
  fits <- ssd_fit_dists(ssddata::ccme_boron, dists = "lnorm")
  expect_false(ssd_is_censored(fits))
})

test_that("ssd_is_censored TRUE fitdists censored", {
  data <- ssddata::ccme_boron
  data$Right <- data$Conc
  data$Conc <- 0
  fits <- ssd_fit_dists(data, right = "Right", dists = c("gamma", "llogis", "lnorm"))
  expect_true(ssd_is_censored(fits))
})
