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

test_that("hp", {
  skip_on_os("linux") # FIXME
  fits <- ssd_fit_dists(ssddata::ccme_boron)

  set.seed(102)
  hp <- ssd_hp(fits, conc = 1, ci = TRUE, nboot = 10, average = FALSE)
  expect_s3_class(hp, "tbl")
  expect_snapshot_data(hp, "hp")
})

test_that("hp fitdists works with zero length conc", {
  skip_on_os("linux") # FIXME
  fits <- ssd_fit_dists(ssddata::ccme_boron, dists = "lnorm")

  hp <- ssd_hp(fits, numeric(0))
  expect_s3_class(hp, "tbl_df")
  expect_identical(colnames(hp), c("dist", "conc", "est", "se", "lcl", "ucl", "wt", "nboot", "pboot"))
  expect_equal(hp$dist, character(0))
  expect_identical(hp$conc, numeric(0))
  expect_equal(hp$est, numeric(0))
  expect_equal(hp$se, numeric(0))
  expect_equal(hp$wt, numeric(0))
})

test_that("hp fitdist works with missing conc", {
  skip_on_os("linux") # FIXME
  fits <- ssd_fit_dists(ssddata::ccme_boron, dists = "lnorm")

  hp <- ssd_hp(fits, NA_real_)
  expect_s3_class(hp, "tbl_df")
  expect_snapshot_data(hp, "hp41")
})

test_that("hp fitdist works with 0 conc", {
  skip_on_os("linux") # FIXME
  fits <- ssd_fit_dists(ssddata::ccme_boron, dists = "lnorm")

  hp <- ssd_hp(fits, 0)
  expect_s3_class(hp, "tbl_df")
  expect_snapshot_data(hp, "hp49")
})

test_that("hp fitdist works with negative conc", {
  skip_on_os("linux") # FIXME
  fits <- ssd_fit_dists(ssddata::ccme_boron, dists = "lnorm")

  hp <- ssd_hp(fits, -1)
  expect_s3_class(hp, "tbl_df")
  expect_snapshot_data(hp, "hp57")
})

test_that("hp fitdist works with -Inf conc", {
  skip_on_os("linux") # FIXME
  fits <- ssd_fit_dists(ssddata::ccme_boron, dists = "lnorm")

  hp <- ssd_hp(fits, -Inf)
  expect_s3_class(hp, "tbl_df")
  expect_snapshot_data(hp, "hp65")
})

test_that("hp fitdist works with Inf conc", {
  skip_on_os("linux") # FIXME
  fits <- ssd_fit_dists(ssddata::ccme_boron, dists = "lnorm")

  hp <- ssd_hp(fits, Inf)
  expect_s3_class(hp, "tbl_df")
  expect_snapshot_data(hp, "hp73")
})

test_that("hp fitdists works reasonable conc", {
  skip_on_os("linux") # FIXME
  fits <- ssd_fit_dists(ssddata::ccme_boron, dists = "lnorm")

  hp <- ssd_hp(fits, 1)
  expect_s3_class(hp, "tbl_df")
  expect_snapshot_data(hp, "hp81")
})

test_that("hp fitdists works with multiple concs", {
  skip_on_os("linux") # FIXME
  fits <- ssd_fit_dists(ssddata::ccme_boron, dists = "lnorm")

  hp <- ssd_hp(fits, c(2.5, 1))
  expect_s3_class(hp, "tbl_df")
  expect_snapshot_data(hp, "hp89")
})

test_that("hp fitdists works with cis", {
  skip_on_os("linux") # FIXME
  fits <- ssd_fit_dists(ssddata::ccme_boron, dists = "lnorm")

  set.seed(10)
  hp <- ssd_hp(fits, 1, ci = TRUE, nboot = 10)
  expect_s3_class(hp, "tbl_df")
  expect_snapshot_data(hp, "hp98")
})

test_that("hp fitdists works with multiple dists", {
  skip_on_os("linux") # FIXME
  fits <- ssd_fit_dists(ssddata::ccme_boron)

  hp <- ssd_hp(fits, 1)
  expect_s3_class(hp, "tbl_df")
  expect_snapshot_data(hp, "hp106")
})

