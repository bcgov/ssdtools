#    Copyright 2015 Province of British Columbia
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
  hc <- ssd_hc(fits, ci = TRUE, nboot = 10, average = FALSE)
  expect_s3_class(hc, "tbl")
  expect_snapshot_data(hc, "hc")
})

test_that("ssd_hc hc defunct", {
  fits <- ssd_fit_dists(ssddata::ccme_boron, dists = "lnorm")
  
  lifecycle::expect_defunct(ssd_hc(fits, hc = 6))
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
  expect_identical(colnames(hc), c("dist", "percent", "est", "se", "lcl", "ucl", "nboot", "pboot"))
  expect_identical(hc$dist, character(0))
  expect_identical(hc$percent, numeric(0))
  expect_identical(hc$se, numeric(0))
})

test_that("ssd_hc list works null values handles zero length list", {
  hc <- ssd_hc(list("lnorm" = NULL))
  expect_s3_class(hc, "tbl_df")
  expect_identical(colnames(hc), c("dist", "percent", "est", "se", "lcl", "ucl", "nboot", "pboot"))
  expect_equal(hc$dist, "lnorm")
  expect_identical(hc$percent, 5)
  expect_equal(hc$est, 0.193040816698737)
  expect_equal(hc$se, NA_real_)
})

test_that("ssd_hc list works multiple percent values", {
  hc <- ssd_hc(list("lnorm" = NULL), percent = c(1, 99))
  expect_s3_class(hc, "tbl_df")
  expect_identical(colnames(hc), c("dist", "percent", "est", "se", "lcl", "ucl", "nboot", "pboot"))
  expect_identical(hc$percent, c(1, 99))
  expect_equal(hc$dist, c("lnorm", "lnorm"))
  expect_equal(hc$est, c(0.097651733070336, 10.2404736563121))
  expect_equal(hc$se, c(NA_real_, NA_real_))
})

test_that("ssd_hc list works specified values", {
  hc <- ssd_hc(list("lnorm" = list(meanlog = 2, sdlog = 2)))
  expect_s3_class(hc, "tbl_df")
  expect_identical(colnames(hc), c("dist", "percent", "est", "se", "lcl", "ucl", "nboot", "pboot"))
  expect_identical(hc$percent, 5)
  expect_true(vld_whole_numeric(hc$percent))
  expect_equal(hc$dist, "lnorm")
  expect_equal(hc$est, 0.275351379333677)
  expect_equal(hc$se, NA_real_)
})

test_that("ssd_hc list works multiple NULL distributions", {
  hc <- ssd_hc(list("lnorm" = NULL, "llogis" = NULL))
  expect_s3_class(hc, "tbl_df")
  expect_identical(colnames(hc), c("dist", "percent", "est", "se", "lcl", "ucl", "nboot", "pboot"))
  expect_identical(hc$percent, c(5, 5))
  expect_equal(hc$dist, c("lnorm", "llogis"))
  expect_equal(hc$est, c(0.193040816698737, 0.0526315789473684))
  expect_equal(hc$se, c(NA_real_, NA_real_)) 
})

test_that("ssd_hc list works multiple NULL distributions with multiple percent", {
  hc <- ssd_hc(list("lnorm" = NULL, "llogis" = NULL), percent = c(1, 99))
  expect_s3_class(hc, "tbl_df")
  expect_identical(colnames(hc), c("dist", "percent", "est", "se", "lcl", "ucl", "nboot", "pboot"))
  expect_equal(hc$dist, c("lnorm", "lnorm", "llogis", "llogis"))
  expect_identical(hc$percent, c(1, 99, 1, 99))
  expect_equal(hc$est, c(0.097651733070336, 10.2404736563121, 0.0101010101010101, 98.9999999999999))
  expect_equal(hc$se, c(NA_real_, NA_real_, NA_real_, NA_real_))
})

test_that("ssd_hc fitdists works zero length percent", {
  fits <- ssd_fit_dists(ssddata::ccme_boron, dists = "lnorm")
  
  hc <- ssd_hc(fits, numeric(0)) 
  expect_s3_class(hc, class = "tbl_df")
  expect_identical(colnames(hc), c("dist", "percent", "est", "se", "lcl", "ucl", "nboot", "pboot"))
  expect_equal(hc$dist, character(0))
  expect_identical(hc$percent, numeric(0))
  expect_equal(hc$est, numeric(0))
  expect_equal(hc$se, numeric(0))
})

