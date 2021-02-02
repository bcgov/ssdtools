#    Copyright 2015 Province of British Columbia
#
#    Licensed under the Apache License, Version 2.0 (the "License");
#    you may not use this file except in compliance with the License.
#    You may obtain a copy of the License at
#
#       http://www.apache.org/licenses/LICENSE-2.0
#
#    Unless required by applicable law or agreed to in writing, software
#    distributed under the License is distributed on an "AS IS" BASIS,
#    WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
#    See the License for the specific language governing permissions and
#    limitations under the License.

test_that("hp fitdist", {
  expect_equal(ssd_hp(boron_lnorm, numeric(0)), structure(list(
    conc = numeric(0), est = numeric(0), se = numeric(0),
    lcl = numeric(0), ucl = numeric(0), dist = character(0)
  ), class = c(
    "tbl_df",
    "tbl", "data.frame"
  ), row.names = integer(0)))
  
  expect_identical(ssd_hp(boron_lnorm, NA_real_), structure(list(
    conc = NA_real_, est = NA_real_, se = NA_real_,
    lcl = NA_real_, ucl = NA_real_, dist = "lnorm"
  ), class = c(
    "tbl_df", "tbl",
    "data.frame"
  ), row.names = c(NA, -1L)))
  
  expect_equal(ssd_hp(boron_lnorm, 1)$est, 1.95576822341687)
  
  expect_equal(ssd_hp(boron_lnorm, 0), structure(list(conc = 0, est = 0, se = NA_real_, lcl = NA_real_, ucl = NA_real_, dist = "lnorm"), class = c(
    "tbl_df", "tbl",
    "data.frame"
  ), row.names = c(NA, -1L)))
  
  expect_equal(ssd_hp(boron_lnorm, -1), structure(list(conc = -1, est = 0, se = NA_real_, lcl = NA_real_, ucl = NA_real_, dist = "lnorm"), class = c(
    "tbl_df", "tbl",
    "data.frame"
  ), row.names = c(NA, -1L)))
  expect_equal(ssd_hp(boron_lnorm, -Inf), structure(list(conc = -Inf, est = 0, se = NA_real_, lcl = NA_real_, ucl = NA_real_, dist = "lnorm"), class = c(
    "tbl_df", "tbl",
    "data.frame"
  ), row.names = c(NA, -1L)))
  expect_equal(ssd_hp(boron_lnorm, Inf), structure(list(conc = Inf, est = 100, se = NA_real_, lcl = NA_real_, ucl = NA_real_, dist = "lnorm"), class = c(
    "tbl_df",
    "tbl", "data.frame"
  ), row.names = c(NA, -1L)))
  expect_equal(ssd_hp(boron_lnorm, c(1, 30))$est, c(1.95576822341687, 75.0517322027199))
})

test_that("hp fitdist cis", {
  set.seed(10)
  hp <- ssd_hp(boron_lnorm, 1, ci = TRUE, nboot = 10)
  expect_is(hp, "tbl_df")
  expect_identical(colnames(hp), c("conc", "est", "se", "lcl", "ucl", "dist"))
  expect_identical(hp$conc, 1)
  expect_equal(hp$est, 1.95576822341687) 
  expect_equal(hp$se, 1.35723135295734) 
  expect_equal(hp$lcl, 0.753437345701245) 
  expect_equal(hp$ucl, 4.40577139680561) 
  expect_equal(hp$dist, "lnorm")
                                                                                                          
  set.seed(10)
  hp <- ssd_hp(boron_lnorm, c(1, 30), ci = TRUE, nboot = 10)
  expect_is(hp, "tbl_df")
  expect_identical(colnames(hp), c("conc", "est", "se", "lcl", "ucl", "dist"))
  expect_identical(hp$conc, c(1, 30))
  expect_equal(hp$est, c(1.95576822341687, 75.0517322027199))
  expect_equal(hp$se, c(1.35723135295734, 5.11980949460707))
  expect_equal(hp$lcl, c(0.753437345701245, 71.4221297303002))
  expect_equal(hp$ucl, c(4.40577139680561, 87.0508546669261))
  expect_equal(hp$dist, c("lnorm", "lnorm"))
})

test_that("hp fitdists with no dists", {
  x <- list()
  class(x) <- c("fitdists")
  expect_identical(ssd_hp(x, numeric(0)), structure(list(
    conc = numeric(0), est = numeric(0), se = numeric(0),
    lcl = numeric(0), ucl = numeric(0), dist = character(0)
  ), class = c(
    "tbl_df",
    "tbl", "data.frame"
  ), row.names = integer(0)))
  
  expect_identical(ssd_hp(x, 2), structure(list(
    conc = numeric(0), est = numeric(0), se = numeric(0),
    lcl = numeric(0), ucl = numeric(0), dist = character(0)
  ), class = c(
    "tbl_df",
    "tbl", "data.frame"
  ), row.names = integer(0)))
})