test_that("hp fitdists works not average multiple dists", {
  skip_on_os("linux") # FIXME
  fits <- ssd_fit_dists(ssddata::ccme_boron)

  hp <- ssd_hp(fits, 1, average = FALSE)
  expect_s3_class(hp, "tbl_df")
  expect_snapshot_data(hp, "hp114")
})

test_that("hp fitdists gives different answer with model averaging as hc not same for either", {
  skip_on_os("linux") # FIXME
  library(ssdtools)
  library(ssddata)
  library(testthat)
  data <- ssddata::aims_molybdenum_marine

  fits_lgumbel <- ssd_fit_dists(data, dists = "lgumbel")
  expect_equal(ssd_hp(fits_lgumbel, ssd_hc(fits_lgumbel, percent = 5)$est)$est, 5)

  fits_lnorm_lnorm <- ssd_fit_dists(data, dists = "lnorm_lnorm")
  expect_equal(ssd_hp(fits_lnorm_lnorm, ssd_hc(fits_lnorm_lnorm, percent = 5)$est)$est, 5)

  fits_both <- ssd_fit_dists(data, dists = c("lgumbel", "lnorm_lnorm"))
  expect_equal(ssd_hp(fits_both, ssd_hc(fits_both, percent = 5)$est)$est, 4.59188450624579)
})

test_that("ssd_hp fitdists correct for rescaling", {
  skip_on_os("linux") # FIXME
  fits <- ssd_fit_dists(ssddata::ccme_boron)
  fits_rescale <- ssd_fit_dists(ssddata::ccme_boron, rescale = TRUE)
  hp <- ssd_hp(fits, 1)
  hp_rescale <- ssd_hp(fits_rescale, 1)
  expect_equal(hp_rescale, hp, tolerance = 1e-05)
})

test_that("hp fitdists with no fitdists", {
  skip_on_os("linux") # FIXME
  x <- list()
  class(x) <- c("fitdists")
  hp <- ssd_hp(x, 1)
  expect_s3_class(hp, c("tbl_df", "tbl", "data.frame"))
  expect_snapshot_data(hp, "hp130")
})

test_that("ssd_hp doesn't calculate cis with inconsistent censoring", {
  skip_on_os("linux") # FIXME
  data <- ssddata::ccme_boron
  data$Conc2 <- data$Conc
  data$Conc[1] <- 0.5
  data$Conc2[1] <- 1.0
  fits <- ssd_fit_dists(data, dists = c("lnorm", "llogis"))
  set.seed(10)
  hp <- ssd_hp(fits, 1, ci = TRUE, nboot = 10)
  expect_equal(hp$se, 2.33001443428834)

  fits <- ssd_fit_dists(data, right = "Conc2", dists = c("lnorm", "llogis"))
  set.seed(10)
  expect_warning(
    hp <- ssd_hp(fits, 1, ci = TRUE, nboot = 10),
    "^Parametric CIs cannot be calculated for inconsistently censored data[.]$"
  )
  expect_identical(hp$se, NA_real_)
})

test_that("ssd_hp same with equally weighted data", {
  skip_on_os("linux") # FIXME
  data <- ssddata::ccme_boron
  data$Weight <- rep(1, nrow(data))
  fits <- ssd_fit_dists(data, weight = "Weight", dists = "lnorm")
  set.seed(10)
  hp <- ssd_hp(fits, 1, ci = TRUE, nboot = 10)

  data$Weight <- rep(2, nrow(data))
  fits2 <- ssd_fit_dists(data, weight = "Weight", dists = "lnorm")
  set.seed(10)
  hp2 <- ssd_hp(fits2, 1, ci = TRUE, nboot = 10)
  expect_equal(hp2, hp)
})

test_that("ssd_hp calculates cis with equally weighted data", {
  skip_on_os("linux") # FIXME
  data <- ssddata::ccme_boron
  data$Weight <- rep(2, nrow(data))
  fits <- ssd_fit_dists(data, weight = "Weight", dists = "lnorm")
  set.seed(10)
  hp <- ssd_hp(fits, 1, ci = TRUE, nboot = 10)
  expect_equal(hp$se, 1.76599243917916)
})