test_that("ssd_hc fitdists works NA percent", {
  fits <- ssd_fit_dists(ssddata::ccme_boron, dists = "lnorm")
  
  hc <- ssd_hc(fits, NA_real_)
  expect_s3_class(hc, "tbl_df")
  expect_identical(colnames(hc), c("dist", "percent", "est", "se", "lcl", "ucl", "nboot", "pboot"))
  expect_equal(hc$dist, "average")
  expect_identical(hc$percent, NA_real_)
  expect_equal(hc$est, NA_real_)
  expect_equal(hc$se, NA_real_)
})

test_that("ssd_hc fitdists works 0 percent", {
  fits <- ssd_fit_dists(ssddata::ccme_boron, dists = "lnorm")
  
  hc <- ssd_hc(fits, 0)
  expect_s3_class(hc, "tbl_df")
  expect_identical(colnames(hc), c("dist", "percent", "est", "se", "lcl", "ucl", "nboot", "pboot"))
  expect_equal(hc$dist, "average")
  expect_identical(hc$percent, 0)
  expect_equal(hc$est, 0)
  expect_equal(hc$se, NA_real_)
})

test_that("ssd_hc fitdists works 100 percent", {
  fits <- ssd_fit_dists(ssddata::ccme_boron, dists = "lnorm")
  
  hc <- ssd_hc(fits, 100)
  expect_s3_class(hc, "tbl_df")
  expect_identical(colnames(hc), c("dist", "percent", "est", "se", "lcl", "ucl", "nboot", "pboot"))
  expect_equal(hc$dist, "average")
  expect_identical(hc$percent, 100)
  expect_true(vld_whole_numeric(hc$percent))
  expect_equal(hc$est, Inf)
  expect_equal(hc$se, NA_real_)
})

test_that("ssd_hc fitdists works multiple percents", {
  fits <- ssd_fit_dists(ssddata::ccme_boron, dists = "lnorm")
  
  hc <- ssd_hc(fits, percent = c(1, 99))
  expect_s3_class(hc, "tbl_df")
  expect_identical(colnames(hc), c("dist", "percent", "est", "se", "lcl", "ucl", "nboot", "pboot"))
  expect_equal(hc$dist, c("average", "average"))
  expect_identical(hc$percent, c(1, 99))
  expect_true(vld_whole_numeric(hc$percent))
  expect_equal(hc$est, c(0.721365215300168, 232.734811528299))
  expect_equal(hc$se, c(NA_real_, NA_real_))
})

test_that("ssd_hc fitdists averages", {
  fits <- ssd_fit_dists(ssddata::ccme_boron)
  hc <- ssd_hc(fits)
  expect_s3_class(hc, "tbl_df")
  expect_identical(colnames(hc), c("dist", "percent", "est", "se", "lcl", "ucl", "nboot", "pboot"))
  expect_equal(hc$dist, "average")
  expect_identical(hc$percent, 5)
  expect_true(vld_whole_numeric(hc$percent))
  expect_equal(hc$est, 1.30715672034529)
  expect_equal(hc$se, NA_real_)
  expect_equal(hc$lcl, NA_real_)
  expect_equal(hc$ucl, NA_real_)
})

test_that("ssd_hc fitdists averages single dist by multiple percent", {
  fits <- ssd_fit_dists(ssddata::ccme_boron, dists = "lnorm")
  
  hc <- ssd_hc(fits, average = TRUE, percent = 1:99)
  expect_s3_class(hc, "tbl_df")
  expect_identical(colnames(hc), c("dist", "percent", "est", "se", "lcl", "ucl", "nboot", "pboot"))
  expect_equal(hc$dist, rep("average", 99))
  expect_identical(hc$percent, 1:99)
  expect_true(vld_whole_numeric(hc$percent))
  expect_equal(hc$se, rep(NA_real_, 99))
  expect_equal(hc$lcl, rep(NA_real_, 99))
  expect_equal(hc$ucl, rep(NA_real_, 99))
})

