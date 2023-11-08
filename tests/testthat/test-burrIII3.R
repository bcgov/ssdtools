# Copyright 2023 Environment and Climate Change Canada
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

test_that("burrIII3", {
  test_dist("burrIII3")
  expect_equal(ssd_pburrIII3(1), 0.5)
  expect_equal(ssd_qburrIII3(0.75), 3)
  set.seed(42)
  expect_equal(ssd_rburrIII3(2), c(10.7379218085407, 14.8920392236127))
})

test_that("burrIII3 gives cis with ccme_chloride", {
  fit <- ssd_fit_dists(ssddata::ccme_chloride, dists = "burrIII3")
  expect_s3_class(fit, "fitdists")
  set.seed(99)
  hc <- ssd_hc(fit, nboot = 10, ci = TRUE)
  testthat::skip_on_os("windows")
  testthat::skip_on_os("linux")
  testthat::skip_on_os("solaris")
  expect_snapshot_data(hc, "hc_chloride")
})

test_that("burrIII3 gives cis with ccme_uranium", {
  fit <- ssd_fit_dists(ssddata::ccme_uranium, dists = "burrIII3")
  expect_s3_class(fit, "fitdists")
  set.seed(99)
  hc <- ssd_hc(fit, nboot = 10, ci = TRUE)
  testthat::skip_on_os("windows")
  testthat::skip_on_os("linux")
  testthat::skip_on_os("solaris")
  expect_snapshot_data(hc, "hc_uranium")
})

test_that("burrIII3 fits anon_e but only at boundary ok", {
  fit <- ssd_fit_dists(ssddata::anon_e, dists = "burrIII3", at_boundary_ok = TRUE)
  tidy <- tidy(fit)
  testthat::skip_on_os("windows")
  testthat::skip_on_os("linux")
  testthat::skip_on_os("solaris")
  expect_snapshot_data(tidy, "tidy_anon_e")
  expect_error(expect_warning(
    ssd_fit_dists(ssddata::anon_e, dists = "burrIII3"),
    "at boundary"
  ))
})
