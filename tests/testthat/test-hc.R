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
  expect_identical(colnames(hc), c("dist", "percent", "est", "se", "lcl", "ucl"))
  expect_identical(hc$percent, numeric(0))
  expect_equal(hc$est, numeric(0))
  expect_equal(hc$se, numeric(0))
  expect_equal(hc$lcl, numeric(0))
  expect_equal(hc$ucl, numeric(0))
  expect_equal(hc$dist, character(0))
  
  expect_error(ssd_hc(list("lnorm" = NULL, "lnorm" = NULL)), "^`names[(]x[)]` must be unique[.]$", class = "chk_error")
  
  hc <- ssd_hc(list("lnorm" = NULL))
  expect_is(hc, "tbl_df")
  expect_identical(colnames(hc), c("dist", "percent", "est", "se", "lcl", "ucl"))
  expect_identical(hc$percent, 5)
  expect_equal(hc$est, 0.193040816698737)
  expect_equal(hc$se, NA_real_)
  expect_equal(hc$lcl, NA_real_)
  expect_equal(hc$ucl, NA_real_)
  expect_equal(hc$dist, "lnorm")
  
  hc <- ssd_hc(list("lnorm" = NULL), percent = c(1, 99))
  expect_is(hc, "tbl_df")
  expect_identical(colnames(hc), c("dist", "percent", "est", "se", "lcl", "ucl"))
  expect_identical(hc$percent, c(1, 99))
  expect_equal(hc$est, c(0.097651733070336, 10.2404736563121))
  expect_equal(hc$se, c(NA_real_, NA_real_))
  expect_equal(hc$lcl, c(NA_real_, NA_real_))
  expect_equal(hc$ucl, c(NA_real_, NA_real_)) 
  expect_equal(hc$dist, c("lnorm", "lnorm"))
  
  hc <- ssd_hc(list("lnorm" = list(meanlog = 0, sdlog = 1)))
  expect_is(hc, "tbl_df")
  expect_identical(colnames(hc), c("dist", "percent", "est", "se", "lcl", "ucl"))
  expect_identical(hc$percent, 5)
  expect_equal(hc$est, 0.193040816698737)
  expect_equal(hc$se, NA_real_)
  expect_equal(hc$lcl, NA_real_)
  expect_equal(hc$ucl, NA_real_)
  expect_equal(hc$dist, "lnorm")
  
  hc <- ssd_hc(list("lnorm" = list(meanlog = 2, sdlog = 2)))
  expect_is(hc, "tbl_df")
  expect_identical(colnames(hc), c("dist", "percent", "est", "se", "lcl", "ucl"))
  expect_identical(hc$percent, 5)
  expect_equal(hc$est, 0.275351379333677)
  expect_equal(hc$se, NA_real_)
  expect_equal(hc$lcl, NA_real_)
  expect_equal(hc$ucl, NA_real_)
  expect_equal(hc$dist, "lnorm")
  
  hc <- ssd_hc(list("lnorm" = NULL, "llogis" = NULL))
  expect_is(hc, "tbl_df")
  expect_identical(colnames(hc), c("dist", "percent", "est", "se", "lcl", "ucl"))
  expect_identical(hc$percent, c(5, 5))
  expect_equal(hc$est, c(0.193040816698737, 0.0526315789473684))
  expect_equal(hc$se, c(NA_real_, NA_real_)) 
  expect_equal(hc$lcl, c(NA_real_, NA_real_))
  expect_equal(hc$ucl, c(NA_real_, NA_real_))
  expect_equal(hc$dist, c("lnorm", "llogis"))
  
  hc <- ssd_hc(list("lnorm" = NULL, "llogis" = NULL), percent = c(1, 99))
  expect_is(hc, "tbl_df")
  expect_identical(colnames(hc), c("dist", "percent", "est", "se", "lcl", "ucl"))
  expect_identical(hc$percent, c(1, 99, 1, 99))
  expect_equal(hc$est, c(0.097651733070336, 10.2404736563121, 0.0101010101010101, 98.9999999999999))
  expect_equal(hc$se, c(NA_real_, NA_real_, NA_real_, NA_real_))
  expect_equal(hc$lcl, c(NA_real_, NA_real_, NA_real_, NA_real_))
  expect_equal(hc$ucl, c(NA_real_, NA_real_, NA_real_, NA_real_))
  expect_equal(hc$dist, c("lnorm", "lnorm", "llogis", "llogis"))
})

