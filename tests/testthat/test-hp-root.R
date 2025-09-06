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

test_that("hp multi_ci lnorm", {
  fits <- ssd_fit_dists(ssddata::ccme_boron, dists = "lnorm")
  withr::with_seed(502, {
    hp_dist <- ssd_hp(fits, average = FALSE, ci_method = "MACL", proportion = FALSE)
    hp_average <- ssd_hp(fits, average = TRUE, ci_method = "MACL", est_method = "arithmetic", proportion = FALSE)
    hp_multi <- ssd_hp(fits, average = TRUE, ci_method = "multi_fixed", proportion = FALSE)
  })
  expect_identical(hp_average$est, hp_dist$est)
  expect_snapshot_value(hp_average$est, style = "deparse")
  expect_snapshot_value(hp_multi$est, style = "deparse")
  expect_snapshot_data(hp_multi, "hp_multi_ci_lnorm")

  hp_multi$est_method <- NULL
  hp_average$est_method <- NULL
  hp_multi$ci_method <- NULL
  hp_average$ci_method <- NULL
  expect_equal(hp_multi, hp_average)
})

test_that("hp multi_ci all", {
  fits <- ssd_fit_dists(ssddata::ccme_boron)
  withr::with_seed(502, {
    hp_average <- ssd_hp(fits, average = TRUE, ci_method = "weighted_samples", proportion = FALSE)
    hp_multi <- ssd_hp(fits, average = TRUE, ci_method = "multi_fixed", proportion = FALSE)
  })
  expect_equal(
    hp_multi[!colnames(hp_multi) %in% c("ci_method", "boot_method")],
    hp_average[!colnames(hp_average) %in% c("ci_method", "boot_method")]
  )
  expect_snapshot_value(hp_average$est, style = "deparse")
  expect_snapshot_value(hp_multi$est, style = "deparse")
  expect_snapshot_data(hp_multi, "hp_multi_ci_all")
})

test_that("hp multi_ci lnorm ci", {
  fits <- ssd_fit_dists(ssddata::ccme_boron, dists = "lnorm")
  withr::with_seed(502, {
    hp_dist <- ssd_hp(fits, average = FALSE, ci = TRUE, nboot = 100, ci_method = "MACL", proportion = FALSE)
  })
  withr::with_seed(502, {
    hp_average <- ssd_hp(fits, average = TRUE, ci = TRUE, nboot = 100, ci_method = "MACL", proportion = FALSE)
  })
  withr::with_seed(502, {
    hp_multi <- ssd_hp(fits, average = TRUE, ci_method = "multi_fixed", ci = TRUE, nboot = 100, proportion = FALSE)
  })

  expect_snapshot_data(hp_average, "hp_multi_ci_lnorm_ci_average")
  expect_snapshot_data(hp_multi, "hp_multi_ci_lnorm_ci_multi")

  hp_dist$dist <- NULL
  hp_average$dist <- NULL
  expect_equal(hp_dist, hp_average)
})
