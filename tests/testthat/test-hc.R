# Copyright 2015-2023 Province of British Columbia
# Copyright 2021 Environment and Climate Change Canada
# Copyright 2023-2025 Australian Government Department of Climate Change,
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

test_that("hc", {
  fits <- ssd_fit_dists(ssddata::ccme_boron)
  withr::with_seed(102, {
    hc <- ssd_hc(fits, ci = TRUE, nboot = 10, average = FALSE, samples = TRUE)
  })
  expect_snapshot_data(hc, "hc")
})

test_that("hc level", {
  fits <- ssd_fit_dists(ssddata::ccme_boron)
  withr::local_seed(102)
  hc <- ssd_hc(fits, ci = TRUE, level = 0.89, nboot = 10, average = FALSE, samples = TRUE)
  expect_snapshot_data(hc, "hc89")
})

test_that("hc estimate with censored data same number of 2parameters", {
  data <- ssddata::ccme_boron
  data$right <- data$Conc
  data$Conc[c(3, 6, 8)] <- NA
  fit <- ssd_fit_dists(data, right = "right", dists = c("lnorm", "llogis"))
  hc <- ssd_hc(fit)
  expect_snapshot_data(hc, "censored_2ll")
})

test_that("hc estimate with censored data same number of 5parameters", {
  data <- ssddata::ccme_boron
  data$right <- data$Conc
  data$Conc[c(3, 6, 8)] <- NA
  fit <- ssd_fit_dists(data, right = "right", dists = c("lnorm_lnorm", "llogis_llogis"))
  hc <- ssd_hc(fit)
  expect_snapshot_data(hc, "censored_5ll")
})

test_that("hc not estimate with different number of parameters", {
  data <- ssddata::ccme_boron
  data$right <- data$Conc
  data$Conc[c(3, 6, 8)] <- NA
  fit <- ssd_fit_dists(data, right = "right", dists = c("lnorm", "lnorm_lnorm"))
  hc_each <- ssd_hc(fit, average = FALSE)
  expect_snapshot_data(hc_each, "censored_each")
  expect_warning(
    hc_ave <- ssd_hc(fit),
    "Model averaged estimates cannot be calculated for censored data when the distributions have different numbers of parameters."
  )
  expect_snapshot_data(hc_ave, "censored_ave")
})

test_that("ssd_hc list must be named", {
  chk::expect_chk_error(ssd_hc(list()))
})

test_that("ssd_hc list names must be unique", {
  chk::expect_chk_error(ssd_hc(list("lnorm" = NULL, "lnorm" = NULL)))
})

test_that("hc with missing data", {
  data <- ssddata::ccme_boron
  data$Conc[1] <- NA_real_
  chk::expect_chk_error(ssd_fit_dists(data))
})

test_that("ssd_hc list handles zero length list", {
  hc <- ssd_hc(structure(list(), .Names = character(0)))
  expect_s3_class(hc, "tbl_df")
  expect_identical(colnames(hc), c("dist", "proportion", "est", "se", "lcl", "ucl", "wt", "est_method", "ci_method", "boot_method", "nboot", "pboot", "samples"))
  expect_identical(hc$dist, character(0))
  expect_identical(hc$proportion, numeric(0))
  expect_identical(hc$se, numeric(0))
})

test_that("ssd_hc list works null values handles zero length list", {
  hc <- ssd_hc(list("lnorm" = NULL))
  expect_s3_class(hc, "tbl_df")
  expect_identical(colnames(hc), c("dist", "proportion", "est", "se", "lcl", "ucl", "wt", "nboot", "pboot"))
  expect_equal(hc$dist, "lnorm")
  expect_identical(hc$proportion, 0.05)
  expect_equal(hc$est, 0.193040816698737)
  expect_equal(hc$se, NA_real_)
})

test_that("ssd_hc list works multiple percent values", {
  hc <- ssd_hc(list("lnorm" = NULL), proportion = c(1, 99) / 100)
  expect_s3_class(hc, "tbl_df")
  expect_identical(colnames(hc), c("dist", "proportion", "est", "se", "lcl", "ucl", "wt", "nboot", "pboot"))
  expect_identical(hc$proportion, c(1, 99) / 100)
  expect_equal(hc$dist, c("lnorm", "lnorm"))
  expect_equal(hc$est, c(0.097651733070336, 10.2404736563121))
  expect_identical(hc$se, c(NA_real_, NA_real_))
})

test_that("ssd_hc list works partial percent values", {
  hc <- ssd_hc(list("lnorm" = NULL), proportion = c(50.5) / 100)
  expect_s3_class(hc, "tbl_df")
  expect_identical(colnames(hc), c("dist", "proportion", "est", "se", "lcl", "ucl", "wt", "nboot", "pboot"))
  expect_identical(hc$proportion, 50.5 / 100)
  expect_equal(hc$dist, "lnorm")
  expect_equal(hc$est, 1.01261234261044)
  expect_identical(hc$se, NA_real_)
})