test_that("hp fitdists", {
  hp <- ssd_hp(boron_dists, 1)
  expect_is(hp, "tbl_df")
  expect_identical(colnames(hp), c("conc", "est", "se", "lcl", "ucl", "dist"))
  expect_identical(hp$conc, 1)
  expect_equal(hp$est, 3.66852412355664)
  expect_equal(hp$se, NA_real_)
  expect_equal(hp$lcl, NA_real_)
  expect_equal(hp$ucl, NA_real_)
  expect_equal(hp$dist, "average")
                                                                                                                                      
  hp <- ssd_hp(boron_dists, c(0, 1, 30, Inf))
  expect_is(hp, "tbl_df")
  expect_identical(colnames(hp), c("conc", "est", "se", "lcl", "ucl", "dist"))
  expect_identical(hp$conc, c(0, 1, 30, Inf))
  expect_equal(hp$est, c(0, 3.66852412355664,72.904934839041, 100))
  expect_equal(hp$se, c(NA_real_, NA_real_, NA_real_, NA_real_))
  expect_equal(hp$lcl, c(NA_real_, NA_real_, NA_real_, NA_real_))
  expect_equal(hp$ucl, c(NA_real_, NA_real_, NA_real_, NA_real_))
  expect_equal(hp$dist, c("average", "average", "average", "average")) 
})

test_that("hp fitdists cis", {
  set.seed(10)
  hp <- ssd_hp(boron_dists, 1, ci = TRUE, nboot = 10)
  expect_is(hp, "tbl_df")
  expect_identical(colnames(hp), c("conc", "est", "se", "lcl", "ucl", "dist"))
  expect_identical(hp$conc, 1)
  expect_equal(hp$est, 3.66852412355664)
  expect_equal(hp$se, 2.45645877883578)
  expect_equal(hp$lcl, 0.570981644438492)
  expect_equal(hp$ucl, 7.18380436625128)
  expect_equal(hp$dist, "average") 
  
  set.seed(10)
  hp <- ssd_hp(boron_dists, c(0, 1, 30, Inf), ci = TRUE, nboot = 10)
  expect_is(hp, "tbl_df")
  expect_identical(colnames(hp), c("conc", "est", "se", "lcl", "ucl", "dist"))
  expect_identical(hp$conc, c(0, 1, 30, Inf))
  expect_equal(hp$est, c(0, 3.66852412355664, 72.904934839041, 100))
  expect_equal(hp$se, c(0, 2.45645877883578, 7.71796383954152, 0))
  expect_equal(hp$lcl, c(0, 0.570981644438492, 59.8280826110273, 100))
  expect_equal(hp$ucl, c(0, 7.18380436625128, 82.4206257509066, 100))
  expect_equal(hp$dist, c("average",  "average", "average", "average"))
})

test_that("hp fitdistcens", {
  hp <- ssd_hp(fluazinam_lnorm, c(0, 1, 30, Inf))
  expect_is(hp, "tbl_df")
  expect_identical(colnames(hp), c("conc", "est", "se", "lcl", "ucl", "dist"))
  expect_identical(hp$conc, c(0, 1, 30, Inf))
  expect_equal(hp$est, c(0, 3.20075104792886, 27.8754025505199, 100))
  expect_equal(hp$se, c(NA_real_, NA_real_, NA_real_, NA_real_))
  expect_equal(hp$lcl, c(NA_real_, NA_real_, NA_real_, NA_real_))
  expect_equal(hp$ucl, c(NA_real_, NA_real_, NA_real_, NA_real_))
  expect_equal(hp$dist, c("lnorm", "lnorm", "lnorm", "lnorm"))
})

test_that("hp fitdistscens", {
  hp <- ssd_hp(fluazinam_dists, c(0, 1, 30, Inf))
  expect_is(hp, "tbl_df")
  expect_identical(colnames(hp), c("conc", "est", "se", "lcl", "ucl", "dist"))
  expect_identical(hp$conc, c(0, 1, 30, Inf))
  expect_equal(hp$est, c(0, 4.06545463384627, 27.3122236342922, 100))
  expect_equal(hp$se, c(NA_real_, NA_real_, NA_real_, NA_real_))
  expect_equal(hp$lcl, c(NA_real_, NA_real_, NA_real_, NA_real_))
  expect_equal(hp$ucl, c(NA_real_, NA_real_, NA_real_, NA_real_))
  expect_equal(hp$dist, c("average", "average", "average", "average"))
})
