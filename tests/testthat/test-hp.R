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

test_that("hp", {
  fits <- ssd_fit_dists(ssdtools::boron_data)
  
  set.seed(102)
  hp <- ssd_hp(fits, conc = 1, ci = TRUE, nboot = 10, average = FALSE)
  expect_s3_class(hp, "tbl")
  expect_snapshot_data(hp, "hp")
})

test_that("hp fitdists works with zero length conc", {
  fits <- ssd_fit_dists(ssdtools::boron_data, dists = "lnorm")

  hp <- ssd_hp(fits, numeric(0)) 
  expect_s3_class(hp, "tbl_df")
  expect_identical(colnames(hp), c("dist", "conc", "est", "se", "lcl", "ucl", "nboot", "pboot"))
  expect_equal(hp$dist, character(0))
  expect_identical(hp$conc, numeric(0))
  expect_equal(hp$est, numeric(0)) 
  expect_equal(hp$se, numeric(0))
})

test_that("hp fitdist works with missing conc", {
  fits <- ssd_fit_dists(ssdtools::boron_data, dists = "lnorm")
  
  hp <- ssd_hp(fits, NA_real_)
  expect_s3_class(hp, "tbl_df")
  expect_identical(colnames(hp), c("dist", "conc", "est", "se", "lcl", "ucl", "nboot", "pboot"))
  expect_equal(hp$dist, "average")
  expect_identical(hp$conc, NA_real_)
  expect_equal(hp$est, NA_real_)
  expect_equal(hp$se, NA_real_)
})

test_that("hp fitdist works with 0 conc", {
  fits <- ssd_fit_dists(ssdtools::boron_data, dists = "lnorm")
  
  hp <- ssd_hp(fits, 0) 
  expect_s3_class(hp, "tbl_df")
  expect_identical(colnames(hp), c("dist", "conc", "est", "se", "lcl", "ucl", "nboot", "pboot"))
  expect_equal(hp$dist, "average")
  expect_identical(hp$conc, 0) 
  expect_equal(hp$est, 0)
  expect_equal(hp$se, NA_real_)
})

test_that("hp fitdist works with negative conc", {
  fits <- ssd_fit_dists(ssdtools::boron_data, dists = "lnorm")
  
  hp <- ssd_hp(fits, -1)
  expect_s3_class(hp, "tbl_df")
  expect_identical(colnames(hp), c("dist", "conc", "est", "se", "lcl", "ucl", "nboot", "pboot"))
  expect_equal(hp$dist, "average")
  expect_identical(hp$conc, -1)
  expect_equal(hp$est, 0)
  expect_equal(hp$se, NA_real_)
})

test_that("hp fitdist works with -Inf conc", {
  fits <- ssd_fit_dists(ssdtools::boron_data, dists = "lnorm")
  
  hp <- ssd_hp(fits, -Inf)
  expect_s3_class(hp, "tbl_df")
  expect_identical(colnames(hp), c("dist", "conc", "est", "se", "lcl", "ucl", "nboot", "pboot"))
  expect_equal(hp$dist, "average")
  expect_identical(hp$conc, -Inf)
  expect_equal(hp$est, 0)
  expect_equal(hp$se, NA_real_)
})

test_that("hp fitdist works with Inf conc", {
  fits <- ssd_fit_dists(ssdtools::boron_data, dists = "lnorm")
  
  hp <- ssd_hp(fits, Inf)
  expect_s3_class(hp, "tbl_df")
  expect_identical(colnames(hp), c("dist", "conc", "est", "se", "lcl", "ucl", "nboot", "pboot"))
  expect_equal(hp$dist, "average")
  expect_identical(hp$conc, Inf)
  expect_equal(hp$est, 100)
  expect_equal(hp$se, NA_real_)
})

test_that("hp fitdists works reasonable conc", {
  fits <- ssd_fit_dists(ssdtools::boron_data, dists = "lnorm")
  
  hp <- ssd_hp(fits, 1)
  expect_s3_class(hp, "tbl_df")
  expect_identical(colnames(hp), c("dist", "conc", "est", "se", "lcl", "ucl", "nboot", "pboot"))
  expect_equal(hp$dist, "average")
  expect_identical(hp$conc, 1)
  expect_equal(hp$est, 1.95430302556687) 
  expect_equal(hp$se, NA_real_) 
  expect_equal(hp$lcl, NA_real_) 
  expect_equal(hp$ucl, NA_real_) 
})

