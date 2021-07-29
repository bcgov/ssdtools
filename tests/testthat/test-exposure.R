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

test_that("exposure fitdist", {
  boron_lnorm <- ssd_fit_dists(ssdtools::boron_data, dists = "lnorm")
  
  set.seed(1)
  expect_equal(ssd_exposure(boron_lnorm), 0.0554388690057964)
})

test_that("exposure different mean", {
  boron_lnorm <- ssd_fit_dists(ssdtools::boron_data, dists = "lnorm")
  
  set.seed(1)
  expect_equal(ssd_exposure(boron_lnorm, 1), 0.165064610334353)
})

test_that("exposure different mean and log", {
  boron_lnorm <- ssd_fit_dists(ssdtools::boron_data, dists = "lnorm")
  
  set.seed(1)
  expect_equal(ssd_exposure(boron_lnorm, 1, sdlog = 10), 0.433888512432359)
})

test_that("exposure multiple distributions", {
  set.seed(1)
  expect_equal(ssd_exposure(boron_dists), 0.0645152661450559)
})

test_that("exposure not sensitive to rescaling", {
  boron_lnorm <- ssd_fit_dists(ssdtools::boron_data, dists = "lnorm")
  
  set.seed(10)
  exposure <- ssd_exposure(boron_lnorm)
  
  boron_lnorm_rescale <- ssd_fit_dists(ssdtools::boron_data, dists = "lnorm", rescale = TRUE)
  set.seed(10)
  exposure_rescale <- ssd_exposure(boron_lnorm_rescale)
  
  expect_equal(exposure_rescale, exposure)
})
