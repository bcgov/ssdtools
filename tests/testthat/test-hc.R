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

test_that("hc", {
  fits <- ssd_fit_dists(ssddata::ccme_boron)
  set.seed(102)
  hc <- ssd_hc(fits, ci = TRUE, nboot = 10, average = FALSE, samples = TRUE)
  expect_s3_class(hc, "tbl")
  expect_snapshot_data(hc, "hc")
})

test_that("hc estimate with censored data same number of 2parameters", {
  data <- ssddata::ccme_boron
  data$right <- data$Conc
  data$Conc[c(3,6,8)] <- NA
  fit <- ssd_fit_dists(data, right = "right", dists = c("lnorm", "llogis"))
  hc <- ssd_hc(fit)
  expect_snapshot_data(hc, "censored_2ll")
})

test_that("hc estimate with censored data same number of 5parameters", {
  data <- ssddata::ccme_boron
  data$right <- data$Conc
  data$Conc[c(3,6,8)] <- NA
  fit <- ssd_fit_dists(data, right = "right", dists = c("lnorm_lnorm", "llogis_llogis"))
  hc <- ssd_hc(fit)
  expect_snapshot_data(hc, "censored_5ll")
})

test_that("hc not estimate with different number of parameters", {
  data <- ssddata::ccme_boron
  data$right <- data$Conc
  data$Conc[c(3,6,8)] <- NA
  fit <- ssd_fit_dists(data, right = "right", dists = c("lnorm", "lnorm_lnorm"))
  hc_each <- ssd_hc(fit, average = FALSE)
  expect_snapshot_data(hc_each, "censored_each")
  expect_warning(hc_ave <- ssd_hc(fit), 
                 "Model averaged estimates cannot be calculated for censored data when the distributions have different numbers of parameters.")
  expect_snapshot_data(hc_ave, "censored_ave")
})

test_that("ssd_hc list must be named", {
  
  chk::expect_chk_error(ssd_hc(list()))
})

test_that("ssd_hc list names must be unique", {
  
  chk::expect_chk_error(ssd_hc(list("lnorm" = NULL, "lnorm" = NULL)))
})

test_that("ssd_hc list handles zero length list", {
  
  hc <- ssd_hc(structure(list(), .Names = character(0)))
  expect_s3_class(hc, "tbl_df")
  expect_identical(colnames(hc), c("dist", "proportion", "est", "se", "lcl", "ucl", "wt", "nboot", "pboot", "samples"))
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
  
  hc <- ssd_hc(list("lnorm" = NULL), proportion = c(1, 99)/100)
  expect_s3_class(hc, "tbl_df")
  expect_identical(colnames(hc), c("dist", "proportion", "est", "se", "lcl", "ucl", "wt", "nboot", "pboot"))
  expect_identical(hc$proportion, c(1, 99)/100)
  expect_equal(hc$dist, c("lnorm", "lnorm"))
  expect_equal(hc$est, c(0.097651733070336, 10.2404736563121))
  expect_identical(hc$se, c(NA_real_, NA_real_))
})

test_that("ssd_hc list works partial percent values", {
  hc <- ssd_hc(list("lnorm" = NULL), proportion = c(50.5)/100)
  expect_s3_class(hc, "tbl_df")
  expect_identical(colnames(hc), c("dist", "proportion", "est", "se", "lcl", "ucl", "wt", "nboot", "pboot"))
  expect_identical(hc$proportion, 50.5/100)
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
  expect_identical(hc$proportion, c(5, 5)/100)
  expect_equal(hc$dist, c("lnorm", "llogis"))
  expect_equal(hc$est, c(0.193040816698737, 0.0526315789473684))
  expect_equal(hc$se, c(NA_real_, NA_real_))
})

test_that("ssd_hc list works multiple NULL distributions with multiple percent", {
  
  hc <- ssd_hc(list("lnorm" = NULL, "llogis" = NULL), proportion = c(1, 99)/100)
  expect_s3_class(hc, "tbl_df")
  expect_identical(colnames(hc), c("dist", "proportion", "est", "se", "lcl", "ucl", "wt", "nboot", "pboot"))
  expect_equal(hc$dist, c("lnorm", "lnorm", "llogis", "llogis"))
  expect_identical(hc$proportion, c(1, 99, 1, 99)/100)
  expect_equal(hc$est, c(0.097651733070336, 10.2404736563121, 0.0101010101010101, 98.9999999999999))
  expect_equal(hc$se, c(NA_real_, NA_real_, NA_real_, NA_real_))
})

