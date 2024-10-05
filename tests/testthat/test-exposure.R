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

test_that("exposure fitdist", {
  fits <- ssd_fit_dists(ssddata::ccme_boron, dists = "lnorm")

  set.seed(1)
  expect_equal(ssd_exposure(fits), 0.0554387492913971, tolerance = 1e-5)
})

test_that("exposure different mean", {
  fits <- ssd_fit_dists(ssddata::ccme_boron, dists = "lnorm")

  set.seed(1)
  expect_equal(ssd_exposure(fits, 1), 0.165064432413281, tolerance = 1e-6)
})

test_that("exposure different mean and log", {
  fits <- ssd_fit_dists(ssddata::ccme_boron, dists = "lnorm")

  set.seed(1)
  expect_equal(ssd_exposure(fits, 1, sdlog = 10), 0.433888512432359, tolerance = 1e-7)
})

test_that("exposure multiple distributions", {
  skip_on_cran() # slow on debian
  fits <- ssd_fit_dists(ssddata::ccme_boron)
  
  set.seed(1)
  expect_equal(ssd_exposure(fits), 0.0663588247125051, tolerance = 1e-5)
})

test_that("exposure somewhat sensitive to rescaling", {
  skip_on_cran() # slow on debian
  fits <- ssd_fit_dists(ssddata::ccme_boron, dists = "lnorm")
  
  set.seed(10)
  exposure <- ssd_exposure(fits)
  
  fits_rescale <- ssd_fit_dists(ssddata::ccme_boron, dists = "lnorm", rescale = TRUE)
  set.seed(10)
  exposure_rescale <- ssd_exposure(fits_rescale)
  
  expect_equal(exposure_rescale, exposure, tolerance = 1e-3)
})
