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

test_that("hp is hc conc = 1 multi = TRUE", {
  fits <- ssd_fit_dists(ssddata::ccme_boron)
  conc <- 1
  hp_multi <- ssd_hp(fits, conc = conc, average = TRUE, multi = TRUE)
  hc_multi <- ssd_hc(fits, percent = hp_multi$est, average = TRUE, multi = TRUE)
  expect_equal(hc_multi$est, 0.999999930389277)
  for(i in 1:10) {
    hp_multi <- ssd_hp(fits, conc = hc_multi$est, average = TRUE, multi = TRUE)
    hc_multi <- ssd_hc(fits, percent = hp_multi$est, average = TRUE, multi = TRUE)
  }
  expect_equal(hc_multi$est, 0.999999234284464)
})

test_that("hp is hc conc = 10 multi = TRUE", {
  fits <- ssd_fit_dists(ssddata::ccme_boron)
  conc <- 10
  hp_multi <- ssd_hp(fits, conc = conc, average = TRUE, multi = TRUE)
  hc_multi <- ssd_hc(fits, percent = hp_multi$est, average = TRUE, multi = TRUE)
  expect_equal(hc_multi$est, 10.0000099303241)
  for(i in 1:10) {
    hp_multi <- ssd_hp(fits, conc = hc_multi$est, average = TRUE, multi = TRUE)
    hc_multi <- ssd_hc(fits, percent = hp_multi$est, average = TRUE, multi = TRUE)
  }
  expect_equal(hc_multi$est, 10.0001092323576)
})
