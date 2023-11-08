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

test_that("gof", {
  fits <- ssd_fit_dists(ssddata::ccme_boron)

  gof_statistic <- ssd_gof(fits)
  expect_s3_class(gof_statistic, "tbl")
  expect_snapshot_data(gof_statistic, "gof_statistic")

  gof <- ssd_gof(fits, pvalue = TRUE)
  expect_s3_class(gof, "tbl")
  expect_snapshot_data(gof, "gof")
})

test_that("gof mixture", {
  fits <- ssd_fit_dists(ssddata::ccme_boron, dists = "llogis_llogis")

  gof_statistic <- ssd_gof(fits)
  expect_s3_class(gof_statistic, "tbl")
  expect_snapshot_data(gof_statistic, "gof_statistic_mixture")

  gof <- ssd_gof(fits, pvalue = TRUE)
  expect_s3_class(gof, "tbl")
  expect_snapshot_data(gof, "gof_pvalue_mixture")
})
