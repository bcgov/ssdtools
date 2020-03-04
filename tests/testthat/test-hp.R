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

  expect_equal(ssd_hp(boron_lnorm, 1)$est, 1.95430302556699)

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
  expect_equal(ssd_hp(boron_lnorm, c(1, 30))$est, c(1.95430302556699, 75.0549005516342))
})

test_that("hp fitdist cis", {
  set.seed(10)
  expect_equal(as.data.frame(ssd_hp(boron_lnorm, 1, ci = TRUE, nboot = 10)), structure(list(
    conc = 1, est = 1.95430302556699, se = 1.35685517597222,
    lcl = 0.752600358938875, ucl = 4.40350933171247, dist = "lnorm"
  ), class = "data.frame", row.names = c(
    NA,
    -1L
  )))

  set.seed(10)
  expect_equal(as.data.frame(ssd_hp(boron_lnorm, c(1, 30), ci = TRUE, nboot = 10)), structure(list(conc = c(1, 30), est = c(1.95430302556699, 75.0549005516342), se = c(1.35685517597222, 5.11971864981164), lcl = c(
    0.752600358938875,
    71.4251808998576
  ), ucl = c(4.40350933171247, 87.0556765560242), dist = rep("lnorm", 2)), class = "data.frame", row.names = c(NA, -2L)))
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
  expect_equal(as.data.frame(ssd_hp(boron_dists, 1)), structure(list(
    conc = 1, est = 3.6651119524728, se = NA_real_,
    lcl = NA_real_, ucl = NA_real_, dist = "average"
  ), class = "data.frame", row.names = c(
    NA,
    -1L
  )))
  expect_equal(as.data.frame(ssd_hp(boron_dists, c(0, 1, 30, Inf))), structure(list(conc = c(0, 1, 30, Inf), est = c(
    0, 3.6651119524728,
    72.8664372774006, 100
  ), se = c(
    NA_real_, NA_real_, NA_real_,
    NA_real_
  ), lcl = c(NA_real_, NA_real_, NA_real_, NA_real_), ucl = c(
    NA_real_,
    NA_real_, NA_real_, NA_real_
  ), dist = rep("average", 4)), class = "data.frame", row.names = c(
    NA,
    -4L
  )))
})

test_that("hp fitdists cis", {
  set.seed(10)
  expect_equal(as.data.frame(ssd_hp(boron_dists, 1, ci = TRUE, nboot = 10)), structure(list(
    conc = 1, est = 3.6651119524728, se = 2.47335604452443,
    lcl = 0.542279934470833, ucl = 7.19977242012522, dist = "average"
  ), class = "data.frame", row.names = c(
    NA,
    -1L
  )))

  set.seed(10)
  expect_equal(as.data.frame(ssd_hp(boron_dists, c(0, 1, 30, Inf), ci = TRUE, nboot = 10)), structure(list(conc = c(0, 1, 30, Inf), est = c(
    0, 3.6651119524728,
    72.8664372774006, 100
  ), se = c(
    0, 2.47335604452443, 7.70065027209822,
    0
  ), lcl = c(0, 0.542279934470833, 59.7304054310305, 100), ucl = c(
    0,
    7.19977242012522, 82.2246167336774, 100
  ), dist = rep("average", 4)), class = "data.frame", row.names = c(
    NA,
    -4L
  )))
})

test_that("hp fitdistcens", {
  expect_equal(
    as.data.frame(ssd_hp(fluazinam_lnorm, c(0, 1, 30, Inf))),
    structure(list(conc = c(0, 1, 30, Inf), est = c(
      0, 3.20358281527575,
      27.8852630254455, 100
    ), se = c(
      NA_real_, NA_real_, NA_real_,
      NA_real_
    ), lcl = c(NA_real_, NA_real_, NA_real_, NA_real_), ucl = c(
      NA_real_,
      NA_real_, NA_real_, NA_real_
    ), dist = rep("lnorm", 4)), class = "data.frame", row.names = c(
      NA,
      -4L
    ))
  )
})

test_that("hp fitdistscens", {
  expect_equal(
    as.data.frame(ssd_hp(fluazinam_dists, c(0, 1, 30, Inf))),
    structure(list(conc = c(0, 1, 30, Inf), est = c(
      0, 4.23518701256203,
      26.9619242506997, 100
    ), se = c(
      NA_real_, NA_real_, NA_real_,
      NA_real_
    ), lcl = c(NA_real_, NA_real_, NA_real_, NA_real_), ucl = c(
      NA_real_,
      NA_real_, NA_real_, NA_real_
    ), dist = rep("average", 4)), class = "data.frame", row.names = c(
      NA,
      -4L
    ))
  )
})
