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

test_that("ssd_hc list", {
  expect_error(ssd_hc(list()), "^`x` must be named[.]$", class = "chk_error")
  
  hc <- ssd_hc(structure(list(), .Names = character(0)))
  expect_is(hc, class = c("tbl_df", "tbl", "data.frame"))
  expect_identical(colnames(hc), c("percent", "est", "se", "lcl", "ucl", "dist", "wt"))
  expect_identical(hc$percent, numeric(0))
  expect_equal(hc$est, numeric(0))
  expect_equal(hc$se, numeric(0))
  expect_equal(hc$lcl, numeric(0))
  expect_equal(hc$ucl, numeric(0))
  expect_equal(hc$dist, character(0))
  expect_equal(hc$wt, numeric(0))
  
  expect_error(ssd_hc(list("lnorm" = NULL, "lnorm" = NULL)), "^`names[(]x[)]` must be unique[.]$", class = "chk_error")
  
  hc <- ssd_hc(list("lnorm" = NULL))
  expect_is(hc, "tbl_df")
  expect_identical(colnames(hc), c("percent", "est", "se", "lcl", "ucl", "dist", "wt"))
  expect_identical(hc$percent, 5)
  expect_equal(hc$est, 0.193040816698737)
  expect_equal(hc$se, NA_real_)
  expect_equal(hc$lcl, NA_real_)
  expect_equal(hc$ucl, NA_real_)
  expect_equal(hc$dist, "lnorm")
  expect_equal(hc$wt, NA_real_)
  
  hc <- ssd_hc(list("lnorm" = NULL), percent = c(1, 99))
  expect_is(hc, "tbl_df")
  expect_identical(colnames(hc), c("percent", "est", "se", "lcl", "ucl", "dist", "wt"))
  expect_identical(hc$percent, c(1, 99))
  expect_equal(hc$est, c(0.097651733070336, 10.2404736563121))
  expect_equal(hc$se, c(NA_real_, NA_real_))
  expect_equal(hc$lcl, c(NA_real_, NA_real_))
  expect_equal(hc$ucl, c(NA_real_, NA_real_)) 
  expect_equal(hc$dist, c("lnorm", "lnorm"))
  expect_equal(hc$wt, c(NA_real_, NA_real_))
  
  hc <- ssd_hc(list("lnorm" = list(meanlog = 0, sdlog = 1)))
  expect_is(hc, "tbl_df")
  expect_identical(colnames(hc), c("percent", "est", "se", "lcl", "ucl", "dist", "wt"))
  expect_identical(hc$percent, 5)
  expect_equal(hc$est, 0.193040816698737)
  expect_equal(hc$se, NA_real_)
  expect_equal(hc$lcl, NA_real_)
  expect_equal(hc$ucl, NA_real_)
  expect_equal(hc$dist, "lnorm")
  expect_equal(hc$wt, NA_real_)
  
  hc <- ssd_hc(list("lnorm" = list(meanlog = 2, sdlog = 2)))
  expect_is(hc, "tbl_df")
  expect_identical(colnames(hc), c("percent", "est", "se", "lcl", "ucl", "dist", "wt"))
  expect_identical(hc$percent, 5)
  expect_equal(hc$est, 0.275351379333677)
  expect_equal(hc$se, NA_real_)
  expect_equal(hc$lcl, NA_real_)
  expect_equal(hc$ucl, NA_real_)
  expect_equal(hc$dist, "lnorm")
  expect_equal(hc$wt, NA_real_)
  
  hc <- ssd_hc(list("lnorm" = NULL, "llogis" = NULL))
  expect_is(hc, "tbl_df")
  expect_identical(colnames(hc), c("percent", "est", "se", "lcl", "ucl", "dist", "wt"))
  expect_identical(hc$percent, c(5, 5))
  expect_equal(hc$est, c(0.193040816698737, 0.0526315789473684))
  expect_equal(hc$se, c(NA_real_, NA_real_)) 
  expect_equal(hc$lcl, c(NA_real_, NA_real_))
  expect_equal(hc$ucl, c(NA_real_, NA_real_))
  expect_equal(hc$dist, c("lnorm", "llogis"))
  expect_equal(hc$wt, c(NA_real_, NA_real_))
  
  hc <- ssd_hc(list("lnorm" = NULL, "llogis" = NULL), percent = c(1, 99))
  expect_is(hc, "tbl_df")
  expect_identical(colnames(hc), c("percent", "est", "se", "lcl", "ucl", "dist", "wt"))
  expect_identical(hc$percent, c(1, 99, 1, 99))
  expect_equal(hc$est, c(0.097651733070336, 10.2404736563121, 0.0101010101010101, 98.9999999999999))
  expect_equal(hc$se, c(NA_real_, NA_real_, NA_real_, NA_real_))
  expect_equal(hc$lcl, c(NA_real_, NA_real_, NA_real_, NA_real_))
  expect_equal(hc$ucl, c(NA_real_, NA_real_, NA_real_, NA_real_))
  expect_equal(hc$dist, c("lnorm", "lnorm", "llogis", "llogis"))
  expect_equal(hc$wt, c(NA_real_, NA_real_, NA_real_, NA_real_))
})

