# Copyright 2023 Province of British Columbia
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

test_that("boron stable", {
  fits <- ssd_fit_dists(ssddata::ccme_boron, dists = ssd_dists(bcanz = TRUE))

  tidy <- tidy(fits)
  expect_s3_class(tidy, "tbl_df")
  expect_snapshot_data(tidy, "boron_stable")
})

test_that("boron unstable", {
  dists <- ssd_dists(bcanz = FALSE)
  set.seed(50)
  expect_warning(
    fits <- ssd_fit_dists(ssddata::ccme_boron, dists = dists),
    "Distribution 'burrIII3' failed to fit"
  )

  tidy <- tidy(fits)
  expect_s3_class(tidy, "tbl_df")
  expect_snapshot_data(tidy, "boron_unstable")
})

test_that("dist_data", {
  expect_snapshot_data(ssdtools::dist_data, "dist_data")
})
