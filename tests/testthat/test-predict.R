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

test_that("predict", {
  skip_on_os("linux") # FIXME

  fits <- ssd_fit_dists(ssddata::ccme_boron)

  pred <- predict(fits)
  expect_s3_class(pred, "tbl")
  expect_snapshot_data(pred, "pred_dists")
})

test_that("predict cis", {
  skip_on_os("linux") # FIXME

  fits <- ssd_fit_dists(ssddata::ccme_boron)

  set.seed(10)
  pred <- predict(fits, ci = TRUE, nboot = 10L)
  expect_s3_class(pred, "tbl")
  expect_snapshot_data(pred, "pred_cis")
})

test_that("predict not average", {
  skip_on_os("linux") # FIXME
  fits <- ssd_fit_dists(ssddata::ccme_boron)

  expect_true(is.fitdists(fits))

  pred <- predict(fits, average = FALSE)
  expect_s3_class(pred, "tbl")
  expect_snapshot_data(pred, "pred_notaverage")
})

test_that("predict cis fitburrlioz", {
  skip_on_os("linux") # FIXME
  fits <- ssd_fit_burrlioz(ssddata::ccme_boron)

  expect_true(is.fitdists(fits))
  set.seed(10)

  pred <- predict(fits, ci = TRUE, nboot = 10L)
  expect_s3_class(pred, "tbl")
  expect_snapshot_data(pred, "pred_cis_burrlioz")
})