test_that("ssd_hp calculates cis with two distributions", {
  skip_on_os("linux") # FIXME
  data <- ssddata::ccme_boron
  fits <- ssd_fit_dists(data, dists = c("lnorm", "llogis"))
  set.seed(10)
  hp <- ssd_hp(fits, 1, ci = TRUE, nboot = 10)
  expect_equal(hp$se, 1.77625311677508)
})

test_that("ssd_hp calculates cis in parallel but one distribution", {
  skip_on_os("linux") # FIXME
  local_multisession()
  data <- ssddata::ccme_boron
  fits <- ssd_fit_dists(data, dists = "lnorm")
  set.seed(10)
  hp <- ssd_hp(fits, 1, ci = TRUE, nboot = 10)
  expect_equal(hp$se, 1.76599243917916)
})

test_that("ssd_hp calculates cis in parallel with two distributions", {
  skip_on_os("linux") # FIXME
  local_multisession()
  data <- ssddata::ccme_boron
  fits <- ssd_fit_dists(data, dists = c("lnorm", "llogis"))
  set.seed(10)
  hp <- ssd_hp(fits, 1, ci = TRUE, nboot = 10)
  expect_equal(hp$se, 1.77625311677508)
})

test_that("ssd_hp doesn't calculate cis with unequally weighted data", {
  skip_on_os("linux") # FIXME
  data <- ssddata::ccme_boron
  data$Weight <- rep(1, nrow(data))
  data$Weight[1] <- 2
  fits <- ssd_fit_dists(data, weight = "Weight", dists = "lnorm")
  expect_warning(
    hp <- ssd_hp(fits, 1, ci = TRUE, nboot = 10),
    "^Parametric CIs cannot be calculated for unequally weighted data[.]$"
  )
  expect_identical(hp$se, NA_real_)
})

test_that("ssd_hp no effect with higher weight one distribution", {
  skip_on_os("linux") # FIXME
  data <- ssddata::ccme_boron
  data$Weight <- rep(1, nrow(data))
  fits <- ssd_fit_dists(data, weight = "Weight", dists = "lnorm")
  data$Weight <- rep(10, nrow(data))
  fits_10 <- ssd_fit_dists(data, weight = "Weight", dists = "lnorm")
  set.seed(10)
  hp <- ssd_hp(fits, 3, ci = TRUE, nboot = 10)
  set.seed(10)
  hp_10 <- ssd_hp(fits_10, 3, ci = TRUE, nboot = 10)
  expect_equal(hp_10, hp)
})

test_that("ssd_hp effect with higher weight two distributions", {
  skip_on_os("linux") # FIXME
  data <- ssddata::ccme_boron
  data$Weight <- rep(1, nrow(data))
  fits <- ssd_fit_dists(data, weight = "Weight", dists = c("lnorm", "llogis"))
  data$Weight <- rep(10, nrow(data))
  fits_10 <- ssd_fit_dists(data, weight = "Weight", dists = c("lnorm", "llogis"))
  set.seed(10)
  hp <- ssd_hp(fits, 3, ci = TRUE, nboot = 10)
  set.seed(10)
  hp_10 <- ssd_hp(fits_10, 3, ci = TRUE, nboot = 10)
  expect_equal(hp$est, 11.7535819824013)
  expect_equal(hp_10$est, 11.9318338996079)
  expect_equal(hp$se, 5.90337387777387)
  expect_equal(hp_10$se, 6.1723994362764)
})

test_that("ssd_hp cis with non-convergence", {
  skip_on_os("linux") # FIXME
  set.seed(99)
  conc <- ssd_rlnorm_lnorm(100, meanlog1 = 0, meanlog2 = 1, sdlog1 = 1 / 10, sdlog2 = 1 / 10, pmix = 0.2)
  data <- data.frame(Conc = conc)
  fit <- ssd_fit_dists(data, dists = "lnorm_lnorm", min_pmix = 0.15)
  expect_identical(attr(fit, "min_pmix"), 0.15)
  hp15 <- ssd_hp(fit, conc = 1, ci = TRUE, nboot = 100, min_pboot = 0.98)
  attr(fit, "min_pmix") <- 0.3
  expect_identical(attr(fit, "min_pmix"), 0.3)
  hp30 <- ssd_hp(fit, conc = 1, ci = TRUE, nboot = 100, min_pboot = 0.96)
  expect_s3_class(hp30, "tbl")
  testthat::skip_on_os("windows")
  testthat::skip_on_os("linux")
  testthat::skip_on_os("solaris")
  expect_snapshot_boot_data(hp30, "hp_30")
})

