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

test_that("lnorm_lnorm", {
  test_dist("lnorm_lnorm", qroottolerance = 1e-04)
  expect_snapshot_value(ssd_plnorm_lnorm(1), style = "deparse")
  expect_snapshot_value(ssd_qlnorm_lnorm(0.75), style = "deparse")
  withr::with_seed(50, {
    expect_snapshot_value(ssd_rlnorm_lnorm(2), style = "deparse")
  })
})

test_that("ssd_qlnorm_lnorm allows reversed distributions", {
  expect_equal(
    ssd_qlnorm_lnorm(0.05, meanlog1 = 0, meanlog2 = 1, pmix = 0.1),
    ssd_qlnorm_lnorm(0.05, meanlog1 = 1, meanlog2 = 0, pmix = 0.9)
  )
})

test_that("ssd_plnorm_lnorm allows reversed distributions", {
  expect_equal(
    ssd_plnorm_lnorm(1, meanlog1 = 0, meanlog2 = 1, pmix = 0.1),
    ssd_plnorm_lnorm(1, meanlog1 = 1, meanlog2 = 0, pmix = 0.9)
  )
})

test_that("ssd_rlnorm_lnorm allows reversed distributions", {
  withr::with_seed(50, {
    r1 <- ssd_rlnorm_lnorm(1, meanlog1 = 0, meanlog2 = 1, pmix = 0.1)
  })
  withr::with_seed(50, {
    r2 <- ssd_rlnorm_lnorm(1, meanlog1 = 1, meanlog2 = 0, pmix = 0.9)
  })
  expect_equal(r1, r2)
})

test_that("lnorm_lnorm positive q with extreme distribution", {
  expect_snapshot_value(qlnorm_lnorm_ssd(0.05,
    meanlog1 = -10.39362, sdlog1 = 0.399835,
    meanlog2 = -4.76721, sdlog2 = 2.583824, pmix = 0.1308133
  ), style = "deparse")
})

test_that("lnorm_lnorm positive q with extreme large distribution", {
  expect_snapshot_value(qlnorm_lnorm_ssd(0.99,
    meanlog1 = -4.76721, sdlog1 = 0.399835,
    meanlog2 = 100.39362, sdlog2 = 2.583824, pmix = 0.1308133
  ), style = "deparse")
})