test_that("ssd_hc list works specified values", {
  hc <- ssd_hc(list("lnorm" = list(meanlog = 2, sdlog = 2)))
  expect_s3_class(hc, "tbl_df")
  expect_identical(colnames(hc), c("dist", "proportion", "est", "se", "lcl", "ucl", "wt", "nboot", "pboot"))
  expect_identical(hc$proportion, 0.05)
  expect_equal(hc$dist, "lnorm")
  expect_equal(hc$est, 0.275351379333677)
  expect_equal(hc$se, NA_real_)
})

test_that("ssd_hc list works multiple NULL distributions", {
  hc <- ssd_hc(list("lnorm" = NULL, "llogis" = NULL))
  expect_s3_class(hc, "tbl_df")
  expect_identical(colnames(hc), c("dist", "proportion", "est", "se", "lcl", "ucl", "wt", "nboot", "pboot"))
  expect_identical(hc$proportion, c(5, 5) / 100)
  expect_equal(hc$dist, c("lnorm", "llogis"))
  expect_equal(hc$est, c(0.193040816698737, 0.0526315789473684))
  expect_equal(hc$se, c(NA_real_, NA_real_))
})

test_that("ssd_hc list works multiple NULL distributions with multiple percent", {
  hc <- ssd_hc(list("lnorm" = NULL, "llogis" = NULL), proportion = c(1, 99) / 100)
  expect_s3_class(hc, "tbl_df")
  expect_identical(colnames(hc), c("dist", "proportion", "est", "se", "lcl", "ucl", "wt", "nboot", "pboot"))
  expect_equal(hc$dist, c("lnorm", "lnorm", "llogis", "llogis"))
  expect_identical(hc$proportion, c(1, 99, 1, 99) / 100)
  expect_equal(hc$est, c(0.097651733070336, 10.2404736563121, 0.0101010101010101, 98.9999999999999))
  expect_equal(hc$se, c(NA_real_, NA_real_, NA_real_, NA_real_))
})

test_that("ssd_hc fitdists works zero length percent", {
  fits <- ssd_fit_dists(ssddata::ccme_boron, dists = "lnorm")

  hc <- ssd_hc(fits, proportion = numeric(0))
  expect_s3_class(hc, class = "tbl_df")
  expect_identical(colnames(hc), c("dist", "proportion", "est", "se", "lcl", "ucl", "wt", "est_method", "ci_method", "boot_method", "nboot", "pboot", "samples"))
  expect_equal(hc$dist, character(0))
  expect_identical(hc$proportion, numeric(0))
  expect_equal(hc$est, numeric(0))
  expect_equal(hc$se, numeric(0))
})

test_that("ssd_hc fitdists works NA percent", {
  fits <- ssd_fit_dists(ssddata::ccme_boron, dists = "lnorm")

  hc <- ssd_hc(fits, proportion = NA_real_)
  expect_s3_class(hc, "tbl_df")
  expect_snapshot_data(hc, "hc114")
})

test_that("ssd_hc fitdists works 0 percent", {
  fits <- ssd_fit_dists(ssddata::ccme_boron, dists = "lnorm")

  hc <- ssd_hc(fits, proportion = 0)
  expect_s3_class(hc, "tbl_df")
  expect_snapshot_data(hc, "hc122")
})

test_that("ssd_hc fitdists works 100 percent", {
  fits <- ssd_fit_dists(ssddata::ccme_boron, dists = "lnorm")

  hc <- ssd_hc(fits, proportion = 1)
  expect_s3_class(hc, "tbl_df")
  expect_snapshot_data(hc, "hc130")
})

test_that("ssd_hc fitdists works multiple percents", {
  fits <- ssd_fit_dists(ssddata::ccme_boron, dists = "lnorm")

  hc <- ssd_hc(fits, proportion = c(1, 99) / 100)
  expect_s3_class(hc, "tbl_df")
  expect_snapshot_data(hc, "hc138")
})

test_that("ssd_hc fitdists works fractions", {
  fits <- ssd_fit_dists(ssddata::ccme_boron, dists = "lnorm")

  hc <- ssd_hc(fits, proportion = 50.5 / 100)
  expect_s3_class(hc, "tbl_df")
  expect_snapshot_data(hc, "hc505")
})

test_that("ssd_hc fitdists works odds", {
  data <- ssddata::ccme_boron
  data$Conc <- plogis(data$Conc) * 0.9
  withr::local_seed(99)
  fits <- ssd_fit_dists(data, dists = "lnorm", rescale = "odds")
  withr::local_seed(99)
  hc <- ssd_hc(fits, average = FALSE, est_method = "multi", ci = TRUE, nboot = 10L)
  expect_snapshot_data(hc, "hcwet")
})

test_that("ssd_hc fitdists works odds 0.8", {
  data <- ssddata::ccme_boron
  data$Conc <- plogis(data$Conc) * 0.9
  withr::local_seed(99)
  fits <- ssd_fit_dists(data, dists = "lnorm", rescale = "odds", odds_max = 0.8)
  withr::local_seed(99)
  hc <- ssd_hc(fits, average = FALSE, est_method = "multi", ci = TRUE, nboot = 10L)
  expect_snapshot_data(hc, "hcwet08")
})

