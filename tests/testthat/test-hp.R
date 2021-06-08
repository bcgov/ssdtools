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

test_that("hp fitdists works with zero length conc", {
  hp <- ssd_hp(boron_lnorm, numeric(0)) 
  expect_s3_class(hp, "tbl_df")
  expect_identical(colnames(hp), c("dist", "conc", "est", "se", "lcl", "ucl"))
  expect_equal(hp$dist, character(0))
  expect_identical(hp$conc, numeric(0))
  expect_equal(hp$est, numeric(0)) 
  expect_equal(hp$se, numeric(0))
})

test_that("hp fitdist works with missing conc", {
  hp <- ssd_hp(boron_lnorm, NA_real_)
  expect_s3_class(hp, "tbl_df")
  expect_identical(colnames(hp), c("dist", "conc", "est", "se", "lcl", "ucl"))
  expect_equal(hp$dist, "average")
  expect_identical(hp$conc, NA_real_)
  expect_equal(hp$est, NA_real_)
  expect_equal(hp$se, NA_real_)
})

test_that("hp fitdist works with 0 conc", {
  hp <- ssd_hp(boron_lnorm, 0) 
  expect_s3_class(hp, "tbl_df")
  expect_identical(colnames(hp), c("dist", "conc", "est", "se", "lcl", "ucl"))
  expect_equal(hp$dist, "average")
  expect_identical(hp$conc, 0) 
  expect_equal(hp$est, 0)
  expect_equal(hp$se, NA_real_)
})

test_that("hp fitdist works with negative conc", {
  hp <- ssd_hp(boron_lnorm, -1)
  expect_s3_class(hp, "tbl_df")
  expect_identical(colnames(hp), c("dist", "conc", "est", "se", "lcl", "ucl"))
  expect_equal(hp$dist, "average")
  expect_identical(hp$conc, -1)
  expect_equal(hp$est, 0)
  expect_equal(hp$se, NA_real_)
})

test_that("hp fitdist works with -Inf conc", {
  hp <- ssd_hp(boron_lnorm, -Inf)
  expect_s3_class(hp, "tbl_df")
  expect_identical(colnames(hp), c("dist", "conc", "est", "se", "lcl", "ucl"))
  expect_equal(hp$dist, "average")
  expect_identical(hp$conc, -Inf)
  expect_equal(hp$est, 0)
  expect_equal(hp$se, NA_real_)
})

test_that("hp fitdist works with Inf conc", {
  hp <- ssd_hp(boron_lnorm, Inf)
  expect_s3_class(hp, "tbl_df")
  expect_identical(colnames(hp), c("dist", "conc", "est", "se", "lcl", "ucl"))
  expect_equal(hp$dist, "average")
  expect_identical(hp$conc, Inf)
  expect_equal(hp$est, 100)
  expect_equal(hp$se, NA_real_)
})

test_that("hp fitdists works reasonable conc", {
  hp <- ssd_hp(boron_lnorm, 1)
  expect_s3_class(hp, "tbl_df")
  expect_identical(colnames(hp), c("dist", "conc", "est", "se", "lcl", "ucl"))
  expect_equal(hp$dist, "average")
  expect_identical(hp$conc, 1)
  expect_equal(hp$est, 1.95430302556687) 
  expect_equal(hp$se, NA_real_) 
  expect_equal(hp$lcl, NA_real_) 
  expect_equal(hp$ucl, NA_real_) 
})

test_that("hp fitdists works with cis", {
  set.seed(10)
  hp <- ssd_hp(boron_lnorm, 1, ci = TRUE, nboot = 10)
  expect_s3_class(hp, "tbl_df")
  expect_identical(colnames(hp), c("dist", "conc", "est", "se", "lcl", "ucl"))
  expect_equal(hp$dist, "average")
  expect_identical(hp$conc, 1)
  expect_equal(hp$est, 1.95430302556687) 
  expect_equal(hp$se, 1.35655142717243) 
  expect_equal(hp$lcl, 0.753456512320601) 
  expect_equal(hp$ucl, 4.40213331349945) 
})