test_that("ssd_hc fitdists works zero length percent", {
  
  fits <- ssd_fit_dists(ssddata::ccme_boron, dists = "lnorm")
  
  hc <- ssd_hc(fits, proportion = numeric(0))
  expect_s3_class(hc, class = "tbl_df")
  expect_identical(colnames(hc), c("dist", "proportion", "est", "se", "lcl", "ucl", "wt", "nboot", "pboot", "samples"))
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
  
  hc <- ssd_hc(fits, proportion = c(1, 99)/100)
  expect_s3_class(hc, "tbl_df")
  expect_snapshot_data(hc, "hc138")
})

test_that("ssd_hc fitdists works fractions", {
  
  fits <- ssd_fit_dists(ssddata::ccme_boron, dists = "lnorm")
  
  hc <- ssd_hc(fits, proportion = 50.5/100)
  expect_s3_class(hc, "tbl_df")
  expect_snapshot_data(hc, "hc505")
})

test_that("ssd_hc fitdists averages", {
  
  fits <- ssd_fit_dists(ssddata::ccme_boron)
  hc <- ssd_hc(fits, ci_method = "weighted_arithmetic", multi_est = FALSE)
  expect_s3_class(hc, "tbl_df")
  expect_snapshot_data(hc, "hc145")
})

test_that("ssd_hc fitdists correctly averages", {
  fits <- ssd_fit_dists(ssddata::aims_molybdenum_marine, dists = c("lgumbel", "lnorm_lnorm"))
  hc <- ssd_hc(fits, average = FALSE, ci_method = "rmulti")
  expect_equal(hc$est, c(3881.17238083968, 5540.69271009251), tolerance = 1e-6)
  expect_equal(hc$wt, c(0.0968427088339105, 0.90315729116609))
  hc_avg <- ssd_hc(fits, ci_method = "weighted_arithmetic", multi_est = FALSE)
  expect_equal(hc_avg$est, sum(hc$est * hc$wt))
})

test_that("ssd_hc fitdists averages single dist by multiple percent", {
  
  fits <- ssd_fit_dists(ssddata::ccme_boron, dists = "lnorm")
  
  hc <- ssd_hc(fits, average = TRUE, proportion = 1:99/100)
  expect_s3_class(hc, "tbl_df")
  expect_snapshot_data(hc, "hc153")
})

test_that("ssd_hc fitdists not average single dist by multiple percent gives whole numeric", {
  
  fits <- ssd_fit_dists(ssddata::ccme_boron, dists = "lnorm")
  
  hc <- ssd_hc(fits, average = FALSE, proportion = 1:99/100)
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
  hc <- ssd_hc(fits, ci_method = "weighted_arithmetic")
  hc_rescale <- ssd_hc(fits_rescale, ci_method = "weighted_arithmetic")
  expect_equal(hc_rescale, hc, tolerance = 1e-04)
})

test_that("ssd_hc fitdists cis", {
  
  fits <- ssd_fit_dists(ssddata::ccme_boron, dists = "lnorm")
  
  set.seed(102)
  hc <- ssd_hc(fits, ci = TRUE, ci_method = "weighted_arithmetic", samples = TRUE)
  expect_s3_class(hc, "tbl_df")
  
  expect_snapshot_data(hc, "hc_cis")
})

test_that("ssd_hc fitdists cis level = 0.8", {
  
  fits <- ssd_fit_dists(ssddata::ccme_boron, dists = "lnorm")
  
  set.seed(102)
  hc <- ssd_hc(fits, ci = TRUE, level = 0.8, ci_method = "weighted_arithmetic", samples = TRUE)
  expect_s3_class(hc, "tbl_df")
  
  expect_snapshot_data(hc, "hc_cis_level08")
})