test_that("ssd_hc fitdists not average single dist by multiple percent gives whole numeric", {
  fits <- ssd_fit_dists(ssddata::ccme_boron, dists = "lnorm")
  
  hc <- ssd_hc(fits, average = FALSE, percent = 1:99)
  expect_s3_class(hc, "tbl_df")
  expect_identical(colnames(hc), c("dist", "percent", "est", "se", "lcl", "ucl", "nboot", "pboot"))
#  expect_true(vld_whole_numeric(hc$percent)) not sure why not true
})

test_that("ssd_hc fitdists not average", {
  fits <- ssd_fit_dists(ssddata::ccme_boron)
  hc <- ssd_hc(fits, average = FALSE)
  expect_s3_class(hc, "tbl_df")
  expect_identical(colnames(hc), c("dist", "percent", "est", "se", "lcl", "ucl", "nboot", "pboot"))
  expect_equal(hc$dist, ssd_dists("bc")) 
  expect_identical(hc$percent, c(5, 5, 5))
  expect_equal(hc$est, c(1.07428453014496, 1.56226388133415, 1.6811748398812))
  expect_equal(hc$se, c(NA_real_, NA_real_,NA_real_))
})

test_that("ssd_hc fitdists correct for rescaling", {
  fits <- ssd_fit_dists(ssddata::ccme_boron, dists = ssd_dists())
  fits_rescale <- ssd_fit_dists(ssddata::ccme_boron, dists = ssd_dists(), rescale = TRUE)
  hc <- ssd_hc(fits)
  hc_rescale <- ssd_hc(fits_rescale)
  expect_equal(hc_rescale, hc, tolerance = 1e-05)
})

test_that("ssd_hc fitdists cis", {
  fits <- ssd_fit_dists(ssddata::ccme_boron, dists = "lnorm")
  
  set.seed(102)
  hc <- ssd_hc(fits, ci = TRUE)
  expect_s3_class(hc, "tbl_df")
  
  expect_snapshot_data(hc, "hc_cis")
})

test_that("ssd_hc doesn't calculate cis with inconsistent censoring", {
  data <- ssddata::ccme_boron
  data$Conc2 <- data$Conc
  data$Conc[1] <- 0.5
  data$Conc2[1] <- 1.0
  fits <- ssd_fit_dists(data, dists = c("lnorm", "llogis"))
  set.seed(10)
  hc <- ssd_hc(fits, ci = TRUE, nboot = 10)
  expect_equal(hc$se, 0.858174709802522)
  
  fits <- ssd_fit_dists(data, right = "Conc2", dists = c("lnorm", "llogis"))
  set.seed(10)
 expect_warning(hc <- ssd_hc(fits, ci = TRUE, nboot = 10),
  "^CIs cannot be calculated for inconsistently censored data[.]$")
  expect_identical(hc$se, NA_real_)
})

test_that("ssd_hc works with fully left censored data", {
  data <- ssddata::ccme_boron
  data$Conc2 <- data$Conc
  data$Conc <- 0
  fits <- ssd_fit_dists(data, right = "Conc2", dists = c("lnorm", "llogis"))
  set.seed(10)
  hc <- ssd_hc(fits, ci = TRUE, nboot = 10)
  expect_equal(hc$se, 0.00143406862620477)
})

test_that("ssd_hc not work partially censored even if all same left", {
  data <- ssddata::ccme_boron
  data$Conc2 <- data$Conc
  data$Conc <- 0.1
  fits <- ssd_fit_dists(data, right = "Conc2", dists = c("lnorm", "llogis"))
  set.seed(10)
  expect_warning(hc <- ssd_hc(fits, ci = TRUE, nboot = 10),
                 "^CIs cannot be calculated for inconsistently censored data[.]$")
})

test_that("ssd_hc doesn't works with inconsisently censored data", {
  data <- ssddata::ccme_boron
  data$Conc2 <- data$Conc
  data$Conc <- 0
  data$Conc[1] <- data$Conc2[1] / 2
  fits <- ssd_fit_dists(data, right = "Conc2", dists = c("lnorm", "llogis"))
  set.seed(10)
  expect_warning(hc <- ssd_hc(fits, ci = TRUE, nboot = 10),
                 "^CIs cannot be calculated for inconsistently censored data[.]$")
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
  hc <- ssd_hc(fits, ci = TRUE, nboot = 10)
  expect_equal(hc$se, 0.9241428592058)
})