test_that("hp fitdists works with multiple dists", {
  hp <- ssd_hp(boron_dists, 1)
  expect_s3_class(hp, "tbl_df")
  expect_identical(colnames(hp), c("dist", "conc", "est", "se", "lcl", "ucl"))
  expect_equal(hp$dist, "average")
  expect_identical(hp$conc, 1)
  expect_equal(hp$est, 3.66685732661861) 
  expect_equal(hp$se, NA_real_) 
})

test_that("hp fitdists works not average multiple dists", {
  hp <- ssd_hp(boron_dists, 1, average = FALSE)
  expect_s3_class(hp, "tbl_df")
  expect_identical(colnames(hp), c("dist", "conc", "est", "se", "lcl", "ucl"))
  expect_equal(hp$dist, c("gamma", "llogis", "lnorm"))
  expect_identical(hp$conc, c(1, 1, 1))
  expect_equal(hp$est, c(4.67758994580286, 2.80047097268139, 1.9543030195088)) 
  expect_equal(hp$se, c(NA_real_, NA_real_, NA_real_)) 
})

test_that("ssd_hp fitdists correct for rescaling", {
  fits <- ssd_fit_dists(boron_data, dists = ssd_dists())
  fits_rescale <- ssd_fit_dists(boron_data, dists = ssd_dists(), rescale = TRUE)
  hp <- ssd_hp(fits, 1)
  hp_rescale <- ssd_hp(fits_rescale, 1)
  expect_equal(hp_rescale, hp, tolerance = 1e-05)
})

test_that("hp fitdists with no fitdists", {
  x <- list()
  class(x) <- c("fitdists")
  hp <- ssd_hp(x, 1)
  expect_s3_class(hp, c("tbl_df", "tbl", "data.frame"))
  expect_identical(colnames(hp), c("dist", "conc", "est", "se", "lcl", "ucl"))
  expect_equal(hp$dist, character(0))
  expect_identical(hp$conc, numeric(0))
  expect_equal(hp$est, numeric(0))
  expect_equal(hp$se, numeric(0))
})

test_that("ssd_hp doesn't calculate cis with inconsistent censoring", {
  data <- boron_data
  data$Conc2 <- data$Conc
  data$Conc[1] <- 0.5
  data$Conc2[1] <- 1.0
  fits <- ssd_fit_dists(data, dists = c("lnorm", "llogis"))
  set.seed(10)
  hp <- ssd_hp(fits, 1, ci = TRUE, nboot = 10)
  expect_equal(hp$se, 2.11940073273896)
  
  fits <- ssd_fit_dists(data, right = "Conc2", dists = c("lnorm", "llogis"))
  set.seed(10)
  expect_warning(hp <- ssd_hp(fits, 1, ci = TRUE, nboot = 10),
                 "^CIs cannot be calculated for inconsistently censored data[.]$")
  expect_identical(hp$se, NA_real_)
})

test_that("ssd_hp same with equally weighted data", {
  data <- boron_data
  data$Weight <- rep(2, nrow(data))
  fits <- ssd_fit_dists(data, weight = "Weight", dists = "lnorm")
  set.seed(10)
  hp <- ssd_hp(fits, 1, ci = TRUE, nboot = 10)
  
  data$Weight <- rep(2, nrow(data))
  fits2 <- ssd_fit_dists(data, weight = "Weight", dists = "lnorm")
  set.seed(10)
  hp2 <- ssd_hp(fits2, 1, ci = TRUE, nboot = 10)
  expect_identical(hp2, hp)
})

test_that("ssd_hp calculates cis with equally weighted data", {
  data <- boron_data
  data$Weight <- rep(2, nrow(data))
  fits <- ssd_fit_dists(data, weight = "Weight", dists = "lnorm")
  set.seed(10)
  hp <- ssd_hp(fits, 1, ci = TRUE, nboot = 10)
  expect_equal(hp$se, 1.35655142717243)
})

test_that("ssd_hp doesn't calculate cis with unequally weighted data", {
  data <- boron_data
  data$Weight <- rep(1, nrow(data))
  data$Weight[1] <- 2
  fits <- ssd_fit_dists(data, weight = "Weight", dists = "lnorm")
  expect_warning(hp <- ssd_hp(fits, 1, ci = TRUE, nboot = 10),
                 "^CIs cannot be calculated for unequally weighted data[.]$")
  expect_identical(hp$se, NA_real_)
})

