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

test_that("ssd_hc list", {
  expect_error(ssd_hc(list()), "^`x` must be named[.]$", class = "chk_error")
  
  expect_identical(
    ssd_hc(structure(list(), .Names = character(0))),
    structure(list(
      percent = numeric(0), est = numeric(0), se = numeric(0),
      lcl = numeric(0), ucl = numeric(0), dist = character(0)
    ), class = c(
      "tbl_df",
      "tbl", "data.frame"
    ), row.names = integer(0))
  )
  
  expect_error(ssd_hc(list("lnorm" = NULL, "lnorm" = NULL)), "^`names[(]x[)]` must be unique[.]$", class = "chk_error")
  
  expect_equal(
    as.data.frame(ssd_hc(list("lnorm" = NULL))),
    structure(list(
      percent = 5, est = 0.193040816698737, se = NA_real_,
      lcl = NA_real_, ucl = NA_real_, dist = "lnorm"
    ), row.names = c(
      NA,
      -1L
    ), class = "data.frame")
  )
  expect_equal(
    as.data.frame(ssd_hc(list("lnorm" = NULL), percent = c(1, 99))),
    structure(list(percent = c(1, 99), est = c(
      0.097651733070336,
      10.2404736563121
    ), se = c(NA_real_, NA_real_), lcl = c(
      NA_real_,
      NA_real_
    ), ucl = c(NA_real_, NA_real_), dist = c("lnorm", "lnorm")), row.names = c(NA, -2L), class = "data.frame")
  )
  
  expect_equal(
    as.data.frame(ssd_hc(list("lnorm" = list(meanlog = 0, sdlog = 1)))),
    structure(list(
      percent = 5, est = 0.193040816698737, se = NA_real_,
      lcl = NA_real_, ucl = NA_real_, dist = "lnorm"
    ), row.names = c(
      NA,
      -1L
    ), class = "data.frame")
  )
  
  expect_equal(
    as.data.frame(ssd_hc(list("lnorm" = list(meanlog = 2, sdlog = 2)))),
    structure(list(
      percent = 5, est = 0.275351379333677, se = NA_real_,
      lcl = NA_real_, ucl = NA_real_, dist = "lnorm"
    ), row.names = c(
      NA,
      -1L
    ), class = "data.frame")
  )
  
  expect_equal(
    as.data.frame(ssd_hc(list("lnorm" = NULL, "llogis" = NULL))),
    structure(list(percent = c(5, 5), est = c(
      0.193040816698737,
      0.143067464655739
    ), se = c(NA_real_, NA_real_), lcl = c(
      NA_real_,
      NA_real_
    ), ucl = c(NA_real_, NA_real_), dist = c("lnorm", "llogis")), row.names = c(NA, -2L), class = "data.frame")
  )
  
  expect_equal(
    as.data.frame(ssd_hc(list("lnorm" = NULL, "llogis" = NULL), percent = c(1, 99))),
    structure(list(percent = c(1, 99, 1, 99), est = c(
      0.097651733070336,
      10.2404736563121, 0.027457392206657, 269.109901017445
    ), se = c(
      NA_real_,
      NA_real_, NA_real_, NA_real_
    ), lcl = c(
      NA_real_, NA_real_, NA_real_,
      NA_real_
    ), ucl = c(NA_real_, NA_real_, NA_real_, NA_real_), dist = c(
      "lnorm",
      "lnorm", "llogis", "llogis"
    )), row.names = c(NA, -4L), class = "data.frame")
  )
})

test_that("ssd_hc fitdist", {
  rlang::scoped_options(lifecycle_verbosity = "quiet")
  expect_identical(ssd_hc(boron_lnorm, hc = 6), ssd_hc(boron_lnorm, percent = 6))
  expect_equal(
    as.data.frame(ssd_hc(boron_lnorm)),
    structure(list(
      percent = 5, est = 1.68066107721146, se = NA_real_,
      lcl = NA_real_, ucl = NA_real_, dist = "lnorm"
    ), class = "data.frame", row.names = c(
      NA,
      -1L
    ))
  )
})

test_that("ssd_hc fitdistcens", {
  expect_equal(
    as.data.frame(ssd_hc(fluazinam_lnorm)),
    structure(list(
      percent = 5, est = 1.74529360152777, se = NA_real_,
      lcl = NA_real_, ucl = NA_real_, dist = "lnorm"
    ), class = "data.frame", row.names = c(
      NA,
      -1L
    ))
  )
})

test_that("ssd_hc fitdists", {
  expect_equal(
    as.data.frame(ssd_hc(boron_dists)),
    structure(list(
      percent = 5, est = 1.30671324518567, se = NA_real_,
      lcl = NA_real_, ucl = NA_real_, dist = "average"
    ), class = "data.frame", row.names = c(
      NA,
      -1L
    ))
  )
})

test_that("ssd_hc fitdists not average", {
  expect_equal(
    as.data.frame(ssd_hc(boron_dists, average = FALSE)),
    structure(list(
      percent = c(5, 5, 5), 
      est =  c(1.56256632555312, 1.07373870642628, 1.68066107721146), 
      se = c(
        NA_real_, NA_real_,
        NA_real_
      ), lcl = c(NA_real_, NA_real_, NA_real_), ucl = c(
        NA_real_,
        NA_real_, NA_real_
      ), dist = c("llogis", "gamma", "lnorm")), row.names = c(
        NA,
        -3L
      ), class = "data.frame")
  )
})

test_that("ssd_hc fitdistscens", {
  expect_equal(
    as.data.frame(ssd_hc(fluazinam_dists)),
    structure(list(
      percent = 5, est = 1.42153606844833, se = NA_real_,
      lcl = NA_real_, ucl = NA_real_, dist = "average"
    ), class = "data.frame", row.names = c(
      NA,
      -1L
    ))
  )
})

test_that("ssd_hc fitdistscens not average", {
  expect_equal(
    as.data.frame(ssd_hc(fluazinam_dists, average = FALSE)),
    structure(list(
      percent = c(5, 5, 5), 
      est = c(1.30938169835089, 0.309067069393034, 1.74529360152777), 
      se = c(
        NA_real_, NA_real_,
        NA_real_
      ), lcl = c(NA_real_, NA_real_, NA_real_), ucl = c(
        NA_real_,
        NA_real_, NA_real_
      ), dist = c("llogis", "gamma", "lnorm")), row.names = c(
        NA,
        -3L
      ), class = "data.frame")
  )
})