test_that("ssd_hc doesn't calculate cis with inconsistent censoring", {
  
  data <- ssddata::ccme_boron
  data$Conc2 <- data$Conc
  data$Conc[1] <- 0.5
  data$Conc2[1] <- 1.0
  fits <- ssd_fit_dists(data, dists = c("lnorm", "llogis"))
  set.seed(10)
  hc <- ssd_hc(fits, ci = TRUE, nboot = 10, ci_method = "weighted_arithmetic")
  expect_equal(hc$se, 0.475836654747499, tolerance = 1e-6)
  
  fits <- ssd_fit_dists(data, right = "Conc2", dists = c("lnorm", "llogis"))
  set.seed(10)
  expect_warning(
    hc <- ssd_hc(fits, ci = TRUE, nboot = 10),
    "^Parametric CIs cannot be calculated for inconsistently censored data[.]$"
  )
  expect_identical(hc$se, NA_real_)
})

test_that("ssd_hc works with fully left censored data", {
  data <- ssddata::ccme_boron
  data$Conc2 <- data$Conc
  data$Conc <- 0
  fits <- ssd_fit_dists(data, right = "Conc2", dists = c("lnorm", "llogis"))
  set.seed(10)
  hc <- ssd_hc(fits, ci = TRUE, nboot = 10, ci_method = "weighted_arithmetic")
  expect_equal(hc$se, 0.000753288708572757, tolerance = 1e-6)
})

test_that("ssd_hc not work partially censored even if all same left", {
  
  data <- ssddata::ccme_boron
  data$Conc2 <- data$Conc
  data$Conc <- 0.1
  fits <- ssd_fit_dists(data, right = "Conc2", dists = c("lnorm", "llogis"))
  set.seed(10)
  expect_warning(
    hc <- ssd_hc(fits, ci = TRUE, nboot = 10),
    "^Parametric CIs cannot be calculated for inconsistently censored data[.]$"
  )
})

test_that("ssd_hc doesn't works with inconsisently censored data", {
  
  data <- ssddata::ccme_boron
  data$Conc2 <- data$Conc
  data$Conc <- 0
  data$Conc[1] <- data$Conc2[1] / 2
  fits <- ssd_fit_dists(data, right = "Conc2", dists = c("lnorm", "llogis"))
  set.seed(10)
  expect_warning(
    hc <- ssd_hc(fits, ci = TRUE, nboot = 10),
    "^Parametric CIs cannot be calculated for inconsistently censored data[.]$"
  )
})

test_that("ssd_hc same with equally weighted data", {
  
  data <- ssddata::ccme_boron
  data$Weight <- rep(1, nrow(data))
  fits <- ssd_fit_dists(data, weight = "Weight", dists = "lnorm")
  set.seed(10)
  hc <- ssd_hc(fits, ci = TRUE, nboot = 10)
  
  data$Weight <- rep(2, nrow(data))
  fits2 <- ssd_fit_dists(data, weight = "Weight", dists = "lnorm")
  set.seed(10)
  hc2 <- ssd_hc(fits2, ci = TRUE, nboot = 10)
  expect_equal(hc2, hc)
})

test_that("ssd_hc calculates cis with equally weighted data", {
  data <- ssddata::ccme_boron
  data$Weight <- rep(2, nrow(data))
  fits <- ssd_fit_dists(data, weight = "Weight", dists = "lnorm")
  set.seed(10)
  hc <- ssd_hc(fits, ci = TRUE, nboot = 10, ci_method = "weighted_arithmetic", samples = TRUE)
  expect_snapshot_data(hc, "hcici")
})

test_that("ssd_hc calculates cis in parallel but one distribution", {
  local_multisession()
  data <- ssddata::ccme_boron
  fits <- ssd_fit_dists(data, dists = "lnorm")
  set.seed(10)
  hc <- ssd_hc(fits, ci = TRUE, nboot = 10, ci_method = "weighted_arithmetic", samples = TRUE)
  expect_snapshot_data(hc, "hcici_multi")
})

test_that("ssd_hc calculates cis with two distributions", {
  data <- ssddata::ccme_boron
  fits <- ssd_fit_dists(data, dists = c("lnorm", "llogis"))
  set.seed(10)
  hc <- ssd_hc(fits, ci = TRUE, nboot = 10, ci_method = "weighted_arithmetic")
  expect_equal(hc$se, 0.511475169043532, tolerance = 1e-6)
})