test_that("ssd_hc fitdists averages", {
  fits <- ssd_fit_dists(ssddata::ccme_boron)
  hc <- ssd_hc(fits, ci_method = "MACL", est_method = "arithmetic")
  expect_s3_class(hc, "tbl_df")
  expect_snapshot_data(hc, "hc145")
})

test_that("ssd_hc fitdists geomean", {
  fits <- ssd_fit_dists(ssddata::ccme_boron)
  hc <- ssd_hc(fits, ci_method = "MACL", est_method = "geometric")
  expect_s3_class(hc, "tbl_df")
  expect_snapshot_data(hc, "hc145g")
})

test_that("ssd_hc fitdists correctly averages", {
  fits <- ssd_fit_dists(ssddata::aims_molybdenum_marine,
    dists = c("lgumbel", "lnorm_lnorm"),
    min_pmix = 0
  )
  hc <- ssd_hc(fits, average = FALSE, ci_method = "multi_free")
  expect_snapshot_value(hc$est, style = "deparse")
  expect_snapshot_value(hc$wt, style = "deparse")
  hc_avg <- ssd_hc(fits, ci_method = "MACL", est_method = "arithmetic")
  expect_equal(hc_avg$est, sum(hc$est * hc$wt))
})

test_that("ssd_hc fitdists averages single dist by multiple percent", {
  fits <- ssd_fit_dists(ssddata::ccme_boron, dists = "lnorm")

  hc <- ssd_hc(fits, average = TRUE, proportion = 1:99 / 100)
  expect_s3_class(hc, "tbl_df")
  expect_snapshot_data(hc, "hc153")
})

test_that("ssd_hc fitdists not average single dist by multiple percent gives whole numeric", {
  fits <- ssd_fit_dists(ssddata::ccme_boron, dists = "lnorm")

  hc <- ssd_hc(fits, average = FALSE, proportion = 1:99 / 100)
  expect_s3_class(hc, "tbl_df")
  expect_snapshot_data(hc, "hc161")
})

test_that("ssd_hc fitdists not average", {
  fits <- ssd_fit_dists(ssddata::ccme_boron)
  hc <- ssd_hc(fits, average = FALSE)
  expect_s3_class(hc, "tbl_df")
  expect_snapshot_data(hc, "hc168")
})

test_that("ssd_hc fitdists correct for rescaling", {
  fits <- ssd_fit_dists(ssddata::ccme_boron)
  fits_rescale <- ssd_fit_dists(ssddata::ccme_boron, rescale = TRUE)
  hc <- ssd_hc(fits, ci_method = "MACL")
  hc_rescale <- ssd_hc(fits_rescale, ci_method = "MACL")
  expect_equal(hc_rescale, hc, tolerance = 1e-04)
})

test_that("ssd_hc fitdists cis", {
  fits <- ssd_fit_dists(ssddata::ccme_boron, dists = "lnorm")
  withr::with_seed(102, {
    hc <- ssd_hc(fits, ci = TRUE, ci_method = "MACL", nboot = 10, samples = TRUE)
  })
  expect_snapshot_data(hc, "hc_cis")
})

test_that("ssd_hc fitdists cis level = 0.8", {
  fits <- ssd_fit_dists(ssddata::ccme_boron, dists = "lnorm")
  withr::with_seed(102, {
    hc <- ssd_hc(fits, ci = TRUE, level = 0.8, ci_method = "MACL", nboot = 10, samples = TRUE)
  })
  expect_snapshot_data(hc, "hc_cis_level08")
})

test_that("ssd_hc doesn't calculate cis with inconsistent censoring", {
  data <- ssddata::ccme_boron
  data$Conc2 <- data$Conc
  data$Conc[1] <- 0.5
  data$Conc2[1] <- 1.0
  fits <- ssd_fit_dists(data, dists = c("lnorm", "llogis"))
  withr::with_seed(10, {
    hc <- ssd_hc(fits, ci = TRUE, nboot = 10, ci_method = "MACL")
  })
  expect_snapshot_value(hc$se, style = "deparse")

  fits <- ssd_fit_dists(data, right = "Conc2", dists = c("lnorm", "llogis"))
  withr::with_seed(10, {
    expect_warning(
      hc <- ssd_hc(fits, ci = TRUE, nboot = 10),
      "^Parametric CIs cannot be calculated for censored data[.]$"
    )
  })
  expect_identical(hc$se, NA_real_)
})

test_that("ssd_hc works with fully left censored data", {
  data <- ssddata::ccme_boron
  data$Conc2 <- data$Conc
  data$Conc <- 0
  fits <- ssd_fit_dists(data, right = "Conc2", dists = c("lnorm", "llogis"))
  withr::with_seed(10, {
    expect_warning(
      hc <- ssd_hc(fits, ci = TRUE, nboot = 10, ci_method = "MACL"),
      "^Parametric CIs cannot be calculated for censored data[.]$"
    )
  })
  expect_snapshot_data(hc, "fullyleft")
})