test_that("ssd_hc fitdist", {
  rlang::scoped_options(lifecycle_verbosity = "quiet")
  expect_identical(ssd_hc(boron_lnorm, hc = 6), ssd_hc(boron_lnorm, percent = 6))
  
  hc <- ssd_hc(boron_lnorm)
  expect_is(hc, "tbl_df")
  expect_identical(colnames(hc), c("percent", "est", "se", "lcl", "ucl", "dist", "wt"))
  expect_identical(hc$percent, 5)
  expect_equal(hc$est, 1.68066107721146)
  expect_equal(hc$se, NA_real_)
  expect_equal(hc$lcl, NA_real_)
  expect_equal(hc$ucl, NA_real_)
  expect_equal(hc$dist, "lnorm")
  expect_equal(hc$wt, 1)
})

test_that("ssd_hc fitdistcens", {
  hc <- ssd_hc(fluazinam_lnorm)
  expect_is(hc, "tbl_df")
  expect_identical(colnames(hc), c("percent", "est", "se", "lcl", "ucl", "dist", "wt"))
  expect_identical(hc$percent, 5)
  expect_equal(hc$est, 1.74529360152777)
  expect_equal(hc$se, NA_real_)
  expect_equal(hc$lcl, NA_real_)
  expect_equal(hc$ucl, NA_real_)
  expect_equal(hc$dist, "lnorm")
  expect_equal(hc$wt, 1)
})

test_that("ssd_hc fitdists", {
  hc <- ssd_hc(boron_dists)
  expect_is(hc, "tbl_df")
  expect_identical(colnames(hc), c("percent", "est", "se", "lcl", "ucl", "dist", "wt"))
  expect_identical(hc$percent, 5)
  expect_equal(hc$est, 1.30671324518567)
  expect_equal(hc$se, NA_real_)
  expect_equal(hc$lcl, NA_real_)
  expect_equal(hc$ucl, NA_real_)
  expect_equal(hc$dist, "average")
  expect_equal(hc$wt, 1)
})

test_that("ssd_hc fitdists not average", {
  hc <- (ssd_hc(boron_dists, average = FALSE))
  expect_is(hc, "tbl_df")
  expect_identical(colnames(hc), c("percent", "est", "se", "lcl", "ucl", "dist", "wt"))
  expect_identical(hc$percent, c(5, 5, 5))
  expect_equal(hc$est,  c(1.56256632555312, 1.07373870642628, 1.68066107721146))
  expect_equal(hc$se, c(NA_real_, NA_real_,NA_real_))
  expect_equal(hc$lcl, c(NA_real_, NA_real_, NA_real_))
  expect_equal(hc$ucl, c(NA_real_,NA_real_, NA_real_))
  expect_equal(hc$dist, c("llogis", "gamma", "lnorm")) 
  expect_equal(hc$wt, c(0.109508088280028, 0.594829782050604, 0.295662129669368))
})

test_that("ssd_hc fitdistscens", {
  hc <- ssd_hc(fluazinam_dists)
  expect_is(hc, "tbl_df")
  expect_identical(colnames(hc), c("percent", "est", "se", "lcl", "ucl", "dist", "wt"))
  expect_identical(hc$percent, 5)
  expect_equal(hc$est, 1.42153606844833)
  expect_equal(hc$se, NA_real_)
  expect_equal(hc$lcl, NA_real_)
  expect_equal(hc$ucl, NA_real_)
  expect_equal(hc$dist, "average")
  expect_equal(hc$wt, 1)
})

test_that("ssd_hc fitdistscens not average", {
  hc <- ssd_hc(fluazinam_dists, average = FALSE)
  expect_is(hc, "tbl_df")
  expect_identical(colnames(hc), c("percent", "est", "se", "lcl", "ucl", "dist", "wt"))
  expect_identical(hc$percent, c(5, 5, 5))
  expect_equal(hc$est, c(1.30938169835089, 0.309067069393034, 1.74529360152777))
  expect_equal(hc$se, c( NA_real_, NA_real_,NA_real_))
  expect_equal(hc$lcl, c(NA_real_, NA_real_, NA_real_))
  expect_equal(hc$ucl, c(NA_real_, NA_real_, NA_real_))
  expect_equal(hc$dist, c("llogis", "gamma", "lnorm")) 
  expect_equal(hc$wt, c(0.418957849047345, 0.0982636210880713, 0.482778529864584)) 
})