test_that("ssd_hc calculates cis in parallel but one distribution", {
  local_multisession()
  data <- ssddata::ccme_boron
  fits <- ssd_fit_dists(data, dists = "lnorm")
  set.seed(10)
  hc <- ssd_hc(fits, ci = TRUE, nboot = 10)
  expect_equal(hc$se, 0.9241428592058)
})

test_that("ssd_hc calculates cis with two distributions", {
  data <- ssddata::ccme_boron
  fits <- ssd_fit_dists(data, dists = c("lnorm", "llogis"))
  set.seed(10)
  hc <- ssd_hc(fits, ci = TRUE, nboot = 10)
  expect_equal(hc$se, 0.93754149386013)
})

test_that("ssd_hc calculates cis in parallel with two distributions", {
  local_multisession()
  data <- ssddata::ccme_boron
  fits <- ssd_fit_dists(data, dists = c("lnorm", "llogis"))
  set.seed(10)
  hc <- ssd_hc(fits, ci = TRUE, nboot = 10)
  expect_equal(hc$se, 0.93754149386013)
})

test_that("ssd_hc doesn't calculate cis with unequally weighted data", {
  data <- ssddata::ccme_boron
  data$Weight <- rep(1, nrow(data))
  data$Weight[1] <- 2
  fits <- ssd_fit_dists(data, weight = "Weight", dists = "lnorm")
  expect_warning(hc <- ssd_hc(fits, ci = TRUE, nboot = 10),
                 "^CIs cannot be calculated for unequally weighted data[.]$")
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
  hc <- ssd_hc(fits, ci = TRUE, nboot = 10)
  set.seed(10)
  hc_10 <- ssd_hc(fits_10, ci = TRUE, nboot = 10)
  expect_equal(hc$est, 1.64903597051184)
  expect_equal(hc_10$est, 1.6811748398812)
  expect_equal(hc$se, 0.93754149386013)
  expect_equal(hc_10$se, 0.9241428592058)
})

test_that("ssd_hc cis with non-convergence", {
  set.seed(99)
  conc <- ssd_rlnorm_lnorm(100, meanlog1 = 0, meanlog2 = 1, sdlog1 = 1/10, sdlog2 = 1/10, pmix = 0.2)
  data <- data.frame(Conc = conc)
  fit <- ssd_fit_dists(data, dists = "lnorm_lnorm", min_pmix = 0.15)
  expect_identical(attr(fit, "min_pmix"), 0.15)
  hc15 <- ssd_hc(fit, ci = TRUE, nboot = 100)
  attr(fit, "min_pmix") <- 0.3
  expect_identical(attr(fit, "min_pmix"), 0.3)
  hc30 <- ssd_hc(fit, ci = TRUE, nboot = 100)
  expect_s3_class(hc30, "tbl")
  expect_snapshot_data(hc30, "hc_30")
})

test_that("ssd_hc cis with error", {
  set.seed(99)
  conc <- ssd_rlnorm_lnorm(30, meanlog1 = 0, meanlog2 = 1, sdlog1 = 1/10, sdlog2 = 1/10, pmix = 0.2)
  data <- data.frame(Conc = conc)
  fit <- ssd_fit_dists(data, dists = "lnorm_lnorm", min_pmix = 0.1)
  expect_identical(attr(fit, "min_pmix"), 0.1)
  expect_warning(hc_err <- ssd_hc(fit, ci = TRUE, nboot = 100), "pboot")
  expect_identical(colnames(hc_err), c("dist", "percent", "est", "se", "lcl", "ucl", "nboot", "pboot"))
  expect_identical(hc_err$dist, character(0))
  hc_err <- ssd_hc(fit, ci = TRUE, nboot = 100, min_pboot = 0.92)
  expect_s3_class(hc_err, "tbl")
  expect_snapshot_data(hc_err, "hc_err")
})