test_that("ssd_hc warns with partially left censored data", {
  data <- ssddata::ccme_boron
  data$right <- data$Conc
  data$Conc[c(3, 6, 8)] <- NA

  withr::with_seed(100, {
    fits <- ssd_fit_dists(data, dists = "lnorm", right = "right")
    expect_warning(
      hc <- ssd_hc(fits, ci = TRUE, nboot = 10, average = FALSE),
      "Parametric CIs cannot be calculated for censored data\\."
    )
  })
  expect_snapshot_data(hc, "partialeft")
})

test_that("ssd_hc works with fully left censored data", {
  data <- ssddata::ccme_boron
  data$right <- data$Conc
  data$right[data$Conc < 4] <- 4
  data$Conc[data$Conc < 4] <- NA

  withr::with_seed(100, {
    fits <- ssd_fit_dists(data, dists = "lnorm", right = "right")
    expect_warning(
      hc <- ssd_hc(fits, ci = TRUE, nboot = 10, average = FALSE),
      "^Parametric CIs cannot be calculated for censored data\\.$"
    )
  })
  expect_snapshot_data(hc, "partialeftfull")
})

test_that("ssd_hc works with partially left censored data non-parametric", {
  data <- ssddata::ccme_boron
  data$right <- data$Conc
  data$Conc[c(3, 6, 8)] <- NA

  withr::with_seed(100, {
    fits <- ssd_fit_dists(data, dists = "lnorm", right = "right")
    hc <- ssd_hc(fits, ci = TRUE, nboot = 10, average = FALSE, parametric = FALSE)
  })
  expect_snapshot_data(hc, "partialeftnonpara")
  expect_gt(hc$ucl, hc$est)
})

test_that("ssd_hc not work partially censored even if all same left", {
  data <- ssddata::ccme_boron
  data$Conc2 <- data$Conc
  data$Conc <- 0.1
  fits <- ssd_fit_dists(data, right = "Conc2", dists = c("lnorm", "llogis"))
  withr::with_seed(10, {
    expect_warning(
      hc <- ssd_hc(fits, ci = TRUE, nboot = 10),
      "^Parametric CIs cannot be calculated for censored data[.]$"
    )
  })
})

test_that("ssd_hc doesn't works with inconsisently censored data", {
  data <- ssddata::ccme_boron
  data$Conc2 <- data$Conc
  data$Conc <- 0
  data$Conc[1] <- data$Conc2[1] / 2
  fits <- ssd_fit_dists(data, right = "Conc2", dists = c("lnorm", "llogis"))
  withr::with_seed(10, {
    expect_warning(
      hc <- ssd_hc(fits, ci = TRUE, nboot = 10),
      "^Parametric CIs cannot be calculated for censored data[.]$"
    )
  })
})

test_that("ssd_hc same with equally weighted data", {
  data <- ssddata::ccme_boron
  data$Weight <- rep(1, nrow(data))
  fits <- ssd_fit_dists(data, weight = "Weight", dists = "lnorm")
  withr::with_seed(10, {
    hc <- ssd_hc(fits, ci = TRUE, nboot = 10)
  })

  data$Weight <- rep(2, nrow(data))
  fits2 <- ssd_fit_dists(data, weight = "Weight", dists = "lnorm")
  withr::with_seed(10, {
    hc2 <- ssd_hc(fits2, ci = TRUE, nboot = 10)
  })
  expect_equal(hc2, hc)
})

test_that("ssd_hc calculates cis with equally weighted data", {
  data <- ssddata::ccme_boron
  data$Weight <- rep(2, nrow(data))
  fits <- ssd_fit_dists(data, weight = "Weight", dists = "lnorm")
  withr::with_seed(10, {
    hc <- ssd_hc(fits, ci = TRUE, nboot = 10, ci_method = "MACL", samples = TRUE)
  })
  expect_snapshot_data(hc, "hcici")
})

test_that("ssd_hc calculates cis with two distributions", {
  data <- ssddata::ccme_boron
  fits <- ssd_fit_dists(data, dists = c("lnorm", "llogis"))
  withr::with_seed(10, {
    hc <- ssd_hc(fits, ci = TRUE, nboot = 10, ci_method = "MACL")
  })
  expect_snapshot_value(hc$se, style = "deparse")
})

test_that("ssd_hc doesn't calculate cis with unequally weighted data", {
  data <- ssddata::ccme_boron
  data$Weight <- rep(1, nrow(data))
  data$Weight[1] <- 2
  fits <- ssd_fit_dists(data, weight = "Weight", dists = "lnorm")
  expect_warning(
    hc <- ssd_hc(fits, ci = TRUE, nboot = 10),
    "^Parametric CIs cannot be calculated for unequally weighted data[.]$"
  )
  expect_identical(hc$se, NA_real_)
})

test_that("ssd_hc no effect with higher weight one distribution", {
  data <- ssddata::ccme_boron
  data$Weight <- rep(1, nrow(data))
  fits <- ssd_fit_dists(data, weight = "Weight", dists = "lnorm")
  data$Weight <- rep(10, nrow(data))
  fits_10 <- ssd_fit_dists(data, weight = "Weight", dists = "lnorm")
  withr::with_seed(10, {
    hc <- ssd_hc(fits, ci = TRUE, nboot = 10)
  })
  withr::with_seed(10, {
    hc_10 <- ssd_hc(fits_10, ci = TRUE, nboot = 10)
  })
  expect_equal(hc_10, hc)
})

