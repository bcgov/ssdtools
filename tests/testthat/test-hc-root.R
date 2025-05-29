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

test_that("hc multi_ci lnorm", {
  fits <- ssd_fit_dists(ssddata::ccme_boron, dists = "lnorm")
  withr::with_seed(102, {
    hc_dist <- ssd_hc(fits, average = FALSE, ci_method = "MACL")
    hc_average <- ssd_hc(fits, average = TRUE, ci_method = "MACL", est_method = "arithmetic")
    hc_multi <- ssd_hc(fits, average = TRUE, ci_method = "multi_fixed")
  })
  expect_identical(hc_dist$est, hc_average$est)
  expect_identical(hc_dist$est, hc_multi$est)

  testthat::expect_snapshot({
    hc_multi
  })
})

test_that("hc multi_ci all", {
  fits <- ssd_fit_dists(ssddata::ccme_boron)
  withr::with_seed(102, {
    hc_average <- ssd_hc(fits, average = TRUE, ci_method = "weighted_samples", est_method = "arithmetic")
    hc_multi <- ssd_hc(fits, average = TRUE, ci_method = "multi_fixed")
  })
  expect_equal(hc_average$est, 1.241515, tolerance = 1e-5)
  expect_equal(hc_multi$est, 1.2567737470831, tolerance = 1e-5)
  testthat::expect_snapshot({
    hc_multi
  })
})

test_that("hc multi_ci all multiple hcs", {
  fits <- ssd_fit_dists(ssddata::ccme_boron)
  withr::with_seed(102, {
    hc_average <- ssd_hc(fits, proportion = c(5, 10) / 100, average = TRUE, ci_method = "MACL", est_method = "arithmetic")
    hc_multi <- ssd_hc(fits, proportion = c(5, 10) / 100, average = TRUE, ci_method = "multi_fixed")
  })
  expect_equal(hc_average$est, c(1.24151480646654, 2.37337090704541), tolerance = 1e-5)
  expect_equal(hc_multi$est, c(1.2567737470831, 2.38164080837643), tolerance = 1e-5)
  testthat::expect_snapshot({
    hc_multi
  })
})

test_that("hc multi_ci all multiple hcs cis", {
  fits <- ssd_fit_dists(ssddata::ccme_boron)
  withr::with_seed(102, {
    hc_average <- ssd_hc(fits, proportion = c(5, 10) / 100, average = TRUE, ci_method = "MACL", est_method = "arithmetic", nboot = 10, ci = TRUE)
  })
  withr::with_seed(105, {
    hc_multi <- ssd_hc(fits, proportion = c(5, 10) / 100, average = TRUE, ci_method = "multi_fixed", nboot = 10, ci = TRUE)
  })
  expect_equal(hc_average$est, c(1.24151480646654, 2.37337090704541), tolerance = 1e-5)
  expect_equal(hc_multi$est, c(1.2567737470831, 2.38164080837643), tolerance = 1e-5)
  testthat::expect_snapshot({
    hc_multi
  })
})

test_that("hc multi_ci lnorm ci", {
  fits <- ssd_fit_dists(ssddata::ccme_boron, dists = "lnorm")
  withr::with_seed(102, {
    hc_dist <- ssd_hc(fits, average = FALSE, ci = TRUE, nboot = 100, ci_method = "weighted_samples")
  })
  withr::with_seed(102, {
    hc_average <- ssd_hc(fits, average = TRUE, ci = TRUE, nboot = 100, ci_method = "MACL", est_method = "arithmetic")
  })
  withr::with_seed(102, {
    hc_multi <- ssd_hc(fits, average = TRUE, ci_method = "multi_fixed", ci = TRUE, nboot = 100)
  })

  testthat::expect_snapshot({
    hc_average
  })

  testthat::expect_snapshot({
    hc_multi
  })
  
  hc_dist$dist <- NULL
  hc_average$dist <- NULL
  hc_dist$est_method <- NULL
  hc_average$est_method <- NULL
  hc_dist$ci_method <- NULL
  hc_average$ci_method <- NULL
  expect_identical(hc_dist, hc_average)
})