test_that("ssd_hc calculates cis in parallel with two distributions", {
  local_multisession()
  data <- ssddata::ccme_boron
  fits <- ssd_fit_dists(data, dists = c("lnorm", "llogis"))
  set.seed(10)
  hc <- ssd_hc(fits, ci = TRUE, nboot = 10, ci_method = "weighted_arithmetic")
  expect_equal(hc$se, 0.511475169043532, tolerance = 1e-6)
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
  set.seed(10)
  hc <- ssd_hc(fits, ci = TRUE, nboot = 10)
  set.seed(10)
  hc_10 <- ssd_hc(fits_10, ci = TRUE, nboot = 10)
  expect_equal(hc_10, hc)
})

test_that("ssd_hc effect with higher weight two distributions", {
  data <- ssddata::ccme_boron
  data$Weight <- rep(1, nrow(data))
  fits <- ssd_fit_dists(data, weight = "Weight", dists = c("lnorm", "llogis"))
  data$Weight <- rep(10, nrow(data))
  fits_10 <- ssd_fit_dists(data, weight = "Weight", dists = c("lnorm", "llogis"))
  set.seed(10)
  hc <- ssd_hc(fits, ci = TRUE, nboot = 10, ci_method = "weighted_arithmetic", multi_est = FALSE)
  set.seed(10)
  hc_10 <- ssd_hc(fits_10, ci = TRUE, nboot = 10, ci_method = "weighted_arithmetic", multi_est = FALSE)
  expect_equal(hc$est, 1.6490386909599, tolerance = 1e-6)
  expect_equal(hc_10$est, 1.68117856793665, tolerance = 1e-6)
  expect_equal(hc$se, 0.511475588315084, tolerance = 1e-6)
  expect_equal(hc_10$se, 0.455819671683407, tolerance = 1e-6)
})

test_that("ssd_hc cis with non-convergence", {
  set.seed(99)
  conc <- ssd_rlnorm_lnorm(100, meanlog1 = 0, meanlog2 = 1, sdlog1 = 1 / 10, sdlog2 = 1 / 10, pmix = 0.2)
  data <- data.frame(Conc = conc)
  fit <- ssd_fit_dists(data, dists = "lnorm_lnorm", min_pmix = 0.15)
  expect_identical(attr(fit, "min_pmix"), 0.15)
  hc15 <- ssd_hc(fit, ci = TRUE, nboot = 100, min_pboot = 0.9, ci_method = "weighted_arithmetic")
  attr(fit, "min_pmix") <- 0.3
  expect_identical(attr(fit, "min_pmix"), 0.3)
  hc30 <- ssd_hc(fit, ci = TRUE, nboot = 100, min_pboot = 0.9, ci_method = "weighted_arithmetic")
  expect_s3_class(hc30, "tbl")
  expect_snapshot_data(hc30, "hc_30")
})

test_that("ssd_hc cis with error and multiple dists", {
  
  set.seed(99)
  conc <- ssd_rlnorm_lnorm(30, meanlog1 = 0, meanlog2 = 1, sdlog1 = 1 / 10, sdlog2 = 1 / 10, pmix = 0.2)
  data <- data.frame(Conc = conc)
  fit <- ssd_fit_dists(data, dists = c("lnorm", "llogis_llogis"), min_pmix = 0.1)
  expect_identical(attr(fit, "min_pmix"), 0.1)
  set.seed(99)
  expect_warning(hc_err_two <- ssd_hc(fit, ci = TRUE, nboot = 100, average = FALSE, delta = 100))
  expect_snapshot_boot_data(hc_err_two, "hc_err_two")
  set.seed(99)
  expect_warning(hc_err_avg <- ssd_hc(fit,
                                      ci = TRUE, nboot = 100,
                                      delta = 100, ci_method = "weighted_arithmetic"
  ))
  expect_snapshot_boot_data(hc_err_avg, "hc_err_avg")
})

test_that("ssd_hc with 1 bootstrap", {
  
  fit <- ssd_fit_dists(ssddata::ccme_boron, dists = "lnorm")
  set.seed(10)
  hc <- ssd_hc(fit, ci = TRUE, nboot = 1, ci_method = "weighted_arithmetic")
  expect_snapshot_data(hc, "hc_1")
})

