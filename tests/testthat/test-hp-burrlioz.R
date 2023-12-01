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

test_that("ssd_hp_burrlioz gets estimates with invpareto", {
  fit <- ssd_fit_burrlioz(ssddata::ccme_boron)
  set.seed(47)
  hp_boron <- ssd_hp(fit, nboot = 10, ci = TRUE, min_pboot = 0)
  expect_snapshot_data(hp_boron, "hp_boron")
})

test_that("ssd_hp_burrlioz gets estimates with invpareto no ci", {
  fit <- ssd_fit_burrlioz(ssddata::ccme_boron)
  set.seed(47)
  hp_boron <- ssd_hp(fit, nboot = 10, ci = FALSE, min_pboot = 0)
  expect_snapshot_data(hp_boron, "hp_boron_no_ci")
})

test_that("ssd_hp_burrlioz gets estimates with burrIII3", {
  set.seed(99)
  data <- data.frame(Conc = ssd_rburrIII3(30))
  fit <- ssd_fit_burrlioz(data)
  expect_identical(names(fit), "burrIII3")
  set.seed(49)
  hp_burrIII3 <- ssd_hp(fit, nboot = 10, ci = TRUE, min_pboot = 0)
  expect_snapshot_data(hp_burrIII3, "hp_burrIII3")
})

test_that("ssd_hp_burrlioz currently errors!", {
  set.seed(99)
  data <- data.frame(Conc = ssd_rburrIII3(30))
  fit <- ssd_fit_burrlioz(data)
  expect_identical(names(fit), "burrIII3")
  set.seed(47)
  #FIXME: currently errors!
  expect_error(hp_burrIII3 <- ssd_hp(fit, nboot = 10, ci = TRUE, min_pboot = 0))
})

test_that("ssd_hp_burrlioz gets estimates with burrIII3 parametric", {
  set.seed(99)
  data <- data.frame(Conc = ssd_rburrIII3(30))
  fit <- ssd_fit_burrlioz(data)
  expect_identical(names(fit), "burrIII3")
  set.seed(49)
  hp_burrIII3 <- ssd_hp(fit,
                        nboot = 10, ci = TRUE, min_pboot = 0,
                        parametric = TRUE
  )
  expect_snapshot_data(hp_burrIII3, "hp_burrIII3_parametric")
})