test_that("ssd_hc effect with higher weight two distributions", {
  data <- ssddata::ccme_boron
  data$Weight <- rep(1, nrow(data))
  fits <- ssd_fit_dists(data, weight = "Weight", dists = c("lnorm", "llogis"))
  data$Weight <- rep(10, nrow(data))
  fits_10 <- ssd_fit_dists(data, weight = "Weight", dists = c("lnorm", "llogis"))
  withr::with_seed(10, {
    hc <- ssd_hc(fits, ci = TRUE, nboot = 10, ci_method = "MACL", est_method = "arithmetic")
  })
  withr::with_seed(10, {
    hc_10 <- ssd_hc(fits_10, ci = TRUE, nboot = 10, ci_method = "MACL", est_method = "arithmetic")
  })
  expect_snapshot_value(hc$est, style = "deparse")
  expect_snapshot_value(hc_10$est, style = "deparse")
  expect_snapshot_value(hc$se, style = "deparse")
  expect_snapshot_value(hc_10$se, style = "deparse")
})

test_that("ssd_hc cis with non-convergence", {
  withr::local_seed(99)
  conc <- ssd_rlnorm_lnorm(100, meanlog1 = 0, meanlog2 = 1, sdlog1 = 1 / 10, sdlog2 = 1 / 10, pmix = 0.2)
  data <- data.frame(Conc = conc)
  fit <- ssd_fit_dists(data, dists = "lnorm_lnorm", min_pmix = 0.15)
  expect_identical(attr(fit, "min_pmix"), 0.15)
  hc15 <- ssd_hc(fit, ci = TRUE, nboot = 10, min_pboot = 0.9, ci_method = "MACL")
  attr(fit, "min_pmix") <- 0.3
  expect_identical(attr(fit, "min_pmix"), 0.3)
  hc30 <- ssd_hc(fit, ci = TRUE, nboot = 10, min_pboot = 0.9, ci_method = "MACL")
  expect_snapshot_data(hc30, "hc_30")
})

test_that("ssd_hc with 1 bootstrap", {
  fit <- ssd_fit_dists(ssddata::ccme_boron, dists = "lnorm")
  withr::with_seed(10, {
    hc <- ssd_hc(fit, ci = TRUE, nboot = 1, ci_method = "MACL")
  })
  expect_snapshot_data(hc, "hc_1")
})

test_that("ssd_hc parametric and non-parametric small sample size", {
  fit <- ssd_fit_burrlioz(ssddata::ccme_boron)
  withr::with_seed(47, {
    hc_para_small <- ssd_hc(fit, nboot = 10, ci = TRUE, samples = TRUE)
  })
  expect_snapshot_data(hc_para_small, "hc_para_small")
  withr::with_seed(47, {
    hc_nonpara_small <- ssd_hc(fit, nboot = 10, ci = TRUE, parametric = FALSE, samples = TRUE)
  })
  expect_snapshot_data(hc_para_small, "hc_para_small")
})

test_that("ssd_hc_burrlioz gets estimates with invpareto", {
  fit <- ssd_fit_burrlioz(ssddata::ccme_boron)
  withr::with_seed(47, {
    hc_boron <- ssd_hc(fit, nboot = 10, ci = TRUE, min_pboot = 0, samples = TRUE)
  })
  expect_snapshot_data(hc_boron, "hc_boron")
})

test_that("ssd_hc_burrlioz gets estimates with burrIII3", {
  withr::with_seed(99, {
    data <- data.frame(Conc = ssd_rburrIII3(30))
  })
  fit <- ssd_fit_burrlioz(data)
  expect_identical(names(fit), "burrIII3")
  withr::with_seed(49, {
    hc_burrIII3 <- ssd_hc(fit, nboot = 10, ci = TRUE, min_pboot = 0, samples = TRUE)
  })
  expect_snapshot_data(hc_burrIII3, "hc_burrIII3")
})

test_that("ssd_hc_burrlioz gets estimates with burrIII3 parametric", {
  withr::with_seed(99, {
    data <- data.frame(Conc = ssd_rburrIII3(30))
  })
  fit <- ssd_fit_burrlioz(data)
  expect_identical(names(fit), "burrIII3")
  withr::with_seed(49, {
    hc_burrIII3 <- ssd_hc(fit,
      nboot = 10, ci = TRUE, min_pboot = 0,
      parametric = TRUE, samples = TRUE
    )
  })
  expect_snapshot_data(hc_burrIII3, "hc_burrIII3_parametric")
})