test_that("ssd_hc parametric and non-parametric small sample size", {
  fit <- ssd_fit_burrlioz(ssddata::ccme_boron)
  set.seed(47)
  hc_para_small <- ssd_hc(fit, nboot = 10, ci = TRUE, samples = TRUE)
  expect_snapshot_data(hc_para_small, "hc_para_small")
  set.seed(47)
  hc_nonpara_small <- ssd_hc(fit, nboot = 10, ci = TRUE, parametric = FALSE, samples = TRUE)
  expect_snapshot_data(hc_para_small, "hc_para_small")
})

test_that("ssd_hc_burrlioz gets estimates with invpareto", {
  
  fit <- ssd_fit_burrlioz(ssddata::ccme_boron)
  set.seed(47)
  hc_boron <- ssd_hc(fit, nboot = 10, ci = TRUE, min_pboot = 0, samples = TRUE)
  expect_snapshot_data(hc_boron, "hc_boron")
})

test_that("ssd_hc_burrlioz gets estimates with burrIII3", {
  
  set.seed(99)
  data <- data.frame(Conc = ssd_rburrIII3(30))
  fit <- ssd_fit_burrlioz(data)
  expect_identical(names(fit), "burrIII3")
  set.seed(49)
  hc_burrIII3 <- ssd_hc(fit, nboot = 10, ci = TRUE, min_pboot = 0, samples = TRUE)
  expect_snapshot_data(hc_burrIII3, "hc_burrIII3")
})

test_that("ssd_hc_burrlioz gets estimates with burrIII3 parametric", {
  
  set.seed(99)
  data <- data.frame(Conc = ssd_rburrIII3(30))
  fit <- ssd_fit_burrlioz(data)
  expect_identical(names(fit), "burrIII3")
  set.seed(49)
  hc_burrIII3 <- ssd_hc(fit,
                        nboot = 10, ci = TRUE, min_pboot = 0,
                        parametric = TRUE, samples = TRUE
  )
  expect_snapshot_data(hc_burrIII3, "hc_burrIII3_parametric")
})

test_that("ssd_hc passing all boots ccme_chloride lnorm_lnorm", {
  
  fits <- ssd_fit_dists(ssddata::ccme_chloride,
                        min_pmix = 0.0001, at_boundary_ok = TRUE,
                        dists = c("lnorm_lnorm", "llogis_llogis")
  )
  
  set.seed(102)
  expect_warning(hc <- ssd_hc(fits, ci = TRUE, nboot = 1000, average = FALSE))
  expect_s3_class(hc, "tbl_df")
  expect_snapshot_boot_data(hc, "hc_cis_chloride50")
})

test_that("ssd_hc save_to", {
  dir <- withr::local_tempdir()
  
  fits <- ssd_fit_dists(ssddata::ccme_boron, dist = "lnorm")
  set.seed(102)
  hc <- ssd_hc(fits, nboot = 3, ci = TRUE, save_to = dir, samples = TRUE)
  expect_snapshot_data(hc, "hc_save_to")
  expect_identical(list.files(dir), c("data_000000000_multi.csv", "data_000000001_multi.csv", "data_000000002_multi.csv", 
                                      "data_000000003_multi.csv", "estimates_000000000_multi.rds", 
                                      "estimates_000000001_multi.rds", "estimates_000000002_multi.rds", 
                                      "estimates_000000003_multi.rds"))
  data <- read.csv(file.path(dir, "data_000000000_multi.csv"))
  expect_snapshot_data(hc, "hc_save_to1data")
  boot1 <- read.csv(file.path(dir, "data_000000001_multi.csv"))
  expect_snapshot_data(hc, "hc_save_to1")
  ests <- readRDS(file.path(dir, "estimates_000000000_multi.rds"))
  ests1 <- readRDS(file.path(dir, "estimates_000000001_multi.rds"))
  
  expect_identical(names(ests), names(ests1))
  expect_identical(names(ests), c("burrIII3.weight", "burrIII3.shape1", "burrIII3.shape2", "burrIII3.scale", 
                                  "gamma.weight", "gamma.shape", "gamma.scale", "gompertz.weight", 
                                  "gompertz.location", "gompertz.shape", "invpareto.weight", "invpareto.shape", 
                                  "invpareto.scale", "lgumbel.weight", "lgumbel.locationlog", "lgumbel.scalelog", 
                                  "llogis.weight", "llogis.locationlog", "llogis.scalelog", "llogis_llogis.weight", 
                                  "llogis_llogis.locationlog1", "llogis_llogis.scalelog1", "llogis_llogis.locationlog2", 
                                  "llogis_llogis.scalelog2", "llogis_llogis.pmix", "lnorm.weight", 
                                  "lnorm.meanlog", "lnorm.sdlog", "lnorm_lnorm.weight", "lnorm_lnorm.meanlog1", 
                                  "lnorm_lnorm.sdlog1", "lnorm_lnorm.meanlog2", "lnorm_lnorm.sdlog2", 
                                  "lnorm_lnorm.pmix", "weibull.weight", "weibull.shape", "weibull.scale"
  ))
})

