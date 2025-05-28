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

test_that("predict", {
  fits <- ssd_fit_dists(ssddata::ccme_boron)

  pred <- predict(fits, ci_method = "weighted_samples", est_method = "arithmetic")
  expect_s3_class(pred, "tbl")
  expect_snapshot_data(pred, "pred_dists")
})

test_that("predict cis", {
  fits <- ssd_fit_dists(ssddata::ccme_boron)

  set.seed(10)
  pred <- predict(fits, ci = TRUE, nboot = 10L, ci_method = "weighted_arithmetic", est_method = "arithmetic")
  expect_s3_class(pred, "tbl")
  expect_snapshot_data(pred, "pred_cis")
})

test_that("predict not average", {
  fits <- ssd_fit_dists(ssddata::ccme_boron)

  expect_true(is.fitdists(fits))

  pred <- predict(fits, average = FALSE, ci_method = "weighted_samples")
  expect_s3_class(pred, "tbl")
  expect_snapshot_data(pred, "pred_notaverage")
})

test_that("predict cis fitburrlioz", {
  fits <- ssd_fit_burrlioz(ssddata::ccme_boron)

  expect_true(is.fitdists(fits))
  set.seed(10)

  pred <- predict(fits, ci = TRUE, nboot = 10L)
  expect_s3_class(pred, "tbl")
  expect_snapshot_data(pred, "pred_cis_burrlioz")
})


test_that("predict matches ssd_hc with and without average", {
  data <- ssddata::ccme_glyphosate

  use_dists <- c("lnorm", "llogis", "lgumbel", "weibull", "gamma", "lnorm_lnorm")

  fit <- ssd_fit_dists(
    data = data,
    left = "Conc", dists = use_dists,
    silent = TRUE, reweight = FALSE, min_pmix = 0,
    computable = TRUE, at_boundary_ok = FALSE, rescale = FALSE
  )

  ave5 <- ssd_hc(fit, est_method = "arithmetic")
  multi5 <- ssd_hc(fit)

  expect_snapshot_data(ave5, "ave5")
  expect_snapshot_data(multi5, "multi5")

  pred_multi <- predict(fit, ci = FALSE)
  pred_ave <- predict(fit, ci = FALSE, est_method = "arithmetic")

  expect_identical(pred_ave[pred_ave$proportion == 0.05, ]$est, ave5$est)
  expect_identical(pred_multi[pred_ave$proportion == 0.05, ]$est, multi5$est)
})