test_that("ssd_hp cis with error", {
  skip_on_os("linux") # FIXME
  set.seed(99)
  conc <- ssd_rlnorm_lnorm(30, meanlog1 = 0, meanlog2 = 1, sdlog1 = 1 / 10, sdlog2 = 1 / 10, pmix = 0.2)
  data <- data.frame(Conc = conc)
  fit <- ssd_fit_dists(data, dists = "lnorm_lnorm", min_pmix = 0.1)
  expect_identical(attr(fit, "min_pmix"), 0.1)
  expect_warning(hp_err <- ssd_hp(fit, conc = 1, ci = TRUE, nboot = 100))
  expect_s3_class(hp_err, "tbl")
  testthat::skip_on_os("windows")
  testthat::skip_on_os("linux")
  testthat::skip_on_os("solaris")
  expect_snapshot_boot_data(hp_err, "hp_err_na")
  hp_err <- ssd_hp(fit, conc = 1, ci = TRUE, nboot = 100, min_pboot = 0.92)
  expect_s3_class(hp_err, "tbl")
  testthat::skip_on_ci()
  testthat::skip_on_cran()
  expect_snapshot_boot_data(hp_err, "hp_err")
})

test_that("ssd_hp cis with error and multiple dists", {
  skip_on_os("linux") # FIXME
  set.seed(99)
  conc <- ssd_rlnorm_lnorm(30, meanlog1 = 0, meanlog2 = 1, sdlog1 = 1 / 10, sdlog2 = 1 / 10, pmix = 0.2)
  data <- data.frame(Conc = conc)
  fit <- ssd_fit_dists(data, dists = c("lnorm", "llogis_llogis"), min_pmix = 0.1)
  expect_identical(attr(fit, "min_pmix"), 0.1)
  set.seed(99)
  expect_warning(hp_err_two <- ssd_hp(fit,
    conc = 1, ci = TRUE, nboot = 100, average = FALSE,
    delta = 100
  ))
  testthat::skip_on_os("windows")
  testthat::skip_on_os("linux")
  testthat::skip_on_os("solaris")
  expect_snapshot_boot_data(hp_err_two, "hp_err_two")
  set.seed(99)
  expect_warning(hp_err_avg <- ssd_hp(fit,
    conc = 1, ci = TRUE, nboot = 100,
    delta = 100
  ))
  testthat::skip_on_os("windows")
  testthat::skip_on_os("linux")
  testthat::skip_on_os("solaris")
  expect_snapshot_boot_data(hp_err_avg, "hp_err_avg")
})

test_that("ssd_hp with 1 bootstrap", {
  skip_on_os("linux") # FIXME
  fit <- ssd_fit_dists(ssddata::ccme_boron, dists = "lnorm")
  set.seed(10)
  hp <- ssd_hp(fit, 1, ci = TRUE, nboot = 1)
  expect_snapshot_data(hp, "hp_1")
})

test_that("ssd_hp comparable parametric and non-parametric big sample size", {
  skip_on_os("linux") # FIXME
  set.seed(99)
  data <- data.frame(Conc = ssd_rlnorm(10000, 2, 1))
  fit <- ssd_fit_dists(data, dists = "lnorm")
  set.seed(10)
  hp_para <- ssd_hp(fit, 1, ci = TRUE, nboot = 10)
  testthat::skip_on_ci()
  testthat::skip_on_cran()
  expect_snapshot_boot_data(hp_para, "hp_para")
  set.seed(10)
  hp_nonpara <- ssd_hp(fit, 1, ci = TRUE, nboot = 10, parametric = FALSE)
  testthat::skip_on_ci()
  testthat::skip_on_cran()
  expect_snapshot_boot_data(hp_nonpara, "hp_nonpara")
})