test_that("ssd_hc save_to ci_method = weighted_bootstrap", {
  dir <- withr::local_tempdir()
  
  fits <- ssd_fit_dists(ssddata::ccme_boron, dist = "lnorm")
  set.seed(102)
  hc <- ssd_hc(fits, nboot = 3, ci = TRUE, save_to = dir, ci_method = "weighted_arithmetic", samples = TRUE)
  expect_snapshot_data(hc, "hc_save_to_not_multi")
  expect_identical(list.files(dir), c("data_000000000_lnorm.csv", "data_000000001_lnorm.csv", "data_000000002_lnorm.csv", 
                                      "data_000000003_lnorm.csv", "estimates_000000000_lnorm.rds", 
                                      "estimates_000000001_lnorm.rds", "estimates_000000002_lnorm.rds", 
                                      "estimates_000000003_lnorm.rds"))
  data1 <- read.csv(file.path(dir, "data_000000001_lnorm.csv"))
  expect_snapshot_data(hc, "hc_save_to1_not_multi")
})

test_that("ssd_hc save_to ci_method = weighted_bootstrap default", {
  dir <- withr::local_tempdir()
  
  fits <- ssd_fit_dists(ssddata::ccme_boron)
  set.seed(102)
  hc <- ssd_hc(fits, nboot = 1, ci = TRUE, save_to = dir, ci_method = "weighted_arithmetic", multi_est = FALSE, samples = TRUE)
  expect_snapshot_data(hc, "hc_save_to_not_multi_default")
  expect_identical(sort(list.files(dir)), 
                   sort(c("data_000000000_gamma.csv", "data_000000000_lgumbel.csv", "data_000000000_llogis.csv", 
                          "data_000000000_lnorm_lnorm.csv", "data_000000000_lnorm.csv", 
                          "data_000000000_weibull.csv", "data_000000001_gamma.csv", "data_000000001_lgumbel.csv", 
                          "data_000000001_llogis.csv", "data_000000001_lnorm_lnorm.csv", 
                          "data_000000001_lnorm.csv", "data_000000001_weibull.csv", "estimates_000000000_gamma.rds", 
                          "estimates_000000000_lgumbel.rds", "estimates_000000000_llogis.rds", 
                          "estimates_000000000_lnorm_lnorm.rds", "estimates_000000000_lnorm.rds", 
                          "estimates_000000000_weibull.rds", "estimates_000000001_gamma.rds", 
                          "estimates_000000001_lgumbel.rds", "estimates_000000001_llogis.rds", 
                          "estimates_000000001_lnorm_lnorm.rds", "estimates_000000001_lnorm.rds", 
                          "estimates_000000001_weibull.rds")))
  boot1 <- read.csv(file.path(dir, "data_000000001_lnorm.csv"))
  expect_snapshot_data(hc, "hc_save_to1_not_multi_default")
})

