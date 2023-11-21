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

test_that("hp multi lnorm", {
  
  fits <- ssd_fit_dists(ssddata::ccme_boron, dists = "lnorm")
  set.seed(102)
  hp_dist <- ssd_hp(fits, average = FALSE)
  hp_average <- ssd_hp(fits, average = TRUE)
  hp_multi <- ssd_hp(fits, average = TRUE, multi = TRUE)
  expect_identical(hp_average$est, hp_dist$est)
  expect_equal(hp_multi, hp_average)
  expect_equal(hp_average$est, 1.9543030195088)
  expect_equal(hp_multi$est, 1.95430301950878, tolerance = 1e-6)
  
  testthat::expect_snapshot({
    hp_multi
  })
})

test_that("hp multi all", {
  fits <- ssd_fit_dists(ssddata::ccme_boron)
  set.seed(102)
  hp_average <- ssd_hp(fits, average = TRUE)
  hp_multi <- ssd_hp(fits, average = TRUE, multi = TRUE)
  expect_equal(hp_multi, hp_average)
  expect_equal(hp_average$est, 3.89879358571718, tolerance = 1e-6)
  expect_equal(hp_multi$est, 3.89879358571718)
  testthat::expect_snapshot({
    hp_multi
  })
})
