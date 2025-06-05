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

test_that("hc multi_ci all multiple hcs cis", {
  fits <- ssd_fit_dists(ssddata::ccme_boron)
  withr::with_seed(50, {
    hc_average <- ssd_hc(fits, proportion = c(5, 10) / 100, average = TRUE, ci_method = "MACL", est_method = "arithmetic", nboot = 10, ci = TRUE)
  })
  withr::with_seed(50, {
    hc_multi <- ssd_hc(fits, proportion = c(5, 10) / 100, average = TRUE, ci_method = "multi_fixed", nboot = 10, ci = TRUE)
  })
  expect_snapshot_data(hc_average, "hc_multi_ci_all_multiple_hcs_cis_average")
  expect_snapshot_data(hc_multi, "hc_multi_ci_all_multiple_hcs_cis_multi")
})

test_that("hc multi_ci lnorm ci", {
  fits <- ssd_fit_dists(ssddata::ccme_boron, dists = "lnorm")
  withr::with_seed(50, {
    hc_dist <- ssd_hc(fits, average = FALSE, ci = TRUE, nboot = 10, ci_method = "weighted_samples")
  })
  withr::with_seed(50, {
    hc_average <- ssd_hc(fits, average = TRUE, ci = TRUE, nboot = 10, ci_method = "MACL", est_method = "arithmetic")
  })
  withr::with_seed(50, {
    hc_multi <- ssd_hc(fits, average = TRUE, ci_method = "multi_fixed", ci = TRUE, nboot = 10)
  })

  expect_snapshot_data(hc_dist, "hc_multi_ci_lnorm_ci_dist")
  expect_snapshot_data(hc_average, "hc_multi_ci_lnorm_ci_average")
  expect_snapshot_data(hc_multi, "hc_multi_ci_lnorm_ci_multi")
})