test_that("ssd_hc save_to rescale", {
  dir <- withr::local_tempdir()
  
  fits <- ssd_fit_dists(ssddata::ccme_boron, dist = "lnorm", rescale = TRUE)
  set.seed(102)
  hc <- ssd_hc(fits, nboot = 3, ci = TRUE, save_to = dir, samples = TRUE)
  expect_snapshot_data(hc, "hc_save_to_rescale")
  expect_identical(list.files(dir), c("data_000000000_multi.csv", "data_000000001_multi.csv", "data_000000002_multi.csv", 
                                      "data_000000003_multi.csv", "estimates_000000000_multi.rds", 
                                      "estimates_000000001_multi.rds", "estimates_000000002_multi.rds", 
                                      "estimates_000000003_multi.rds"))
  boot1 <- read.csv(file.path(dir, "data_000000001_multi.csv"))
  expect_snapshot_data(hc, "hc_save_to1_rescale")
})

test_that("ssd_hc save_to lnorm 1", {
  dir <- withr::local_tempdir()
  
  fits <- ssd_fit_dists(ssddata::ccme_boron, dist = "lnorm")
  set.seed(102)
  hc <- ssd_hc(fits, nboot = 1, ci = TRUE, save_to = dir, samples = TRUE)
  expect_snapshot_data(hc, "hc_save_to11")
  expect_identical(list.files(dir), c("data_000000000_multi.csv", "data_000000001_multi.csv", "estimates_000000000_multi.rds", 
                                      "estimates_000000001_multi.rds"))
  boot1 <- read.csv(file.path(dir, "data_000000001_multi.csv"))
  fit1 <- ssd_fit_dists(boot1, dist = "lnorm", left = "left", right = "right", weight = "weight")
  est <- ssd_hc(fit1)$est
  expect_identical(hc$lcl, est)
  expect_identical(hc$lcl, hc$ucl)
})

test_that("ssd_hc save_to replaces", {
  dir <- withr::local_tempdir()
  
  fits <- ssd_fit_dists(ssddata::ccme_boron, dist = "lnorm")
  set.seed(102)
  hc <- ssd_hc(fits, nboot = 1, ci = TRUE, save_to = dir)
  expect_identical(list.files(dir), c("data_000000000_multi.csv", "data_000000001_multi.csv", "estimates_000000000_multi.rds", 
                                      "estimates_000000001_multi.rds"))
  boot <- read.csv(file.path(dir, "data_000000001_multi.csv"))
  hc2 <- ssd_hc(fits, nboot = 1, ci = TRUE, save_to = dir)
  expect_identical(list.files(dir), c("data_000000000_multi.csv", "data_000000001_multi.csv", "estimates_000000000_multi.rds", 
                                      "estimates_000000001_multi.rds"))
  boot2 <- read.csv(file.path(dir, "data_000000001_multi.csv"))
  expect_snapshot_data(boot, "hc_boot1_replace")
  expect_snapshot_data(boot2, "hc_boot2_replace")
})

test_that("ssd_hc fix_weight", {
  fits <- ssd_fit_dists(ssddata::ccme_boron, dist = c("lnorm", "lgumbel"))
  
  set.seed(102)
  hc_unfix <- ssd_hc(fits, nboot = 100, ci = TRUE, ci_method = "rmulti", samples = TRUE)
  expect_snapshot_data(hc_unfix, "hc_unfix")
  
  set.seed(102)
  hc_fix <- ssd_hc(fits, nboot = 100, ci = TRUE, ci_method = "rmulti_fixp", samples = TRUE)
  expect_snapshot_data(hc_fix, "hc_fix")
})

test_that("ssd_hc multiple values", {
  fits <- ssd_fit_dists(ssddata::ccme_boron, dist = c("lnorm", "lgumbel"))
  
  set.seed(102)
  hc_unfix <- ssd_hc(fits, proportion = c(5, 10) / 100, nboot = 100, ci = TRUE, ci_method = "rmulti", samples = TRUE)
  expect_snapshot_data(hc_unfix, "hc_unfixmulti")
  
  set.seed(102)
  hc_fix <- ssd_hc(fits, proportion = c(5, 10) / 100, nboot = 100, ci = TRUE, ci_method = "rmulti_fixp", samples = TRUE)
  expect_snapshot_data(hc_fix, "hc_fixmulti")
})

