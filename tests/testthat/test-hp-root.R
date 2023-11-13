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

test_that("hp root lnorm", {
  
  fits <- ssd_fit_dists(ssddata::ccme_boron, dists = "lnorm")
  set.seed(102)
  hp_dist <- ssd_hp(fits, average = FALSE)
  hp_average <- ssd_hp(fits, average = TRUE)
  hp_root <- ssd_hp(fits, average = TRUE, root = TRUE)
  expect_identical(hp_average$est, hp_dist$est)
  expect_equal(hp_root, hp_average)
  expect_equal(hp_average$est, 1.9543030195088)
  expect_equal(hp_root$est, 1.95430301950878, tolerance = 1e-6)
  
  testthat::expect_snapshot({
    hp_root
  })
})

test_that("hp root all", {
  fits <- ssd_fit_dists(ssddata::ccme_boron)
  set.seed(102)
  hp_average <- ssd_hp(fits, average = TRUE)
  hp_root <- ssd_hp(fits, average = TRUE, root = TRUE)
  expect_equal(hp_root, hp_average, tolerance = 1e-2)
  expect_equal(hp_average$est, 3.89879358571718, tolerance = 1e-6)
  expect_equal(hp_root$est, 3.91155639855389, tolerance = 1e-6)
  testthat::expect_snapshot({
    hp_root
  })
})

test_that("hp is hc", {
  fits <- ssd_fit_dists(ssddata::ccme_boron)
  conc <- 1
  hp_root <- ssd_hp(fits, conc = conc, average = TRUE, root = TRUE)
  hc_root <- ssd_hc(fits, percent = hp_root$est, average = TRUE, root = TRUE)
  expect_equal(hc_root$est, conc, tolerance = 1e-2)
  for(i in 1:100) {
    hp_root <- ssd_hp(fits, conc = hc_root$est, average = TRUE, root = TRUE)
    hc_root <- ssd_hc(fits, percent = hp_root$est, average = TRUE, root = TRUE)
  }
  expect_equal(hc_root$est, conc, tolerance = 2)
})

# FIXME: move to root tests
# FIXME: also test actual values as seem deterministic
test_that("hp is hc 10", {
  fits <- ssd_fit_dists(ssddata::ccme_boron)
  conc <- 10
  hp_root <- ssd_hp(fits, conc = conc, average = TRUE, root = TRUE)
  hc_root <- ssd_hc(fits, percent = hp_root$est, average = TRUE, root = TRUE)
  expect_equal(hc_root$est, conc, tolerance = 1e-2)
  for(i in 1:100) {
    hp_root <- ssd_hp(fits, conc = hc_root$est, average = TRUE, root = TRUE)
    hc_root <- ssd_hc(fits, percent = hp_root$est, average = TRUE, root = TRUE)
  }
  expect_gt(hc_root$est, 2.3)
})
