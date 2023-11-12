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

test_that("tidy", {
  fits <- ssd_fit_dists(ssddata::ccme_boron)

  tidy <- tidy(fits)
  expect_s3_class(tidy, "tbl_df")
  expect_snapshot_data(tidy, "tidy")
})

test_that("tidy doesn't reorder dists (but does reorder pars)", {
  fit <- ssd_fit_dists(ssddata::ccme_boron, dists = c("lnorm", "llogis"))
  tidy <- tidy(fit)
  expect_s3_class(tidy, "tbl_df")
  expect_identical(colnames(tidy), c("dist", "term", "est", "se"))
  expect_identical(tidy$dist, c(rep("lnorm", 2), rep("llogis", 2)))
  expect_identical(tidy$term, c("meanlog", "sdlog", "locationlog", "scalelog"))
})

test_that("tidy fit all with also doesn't reorder dists (but does reorder pars)", {
  fit <- ssd_fit_dists(ssddata::ccme_boron, dists = c("lnorm", "llogis"))

  tidy <- tidy(fit, all = TRUE)
  expect_identical(colnames(tidy), c("dist", "term", "est", "se"))
  expect_identical(tidy$dist, c(rep("lnorm", 3), rep("llogis", 3)))
  expect_identical(tidy$term, c("log_sdlog", "meanlog", "sdlog", "locationlog", "log_scalelog", "scalelog"))
})