test_that("ssd_hc multiple values save_to", {
  dir <- withr::local_tempdir()
  
  fits <- ssd_fit_dists(ssddata::ccme_boron, dist = c("lnorm", "lgumbel"))
  
  set.seed(102)
  hc <- ssd_hc(fits, proportion = c(5, 10) / 100, nboot = 2, save_to = dir, ci = TRUE)
  expect_identical(list.files(dir), c("data_000000000_multi.csv", "data_000000001_multi.csv", "data_000000002_multi.csv", 
                                      "estimates_000000000_multi.rds", "estimates_000000001_multi.rds", 
                                      "estimates_000000002_multi.rds"))
})

test_that("ssd_hc not multi_ci save_to", {
  dir <- withr::local_tempdir()
  
  fits <- ssd_fit_dists(ssddata::ccme_boron, dist = c("lnorm", "lgumbel"))
  
  set.seed(102)
  hc <- ssd_hc(fits, nboot = 2, ci_method = "weighted_arithmetic", save_to = dir, ci = TRUE)
  expect_identical(list.files(dir), c("data_000000000_lgumbel.csv", "data_000000000_lnorm.csv", "data_000000001_lgumbel.csv", 
                                      "data_000000001_lnorm.csv", "data_000000002_lgumbel.csv", "data_000000002_lnorm.csv", 
                                      "estimates_000000000_lgumbel.rds", "estimates_000000000_lnorm.rds", 
                                      "estimates_000000001_lgumbel.rds", "estimates_000000001_lnorm.rds", 
                                      "estimates_000000002_lgumbel.rds", "estimates_000000002_lnorm.rds"
  ))
})

test_that("ssd_hc identical if in parallel", {
  data <- ssddata::ccme_boron
  fits <- ssd_fit_dists(data, dists = c("lnorm", "llogis"))
  set.seed(10)
  hc <- ssd_hc(fits, ci = TRUE, nboot = 500)
  local_multisession(workers = 2)
  set.seed(10)
  hc2 <- ssd_hc(fits, ci = TRUE, nboot = 500)
  expect_equal(hc, hc2, tolerance = 1e-6)
})

test_that("hc multi_ci false weighted", {
  fits <- ssd_fit_dists(ssddata::ccme_boron, dists = c("lnorm", "gamma"))
  set.seed(102)
  hc <- ssd_hc(fits, ci = TRUE, nboot = 10, average = TRUE, samples = TRUE, ci_method = "weighted_bootstrap", multi_est = FALSE, min_pboot = 0.8)
  expect_s3_class(hc, "tbl")
  expect_snapshot_data(hc, "hc_weighted_bootstrap")
})

test_that("hc multis match", {
  fits <- ssd_fit_dists(ssddata::ccme_boron, dists = c("lnorm", "gamma"))
  set.seed(102)
  hc_tf <- ssd_hc(fits, ci = TRUE, nboot = 10, average = TRUE, multi_est = TRUE, ci_method = "weighted_bootstrap")
  set.seed(102)
  hc_ft <- ssd_hc(fits, ci = TRUE, nboot = 10, average = TRUE, multi_est = FALSE, ci_method = "rmulti_fixp")
  set.seed(102)
  hc_ff <- ssd_hc(fits, ci = TRUE, nboot = 10, average = TRUE, multi_est = FALSE, ci_method = "weighted_bootstrap")
  set.seed(102)
  hc_tt <- ssd_hc(fits, ci = TRUE, nboot = 10, average = TRUE, multi_est = TRUE, ci_method = "rmulti_fixp")
  
  expect_identical(hc_tf$est, hc_tt$est)
  expect_identical(hc_ft$est, hc_ff$est)
  expect_identical(hc_ft$se, hc_tt$se)
  expect_identical(hc_ff$se, hc_tf$se)
})

test_that("hc weighted bootie", {
  fits <- ssd_fit_dists(ssddata::ccme_boron)
  set.seed(102)
  hc_weighted2 <- ssd_hc(fits, ci = TRUE, nboot = 10, average = TRUE, multi_est = FALSE, ci_method = "weighted_bootstrap",
                        samples = TRUE)
  set.seed(102)
  hc_unweighted2 <- ssd_hc(fits, ci = TRUE, nboot = 10, average = TRUE, multi_est = FALSE, ci_method = "weighted_arithmetic", samples = TRUE)
  
  expect_identical(hc_weighted2$est, hc_unweighted2$est)
  expect_identical(length(hc_weighted2$samples[[1]]), 11L)
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
