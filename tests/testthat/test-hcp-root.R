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

test_that("hp is hc conc = 1 multi_ci = TRUE", {
  fits <- ssd_fit_dists(ssddata::ccme_boron)
  conc <- 1
  hp_multi <- ssd_hp(fits, conc = conc, average = TRUE, multi_ci = TRUE)
  hc_multi <- ssd_hc(fits, percent = hp_multi$est, average = TRUE, multi_ci = TRUE)
  expect_equal(hc_multi$est, 1)
  for(i in 1:10) {
    hp_multi <- ssd_hp(fits, conc = hc_multi$est, average = TRUE, multi_ci = TRUE)
    hc_multi <- ssd_hc(fits, percent = hp_multi$est, average = TRUE, multi_ci = TRUE)
  }
  expect_equal(hc_multi$est, 1)
})

test_that("hp is hc conc = 10 multi_ci = TRUE", {
  fits <- ssd_fit_dists(ssddata::ccme_boron)
  conc <- 10
  hp_multi <- ssd_hp(fits, conc = conc, average = TRUE, multi_ci = TRUE)
  hc_multi <- ssd_hc(fits, percent = hp_multi$est, average = TRUE, multi_ci = TRUE)
  expect_equal(hc_multi$est, 10.00000012176)
  for(i in 1:10) {
    hp_multi <- ssd_hp(fits, conc = hc_multi$est, average = TRUE, multi_ci = TRUE)
    hc_multi <- ssd_hc(fits, percent = hp_multi$est, average = TRUE, multi_ci = TRUE)
  }
  expect_equal(hc_multi$est, 10)
})
