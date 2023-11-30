#    Copyright 2023 Australian Government Department of 
#    Climate Change, Energy, the Environment and Water
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

test_that("hc multi lnorm", {
  fits <- ssd_fit_dists(ssddata::ccme_boron, dists = "lnorm")
  set.seed(102)
  hc_dist <- ssd_hc(fits, average = FALSE)
  hc_average <- ssd_hc(fits, average = TRUE)
  hc_multi <- ssd_hc(fits, average = TRUE, multi = TRUE)
  expect_identical(hc_dist$est, hc_average$est)
  expect_equal(hc_multi, hc_average)
  
  testthat::expect_snapshot({
    hc_multi
  })
})

test_that("hc multi all", {
  fits <- ssd_fit_dists(ssddata::ccme_boron)
  set.seed(102)
  hc_average <- ssd_hc(fits, average = TRUE)
  hc_multi <- ssd_hc(fits, average = TRUE, multi = TRUE)
  expect_equal(hc_average$est, 1.24151700389853)
  expect_equal(hc_multi$est, 1.25678623624403)
  testthat::expect_snapshot({
    hc_multi
  })
})

test_that("hc multi lnorm ci", {
  fits <- ssd_fit_dists(ssddata::ccme_boron, dists = "lnorm")
  set.seed(102)
  hc_dist <- ssd_hc(fits, average = FALSE, ci = TRUE, nboot = 100)
  set.seed(102)
  hc_average <- ssd_hc(fits, average = TRUE, ci = TRUE, nboot = 100)
  set.seed(102)
  hc_multi <- ssd_hc(fits, average = TRUE, multi = TRUE, ci = TRUE, nboot = 100)
  
  testthat::expect_snapshot({
    hc_average
  })
  
  testthat::expect_snapshot({
    hc_multi
  })
  
  hc_dist$dist <- NULL
  hc_average$dist <- NULL
  expect_identical(hc_dist, hc_average)
})

test_that("hc multi lnorm default 100", {
  fits <- ssd_fit_dists(ssddata::ccme_boron)
  set.seed(102)
  hc_average <- ssd_hc(fits, average = TRUE, ci = TRUE, nboot = 100)
  set.seed(102)
  hc_multi <- ssd_hc(fits, average = TRUE, multi = TRUE, ci = TRUE, nboot = 100)

  testthat::expect_snapshot({
    hc_average
  })

  testthat::expect_snapshot({
    hc_multi
  })
})