test_that("ssd_hc save_to", {
  dir <- withr::local_tempdir()

  fits <- ssd_fit_dists(ssddata::ccme_boron, dists = "lnorm")
  withr::with_seed(102, {
    hc <- ssd_hc(fits, nboot = 3, ci = TRUE, ci_method = "multi_fixed", save_to = dir, samples = TRUE)
  })
  expect_snapshot_data(hc, "hc_save_to")
  expect_identical(list.files(dir), c(
    "data_000000000_lnorm.csv", "data_000000001_lnorm.csv", "data_000000002_lnorm.csv",
    "data_000000003_lnorm.csv", "estimates_000000000_lnorm.rds",
    "estimates_000000001_lnorm.rds", "estimates_000000002_lnorm.rds",
    "estimates_000000003_lnorm.rds"
  ))
  data <- read.csv(file.path(dir, "data_000000000_lnorm.csv"))
  expect_snapshot_data(hc, "hc_save_to1data")
  boot1 <- read.csv(file.path(dir, "data_000000001_lnorm.csv"))
  expect_snapshot_data(hc, "hc_save_to1")
  ests <- readRDS(file.path(dir, "estimates_000000000_lnorm.rds"))
  ests1 <- readRDS(file.path(dir, "estimates_000000001_lnorm.rds"))

  expect_identical(names(ests), names(ests1))
  expect_identical(names(ests), c(
    "meanlog", "sdlog"
  ))
})

test_that("ssd_hc save_to ci_method = weighted_samples", {
  dir <- withr::local_tempdir()

  fits <- ssd_fit_dists(ssddata::ccme_boron, dists = "lnorm")
  withr::with_seed(102, {
    hc <- ssd_hc(fits, nboot = 3, ci = TRUE, save_to = dir, ci_method = "MACL", samples = TRUE)
  })
  expect_snapshot_data(hc, "hc_save_to_not_multi")
  expect_identical(list.files(dir), c(
    "data_000000000_lnorm.csv", "data_000000001_lnorm.csv", "data_000000002_lnorm.csv",
    "data_000000003_lnorm.csv", "estimates_000000000_lnorm.rds",
    "estimates_000000001_lnorm.rds", "estimates_000000002_lnorm.rds",
    "estimates_000000003_lnorm.rds"
  ))
  data1 <- read.csv(file.path(dir, "data_000000001_lnorm.csv"))
  expect_snapshot_data(hc, "hc_save_to1_not_multi")
})

test_that("ssd_hc save_to ci_method = weighted_samples default", {
  dir <- withr::local_tempdir()

  fits <- ssd_fit_dists(ssddata::ccme_boron)
  withr::with_seed(102, {
    hc <- ssd_hc(fits, nboot = 1, ci = TRUE, save_to = dir, ci_method = "MACL", est_method = "arithmetic", samples = TRUE)
  })
  expect_snapshot_data(hc, "hc_save_to_not_multi_default")
  expect_identical(
    sort(list.files(dir)),
    sort(c(
      "data_000000000_gamma.csv", "data_000000000_lgumbel.csv", "data_000000000_llogis.csv",
      "data_000000000_lnorm_lnorm.csv", "data_000000000_lnorm.csv",
      "data_000000000_weibull.csv", "data_000000001_gamma.csv", "data_000000001_lgumbel.csv",
      "data_000000001_llogis.csv", "data_000000001_lnorm_lnorm.csv",
      "data_000000001_lnorm.csv", "data_000000001_weibull.csv", "estimates_000000000_gamma.rds",
      "estimates_000000000_lgumbel.rds", "estimates_000000000_llogis.rds",
      "estimates_000000000_lnorm_lnorm.rds", "estimates_000000000_lnorm.rds",
      "estimates_000000000_weibull.rds", "estimates_000000001_gamma.rds",
      "estimates_000000001_lgumbel.rds", "estimates_000000001_llogis.rds",
      "estimates_000000001_lnorm_lnorm.rds", "estimates_000000001_lnorm.rds",
      "estimates_000000001_weibull.rds"
    ))
  )
  boot1 <- read.csv(file.path(dir, "data_000000001_lnorm.csv"))
  expect_snapshot_data(hc, "hc_save_to1_not_multi_default")
})

test_that("ssd_hc save_to rescale", {
  dir <- withr::local_tempdir()

  fits <- ssd_fit_dists(ssddata::ccme_boron, dists = "lnorm", rescale = TRUE)
  withr::with_seed(102, {
    hc <- ssd_hc(fits, nboot = 3, ci = TRUE, ci_method = "multi_fixed", save_to = dir, samples = TRUE)
  })
  expect_snapshot_data(hc, "hc_save_to_rescale")
  expect_identical(list.files(dir), c(
    "data_000000000_lnorm.csv", "data_000000001_lnorm.csv", "data_000000002_lnorm.csv",
    "data_000000003_lnorm.csv", "estimates_000000000_lnorm.rds",
    "estimates_000000001_lnorm.rds", "estimates_000000002_lnorm.rds",
    "estimates_000000003_lnorm.rds"
  ))
  boot1 <- read.csv(file.path(dir, "data_000000001_lnorm.csv"))
  expect_snapshot_data(hc, "hc_save_to1_rescale")
})