test_that("ssd_hc", {
  hc <- ssd_hc(boron_lnorm, numeric(0)) 
  expect_is(hc, class = c("tbl_df", "tbl", "data.frame"))
  expect_identical(colnames(hc), c("dist", "percent", "est", "se", "lcl", "ucl"))
  expect_identical(hc$percent, numeric(0))
  expect_equal(hc$est, numeric(0))
  expect_equal(hc$se, numeric(0))
  expect_equal(hc$lcl, numeric(0))
  expect_equal(hc$ucl, numeric(0))
  expect_equal(hc$dist, character(0))
  
  hc <- ssd_hc(boron_lnorm, NA_real_)
  expect_is(hc, "tbl_df")
  expect_identical(colnames(hc), c("dist", "percent", "est", "se", "lcl", "ucl"))
  expect_identical(hc$percent, NA_real_)
  expect_equal(hc$est, NA_real_)
  expect_equal(hc$se, NA_real_)
  expect_equal(hc$lcl, NA_real_)
  expect_equal(hc$ucl, NA_real_)
  expect_equal(hc$dist, "average")
  
  hc <- ssd_hc(boron_lnorm, 0)
  expect_is(hc, "tbl_df")
  expect_identical(colnames(hc), c("dist", "percent", "est", "se", "lcl", "ucl"))
  expect_identical(hc$percent, 0)
  expect_equal(hc$est, 0)
  expect_equal(hc$se, NA_real_)
  expect_equal(hc$lcl, NA_real_)
  expect_equal(hc$ucl, NA_real_)
  expect_equal(hc$dist, "average")

  hc <- ssd_hc(boron_lnorm, -1)
  expect_is(hc, "tbl_df")
  expect_identical(colnames(hc), c("dist", "percent", "est", "se", "lcl", "ucl"))
  expect_identical(hc$percent, -1)
  expect_equal(hc$est, NaN)
  expect_equal(hc$se, NA_real_)
  expect_equal(hc$lcl, NA_real_)
  expect_equal(hc$ucl, NA_real_)
  expect_equal(hc$dist, "average")
  
  hc <- ssd_hc(boron_lnorm, Inf)
  expect_is(hc, "tbl_df")
  expect_identical(colnames(hc), c("dist", "percent", "est", "se", "lcl", "ucl"))
  expect_identical(hc$percent, Inf)
  expect_equal(hc$est, NaN)
  expect_equal(hc$se, NA_real_)
  expect_equal(hc$lcl, NA_real_)
  expect_equal(hc$ucl, NA_real_)
  expect_equal(hc$dist, "average")
  
  hc <- ssd_hc(boron_lnorm, percent = c(1, 99))
  expect_is(hc, "tbl_df")
  expect_identical(colnames(hc), c("dist", "percent", "est", "se", "lcl", "ucl"))
  expect_identical(hc$percent, c(1, 99))
  expect_equal(hc$est, c(0.721365215300168, 232.734811528299))
  expect_equal(hc$se, c(NA_real_, NA_real_))
  expect_equal(hc$lcl, c(NA_real_, NA_real_))
  expect_equal(hc$ucl, c(NA_real_, NA_real_)) 
  expect_equal(hc$dist, c("average", "average"))
})

test_that("ssd_hc hc defunct", {
  lifecycle::expect_defunct(ssd_hc(boron_lnorm, hc = 6))
})  

test_that("ssd_hc fitdist", {
  hc <- ssd_hc(boron_lnorm, average = FALSE)
  expect_is(hc, "tbl_df")
  expect_identical(colnames(hc), c("dist", "percent", "est", "se", "lcl", "ucl"))
  expect_equal(hc$dist, "lnorm")
  expect_identical(hc$percent, 5)
  expect_equal(hc$est, 1.681174837758)
  expect_equal(hc$se, NA_real_)
  expect_equal(hc$lcl, NA_real_)
  expect_equal(hc$ucl, NA_real_)
})

test_that("ssd_hc fitdists", {
  hc <- ssd_hc(boron_dists)
  expect_is(hc, "tbl_df")
  expect_identical(colnames(hc), c("dist", "percent", "est", "se", "lcl", "ucl"))
  expect_identical(hc$percent, 5)
  expect_equal(hc$est, 1.30715672034529)
  expect_equal(hc$se, NA_real_)
  expect_equal(hc$lcl, NA_real_)
  expect_equal(hc$ucl, NA_real_)
  expect_equal(hc$dist, "average")
})

test_that("ssd_hc fitdists not average", {
  hc <- (ssd_hc(boron_dists, average = FALSE))
  expect_is(hc, "tbl_df")
  expect_identical(colnames(hc), c("dist", "percent", "est", "se", "lcl", "ucl"))
  expect_identical(hc$percent, c(5, 5, 5))
  expect_equal(hc$est,  c(1.07428453014496, 1.56226388133415, 1.6811748398812))
  expect_equal(hc$se, c(NA_real_, NA_real_,NA_real_))
  expect_equal(hc$lcl, c(NA_real_, NA_real_, NA_real_))
  expect_equal(hc$ucl, c(NA_real_,NA_real_, NA_real_))
  expect_equal(hc$dist, c("gamma", "llogis", "lnorm")) 
})
