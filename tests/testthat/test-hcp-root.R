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

test_that("hp is hc conc = 1 root = TRUE", {
  fits <- ssd_fit_dists(ssddata::ccme_boron)
  conc <- 1
  hp_root <- ssd_hp(fits, conc = conc, average = TRUE, root = TRUE)
  hc_root <- ssd_hc(fits, percent = hp_root$est, average = TRUE, root = TRUE)
  expect_equal(hc_root$est, 1.00305263994978)
  for(i in 1:100) {
    hp_root <- ssd_hp(fits, conc = hc_root$est, average = TRUE, root = TRUE)
    hc_root <- ssd_hc(fits, percent = hp_root$est, average = TRUE, root = TRUE)
  }
  expect_equal(hc_root$est, 2.37979047897204)
})

test_that("hp is hc conc = 1 root = FALSE", {
  fits <- ssd_fit_dists(ssddata::ccme_boron)
  conc <- 1
  hp_root <- ssd_hp(fits, conc = conc, average = TRUE, root = FALSE)
  hc_root <- ssd_hc(fits, percent = hp_root$est, average = TRUE, root = FALSE)
  expect_equal(hc_root$est, 0.997184605748195)
  for(i in 1:100) {
    hp_root <- ssd_hp(fits, conc = hc_root$est, average = TRUE, root = FALSE)
    hc_root <- ssd_hc(fits, percent = hp_root$est, average = TRUE, root = FALSE)
  }
  expect_equal(hc_root$est, 0.958646915712036)
})


test_that("hp is hc conc = 10 root = TRUE", {
  fits <- ssd_fit_dists(ssddata::ccme_boron)
  conc <- 10
  hp_root <- ssd_hp(fits, conc = conc, average = TRUE, root = TRUE)
  hc_root <- ssd_hc(fits, percent = hp_root$est, average = TRUE, root = TRUE)
  expect_equal(hc_root$est, 9.91446020346946)
  for(i in 1:100) {
    hp_root <- ssd_hp(fits, conc = hc_root$est, average = TRUE, root = TRUE)
    hc_root <- ssd_hc(fits, percent = hp_root$est, average = TRUE, root = TRUE)
  }
  expect_equal(hc_root$est, 4.50212423822917)
})

test_that("hp is hc conc = 10 root = FALSE", {
  fits <- ssd_fit_dists(ssddata::ccme_boron)
  conc <- 10
  hp_root <- ssd_hp(fits, conc = conc, average = TRUE, root = FALSE)
  hc_root <- ssd_hc(fits, percent = hp_root$est, average = TRUE, root = FALSE)
  expect_equal(hc_root$est, 10.0858243613942)
  for(i in 1:100) {
    hp_root <- ssd_hp(fits, conc = hc_root$est, average = TRUE, root = FALSE)
    hc_root <- ssd_hc(fits, percent = hp_root$est, average = TRUE, root = FALSE)
  }
  expect_equal(hc_root$est, 16.1423852672884)
})