test_that("ssd_hc save_to lnorm 1", {
  dir <- withr::local_tempdir()

  fits <- ssd_fit_dists(ssddata::ccme_boron, dists = "lnorm")
  withr::with_seed(102, {
    hc <- ssd_hc(fits, nboot = 1, ci = TRUE, ci_method = "multi_fixed", save_to = dir, samples = TRUE)
  })
  expect_snapshot_data(hc, "hc_save_to11")
  expect_identical(list.files(dir), c(
    "data_000000000_lnorm.csv", "data_000000001_lnorm.csv", "estimates_000000000_lnorm.rds",
    "estimates_000000001_lnorm.rds"
  ))
  boot1 <- read.csv(file.path(dir, "data_000000001_lnorm.csv"))
  fit1 <- ssd_fit_dists(boot1, dists = "lnorm", left = "left", right = "right", weight = "weight")
  est <- ssd_hc(fit1)$est
  expect_snapshot_value(hc$lcl, est, style = "deparse")
  expect_identical(hc$lcl, hc$ucl)
})

test_that("ssd_hc save_to replaces", {
  dir <- withr::local_tempdir()

  fits <- ssd_fit_dists(ssddata::ccme_boron, dists = "lnorm")
  withr::with_seed(102, {
    hc <- ssd_hc(fits, nboot = 1, ci = TRUE, ci_method = "multi_fixed", save_to = dir)
    expect_identical(list.files(dir), c(
      "data_000000000_lnorm.csv", "data_000000001_lnorm.csv", "estimates_000000000_lnorm.rds",
      "estimates_000000001_lnorm.rds"
    ))
    boot <- read.csv(file.path(dir, "data_000000001_lnorm.csv"))
    hc2 <- ssd_hc(fits, nboot = 1, ci = TRUE, ci_method = "multi_fixed", save_to = dir)
  })
  expect_identical(list.files(dir), c(
    "data_000000000_lnorm.csv", "data_000000001_lnorm.csv", "estimates_000000000_lnorm.rds",
    "estimates_000000001_lnorm.rds"
  ))
  boot2 <- read.csv(file.path(dir, "data_000000001_lnorm.csv"))
  expect_snapshot_data(boot, "hc_boot1_replace")
  expect_snapshot_data(boot2, "hc_boot2_replace")
})

test_that("ssd_hc fix_weight", {
  fits <- ssd_fit_dists(ssddata::ccme_boron, dists = c("lnorm", "lgumbel"))

  withr::with_seed(102, {
    hc_unfix <- ssd_hc(fits, nboot = 10, ci = TRUE, ci_method = "multi_free", samples = TRUE)
  })
  expect_snapshot_data(hc_unfix, "hc_unfix")

  withr::with_seed(102, {
    hc_fix <- ssd_hc(fits, nboot = 10, ci = TRUE, ci_method = "multi_fixed", samples = TRUE)
  })
  expect_snapshot_data(hc_fix, "hc_fix")
})

test_that("ssd_hc multiple values", {
  fits <- ssd_fit_dists(ssddata::ccme_boron, dists = c("lnorm", "lgumbel"))

  withr::with_seed(102, {
    hc_unfix <- ssd_hc(fits, proportion = c(5, 10) / 100, nboot = 10, ci = TRUE, ci_method = "multi_free", samples = TRUE)
  })
  expect_snapshot_data(hc_unfix, "hc_unfixmulti")

  withr::with_seed(102, {
    hc_fix <- ssd_hc(fits, proportion = c(5, 10) / 100, nboot = 10, ci = TRUE, ci_method = "multi_fixed", samples = TRUE)
  })
  expect_snapshot_data(hc_fix, "hc_fixmulti")
})

test_that("ssd_hc multiple values save_to", {
  dir <- withr::local_tempdir()

  fits <- ssd_fit_dists(ssddata::ccme_boron, dists = c("lnorm", "lgumbel"))

  withr::with_seed(102, {
    hc <- ssd_hc(fits, proportion = c(5, 10) / 100, nboot = 2, save_to = dir, ci = TRUE, ci_method = "multi_fixed")
  })
  expect_identical(list.files(dir), c(
    "data_000000000_multi.csv", "data_000000001_multi.csv", "data_000000002_multi.csv",
    "estimates_000000000_multi.rds", "estimates_000000001_multi.rds",
    "estimates_000000002_multi.rds"
  ))
})

test_that("ssd_hc not multi_ci save_to", {
  dir <- withr::local_tempdir()

  fits <- ssd_fit_dists(ssddata::ccme_boron, dists = c("lnorm", "lgumbel"))

  withr::with_seed(102, {
    hc <- ssd_hc(fits, nboot = 2, ci_method = "MACL", save_to = dir, ci = TRUE)
  })
  expect_identical(list.files(dir), c(
    "data_000000000_lgumbel.csv", "data_000000000_lnorm.csv", "data_000000001_lgumbel.csv",
    "data_000000001_lnorm.csv", "data_000000002_lgumbel.csv", "data_000000002_lnorm.csv",
    "estimates_000000000_lgumbel.rds", "estimates_000000000_lnorm.rds",
    "estimates_000000001_lgumbel.rds", "estimates_000000001_lnorm.rds",
    "estimates_000000002_lgumbel.rds", "estimates_000000002_lnorm.rds"
  ))
})

