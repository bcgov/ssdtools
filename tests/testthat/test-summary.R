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

test_that("summary tmbfit", {
  data <- ssddata::ccme_boron
  fits <- ssd_fit_dists(data, dists = "lnorm", rescale = FALSE)
  summary <- summary(fits$lnorm)
  expect_s3_class(summary, "summary_tmbfit")
  expect_identical(names(summary), c("dist", "estimates"))
  expect_identical(summary$dist, "lnorm")
  expect_snapshot_value(summary$estimates, style = "deparse")
})

test_that("summary fitdists", {
  data <- ssddata::ccme_boron
  fits <- ssd_fit_dists(data,
    dists = "lnorm", rescale = FALSE,
    min_pmix = 0.01
  )
  summary <- summary(fits)
  expect_s3_class(summary, "summary_fitdists")
  expect_identical(names(summary), c("fits", "censoring", "nrow", "rescaled", "weighted", "unequal", "min_pmix"))
  expect_identical(summary$censoring, c(0, Inf))
  expect_identical(summary$nrow, 28L)
  expect_identical(summary$min_pmix, 0.01)
  expect_identical(summary$rescaled, 1)
  expect_identical(summary$weighted, 1)
  expect_false(summary$unequal)
})

test_that("summary partially left censored", {
  data <- ssddata::ccme_boron
  data$right <- data$Conc
  data$Conc[c(3, 6, 8)] <- NA

  fits <- ssd_fit_dists(data, dists = "lnorm", right = "right")
  summary <- summary(fits)
  expect_s3_class(summary, "summary_fitdists")
  expect_identical(names(summary), c("fits", "censoring", "nrow", "rescaled", "weighted", "unequal", "min_pmix"))
  expect_identical(summary$censoring, c(NA_real_, NA_real_))
  expect_identical(summary$nrow, 28L)
  expect_equal(summary$min_pmix, 0.107142857)
  expect_identical(summary$rescaled, 1)
  expect_identical(summary$weighted, 1)
  expect_false(summary$unequal)
})

test_that("summary partiaally right censored", {
  data <- ssddata::ccme_boron
  data$right <- data$Conc
  data$right[c(3, 6, 8)] <- NA

  fits <- ssd_fit_dists(data, dists = "lnorm", right = "right")
  summary <- summary(fits)
  expect_s3_class(summary, "summary_fitdists")
  expect_identical(names(summary), c("fits", "censoring", "nrow", "rescaled", "weighted", "unequal", "min_pmix"))
  expect_identical(summary$censoring, c(NA_real_, NA_real_))
  expect_identical(summary$nrow, 28L)
  expect_equal(summary$min_pmix, 0.107142857)
  expect_identical(summary$rescaled, 1)
  expect_identical(summary$weighted, 1)
  expect_false(summary$unequal)
})

test_that("summary fitdists with multiple dists", {
  data <- ssddata::ccme_boron
  fits <- ssd_fit_dists(data, rescale = TRUE)
  summary <- summary(fits)
  expect_s3_class(summary, "summary_fitdists")
  expect_identical(names(summary), c("fits", "censoring", "nrow", "rescaled", "weighted", "unequal", "min_pmix"))
  expect_identical(summary$censoring, c(0, Inf))
  expect_identical(summary$nrow, 28L)
  expect_equal(summary$rescaled, 8.40832920383116)
  expect_identical(summary$weighted, 1)
  expect_false(summary$unequal)
})

test_that("summary fitdists with partially censored, rescaled, unequally weighted data", {
  data <- ssddata::ccme_boron
  data$Mass <- seq_len(nrow(data))
  data$Other <- data$Conc
  data$Conc[2] <- NA
  fits <- ssd_fit_dists(data, right = "Other", weight = "Mass", rescale = TRUE, dists = "lnorm")
  summary <- summary(fits)
  expect_s3_class(summary, "summary_fitdists")
  expect_identical(names(summary), c("fits", "censoring", "nrow", "rescaled", "weighted", "unequal", "min_pmix"))
  expect_equal(summary$censoring, c(NA_real_, NA_real_))
  expect_identical(summary$nrow, 28L)
  expect_equal(summary$rescaled, 8.40832920383116)
  expect_identical(summary$weighted, 28)
  expect_true(summary$unequal)
})

test_that("summary fitdists with left censored, rescaled, unequally weighted data", {
  data <- ssddata::ccme_boron
  data$Mass <- seq_len(nrow(data))
  data$Other <- data$Conc
  data <- ssd_censor_data(data, right = "Other", censoring = c(2.5, Inf))
  fits <- ssd_fit_dists(data, right = "Other", weight = "Mass", rescale = TRUE, dists = "lnorm")
  summary <- summary(fits)
  expect_s3_class(summary, "summary_fitdists")
  expect_identical(names(summary), c("fits", "censoring", "nrow", "rescaled", "weighted", "unequal", "min_pmix"))
  expect_equal(summary$censoring, c(2.5, Inf))
  expect_identical(summary$nrow, 28L)
  expect_equal(summary$rescaled, 13.2947358003083)
  expect_identical(summary$weighted, 28)
  expect_true(summary$unequal)
})

test_that("summary weighted if equal weights but not 1", {
  data <- ssddata::ccme_boron
  data$Mass <- 2
  fits <- ssd_fit_dists(data, weight = "Mass", dists = "lnorm")
  summary <- summary(fits)
  expect_s3_class(summary, "summary_fitdists")
  expect_identical(summary$weighted, 2)
  expect_false(summary$unequal)
})

test_that("summary not weighted if equal weights but not 1 and reweighted", {
  data <- ssddata::ccme_boron
  data$Mass <- 2
  fits <- ssd_fit_dists(data, weight = "Mass", reweight = TRUE, dists = "lnorm")
  summary <- summary(fits)
  expect_s3_class(summary, "summary_fitdists")
  expect_identical(summary$weighted, 1)
  expect_false(summary$unequal)
})

test_that("summary min_pmix 0.1", {
  data <- ssddata::ccme_boron
  fits <- ssd_fit_dists(data, dists = "lnorm", min_pmix = 0.1)
  summary <- summary(fits)
  expect_s3_class(summary, "summary_fitdists")
  expect_identical(summary$min_pmix, 0.1)
})