test_that("hp fitdists works with multiple concs", {
  fits <- ssd_fit_dists(ssdtools::boron_data, dists = "lnorm")
  
  hp <- ssd_hp(fits, c(2.5,1))
  expect_s3_class(hp, "tbl_df")
  expect_identical(colnames(hp), c("dist", "conc", "est", "se", "lcl", "ucl", "nboot", "pboot"))
  expect_equal(hp$dist, c("average", "average"))
  expect_identical(hp$conc, c(2.5,1))
  expect_equal(hp$est, c(9.25437337881004, 1.9543030195088)) 
  expect_equal(hp$se, c(NA_real_, NA_real_)) 
  expect_equal(hp$lcl, c(NA_real_, NA_real_)) 
  expect_equal(hp$ucl, c(NA_real_, NA_real_)) 
})

test_that("hp fitdists works with cis", {
  fits <- ssd_fit_dists(ssdtools::boron_data, dists = "lnorm")
  
  set.seed(10)
  hp <- ssd_hp(fits, 1, ci = TRUE, nboot = 10)
  expect_s3_class(hp, "tbl_df")
  expect_identical(colnames(hp), c("dist", "conc", "est", "se", "lcl", "ucl", "nboot", "pboot"))
  expect_equal(hp$dist, "average")
  expect_identical(hp$conc, 1)
  expect_equal(hp$est, 1.95430302556687) 
  expect_equal(hp$se, 1.07364791021397) 
  expect_equal(hp$lcl, 0.0711786126124585) 
  expect_equal(hp$ucl, 2.92818915991217) 
})

test_that("hp fitdists works with multiple dists", {
  fits <- ssd_fit_dists(ssdtools::boron_data)
  
  hp <- ssd_hp(fits, 1)
  expect_s3_class(hp, "tbl_df")
  expect_identical(colnames(hp), c("dist", "conc", "est", "se", "lcl", "ucl", "nboot", "pboot"))
  expect_equal(hp$dist, "average")
  expect_identical(hp$conc, 1)
  expect_equal(hp$est, 3.66685732661861) 
  expect_equal(hp$se, NA_real_) 
})

test_that("hp fitdists works not average multiple dists", {
  fits <- ssd_fit_dists(ssdtools::boron_data)
  
  hp <- ssd_hp(fits, 1, average = FALSE)
  expect_s3_class(hp, "tbl_df")
  expect_identical(colnames(hp), c("dist", "conc", "est", "se", "lcl", "ucl", "nboot", "pboot"))
  expect_equal(hp$dist, ssd_dists("bc"))
  expect_identical(hp$conc, c(1, 1, 1))
  expect_equal(hp$est, c(4.67758994580286, 2.80047097268139, 1.9543030195088)) 
  expect_equal(hp$se, c(NA_real_, NA_real_, NA_real_)) 
})

test_that("ssd_hp fitdists correct for rescaling", {
  fits <- ssd_fit_dists(ssdtools::boron_data, dists = ssd_dists())
  fits_rescale <- ssd_fit_dists(ssdtools::boron_data, dists = ssd_dists(), rescale = TRUE)
  hp <- ssd_hp(fits, 1)
  hp_rescale <- ssd_hp(fits_rescale, 1)
  expect_equal(hp_rescale, hp, tolerance = 1e-05)
})

test_that("hp fitdists with no fitdists", {
  x <- list()
  class(x) <- c("fitdists")
  hp <- ssd_hp(x, 1)
  expect_s3_class(hp, c("tbl_df", "tbl", "data.frame"))
  expect_identical(colnames(hp), c("dist", "conc", "est", "se", "lcl", "ucl", "nboot", "pboot"))
  expect_equal(hp$dist, character(0))
  expect_identical(hp$conc, numeric(0))
  expect_equal(hp$est, numeric(0))
  expect_equal(hp$se, numeric(0))
})

test_that("ssd_hp doesn't calculate cis with inconsistent censoring", {
  data <- ssdtools::boron_data
  data$Conc2 <- data$Conc
  data$Conc[1] <- 0.5
  data$Conc2[1] <- 1.0
  fits <- ssd_fit_dists(data, dists = c("lnorm", "llogis"))
  set.seed(10)
  hp <- ssd_hp(fits, 1, ci = TRUE, nboot = 10)
  expect_equal(hp$se, 1.84344751832165)
  
  fits <- ssd_fit_dists(data, right = "Conc2", dists = c("lnorm", "llogis"))
  set.seed(10)
  expect_warning(hp <- ssd_hp(fits, 1, ci = TRUE, nboot = 10),
                 "^CIs cannot be calculated for inconsistently censored data[.]$")
  expect_identical(hp$se, NA_real_)
})