test_that("hc multi_ci false weighted", {
  fits <- ssd_fit_dists(ssddata::ccme_boron, dists = c("lnorm", "gamma"))
  withr::local_seed(102)
  hc <- ssd_hc(fits, ci = TRUE, nboot = 10, average = TRUE, samples = TRUE, ci_method = "weighted_samples", est_method = "arithmetic", min_pboot = 0.8)
  expect_snapshot_data(hc, "hc_weighted_samples")
})

test_that("hc multis match", {
  fits <- ssd_fit_dists(ssddata::ccme_boron, dists = c("lnorm", "gamma"))
  withr::with_seed(102, {
    hc_tf <- ssd_hc(fits, ci = TRUE, nboot = 10, average = TRUE, ci_method = "weighted_samples")
  })
  withr::with_seed(102, {
    hc_ft <- ssd_hc(fits, ci = TRUE, nboot = 10, average = TRUE, est_method = "arithmetic", ci_method = "multi_fixed")
  })
  withr::with_seed(102, {
    hc_ff <- ssd_hc(fits, ci = TRUE, nboot = 10, average = TRUE, est_method = "arithmetic", ci_method = "weighted_samples")
  })
  withr::with_seed(102, {
    hc_tt <- ssd_hc(fits, ci = TRUE, nboot = 10, average = TRUE, ci_method = "multi_fixed")
  })

  expect_identical(hc_tf$est, hc_tt$est)
  expect_identical(hc_ft$est, hc_ff$est)
  expect_identical(hc_ft$se, hc_tt$se)
  expect_identical(hc_ff$se, hc_tf$se)
})

test_that("hc weighted bootie", {
  fits <- ssd_fit_dists(ssddata::ccme_boron)
  withr::with_seed(102, {
    hc_weighted2 <- ssd_hc(fits,
      ci = TRUE, nboot = 10, average = TRUE, est_method = "arithmetic", ci_method = "weighted_samples",
      samples = TRUE
    )
  })
  withr::with_seed(102, {
    hc_unweighted2 <- ssd_hc(fits, ci = TRUE, nboot = 10, average = TRUE, est_method = "arithmetic", ci_method = "MACL", samples = TRUE)
  })

  expect_identical(hc_weighted2$est, hc_unweighted2$est)
  expect_identical(length(hc_weighted2$samples[[1]]), 10L)
  expect_identical(length(hc_unweighted2$samples[[1]]), 60L)

  expect_snapshot_boot_data(hc_weighted2, "hc_weighted2")
  expect_snapshot_boot_data(hc_unweighted2, "hc_unweighted2")
})

test_that("hc percent deprecated", {
  fits <- ssd_fit_dists(ssddata::ccme_boron)
  lifecycle::expect_deprecated(hc <- ssd_hc(fits, percent = 10))
  hc2 <- ssd_hc(fits, proportion = 0.1)
  expect_identical(hc2, hc)

  lifecycle::expect_deprecated(hc <- ssd_hc(fits, percent = c(5, 10)))
  hc2 <- ssd_hc(fits, proportion = c(0.05, 0.1))
  expect_identical(hc2, hc)
})

test_that("hc proportion multiple decimal places", {
  fits <- ssd_fit_dists(ssddata::ccme_boron)
  hc2 <- ssd_hc(fits, proportion = 0.111111)
  expect_identical(hc2$proportion, 0.111111)
})

test_that("hc multi_est = TRUE deprecated", {
  fits <- ssd_fit_dists(ssddata::ccme_boron)
  withr::with_seed(10, {
    multi <- ssd_hc(fits)
  })

  withr::with_seed(10, {
    lifecycle::expect_deprecated({
      true <- ssd_hc(fits, multi_est = TRUE)
    })
  })
  expect_identical(true, multi)
})

test_that("hc est_method = FALSE deprecated and overrides est_method", {
  fits <- ssd_fit_dists(ssddata::ccme_boron)
  withr::with_seed(10, {
    arithmetic <- ssd_hc(fits, est_method = "arithmetic")
  })

  withr::with_seed(10, {
    lifecycle::expect_deprecated({
      false <- ssd_hc(fits, multi_est = FALSE, est_method = "geometric")
    })
  })

  expect_identical(false, arithmetic)
})

test_that("hc ci_method = 'weighted_arithmetic' deprecated for MACL", {
  fits <- ssd_fit_dists(ssddata::ccme_boron)
  withr::with_seed(10, {
    lifecycle::expect_deprecated({
      weighted_arithmetic <- ssd_hc(fits, ci_method = "weighted_arithmetic")
    })
  })

  withr::with_seed(10, {
    macl <- ssd_hc(fits, ci_method = "MACL")
  })

  expect_identical(macl, weighted_arithmetic)
})


test_that("ssd_hc fitdists arithmetic_samples ci", {
  fits <- ssd_fit_dists(ssddata::ccme_boron)
  hc <- ssd_hc(fits, ci_method = "arithmetic_samples", est_method = "arithmetic", nboot = 10, average = TRUE, ci = TRUE)
  expect_s3_class(hc, "tbl_df")
  expect_snapshot_data(hc, "hc_arithmetic_samples")
})