test_that("ssd_hp same with equally weighted data", {
  data <- ssdtools::boron_data
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
  data <- ssdtools::boron_data
  data$Weight <- rep(2, nrow(data))
  fits <- ssd_fit_dists(data, weight = "Weight", dists = "lnorm")
  set.seed(10)
  hp <- ssd_hp(fits, 1, ci = TRUE, nboot = 10)
  expect_equal(hp$se, 1.07364791021397)
})

test_that("ssd_hp calculates cis with two distributions", {
  data <- ssdtools::boron_data
  fits <- ssd_fit_dists(data, dists = c("lnorm", "llogis"))
  set.seed(10)
  hp <- ssd_hp(fits, 1, ci = TRUE, nboot = 10)
  expect_equal(hp$se, 1.34349907754091)
})

test_that("ssd_hp calculates cis in parallel but one distribution", {
  local_multisession()
  data <- ssdtools::boron_data
  fits <- ssd_fit_dists(data, dists = "lnorm")
  set.seed(10)
  hp <- ssd_hp(fits, 1, ci = TRUE, nboot = 10)
  expect_equal(hp$se, 1.07364791021397)
})

test_that("ssd_hp calculates cis in parallel with two distributions", {
  local_multisession()
  data <- ssdtools::boron_data
  fits <- ssd_fit_dists(data, dists = c("lnorm", "llogis"))
  set.seed(10)
  hp <- ssd_hp(fits, 1, ci = TRUE, nboot = 10)
  expect_equal(hp$se, 1.34349907754091)
})

test_that("ssd_hp doesn't calculate cis with unequally weighted data", {
  data <- ssdtools::boron_data
  data$Weight <- rep(1, nrow(data))
  data$Weight[1] <- 2
  fits <- ssd_fit_dists(data, weight = "Weight", dists = "lnorm")
  expect_warning(hp <- ssd_hp(fits, 1, ci = TRUE, nboot = 10),
                 "^CIs cannot be calculated for unequally weighted data[.]$")
  expect_identical(hp$se, NA_real_)
})

test_that("ssd_hp no effect with higher weight one distribution", {
  data <- ssdtools::boron_data
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
  data <- ssdtools::boron_data
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
  expect_equal(hp$se, 4.67944067350423)
  expect_equal(hp_10$se, 4.76615538439964)
})

test_that("ssd_hp cis with non-convergence", {
  set.seed(99)
  conc <- ssd_rlnorm_lnorm(100, meanlog1 = 0, meanlog2 = 1, sdlog1 = 1/10, sdlog2 = 1/10, pmix = 0.2)
  data <- data.frame(Conc = conc)
  fit <- ssd_fit_dists(data, dists = "lnorm_lnorm", min_pmix = 0.15)
  expect_identical(attr(fit, "min_pmix"), 0.15)
  hp15 <- ssd_hp(fit, conc = 1, ci = TRUE, nboot = 100)
  attr(fit, "min_pmix") <- 0.3
  expect_identical(attr(fit, "min_pmix"), 0.3)
  hp30 <- ssd_hp(fit, conc = 1, ci = TRUE, nboot = 100)
  expect_s3_class(hp30, "tbl")
  expect_snapshot_data(hp30, "hp_30")
})

test_that("ssd_hp cis with error", {
  set.seed(99)
  conc <- ssd_rlnorm_lnorm(30, meanlog1 = 0, meanlog2 = 1, sdlog1 = 1/10, sdlog2 = 1/10, pmix = 0.2)
  data <- data.frame(Conc = conc)
  fit <- ssd_fit_dists(data, dists = "lnorm_lnorm", min_pmix = 0.1)
  expect_identical(attr(fit, "min_pmix"), 0.1)
  expect_warning(hp_err <- ssd_hp(fit, conc = 1, ci = TRUE, nboot = 100), "pboot")
  expect_identical(colnames(hp_err), c("dist", "conc", "est", "se", "lcl", "ucl", "nboot", "pboot"))
  expect_identical(hp_err$dist, character(0))
  hp_err <- ssd_hp(fit, conc = 1, ci = TRUE, nboot = 100, min_pboot = 0.92)
  expect_s3_class(hp_err, "tbl")
  expect_snapshot_data(hp_err, "hp_err")
})
