context("pp")

test_that("pp fitdist", {
  expect_equal(ssd_pp(boron_lnorm, numeric(0)), structure(list(conc = numeric(0), percent = numeric(0)), class = c("tbl_df", 
"tbl", "data.frame"), row.names = integer(0)))
  
  expect_identical(ssd_pp(boron_lnorm, NA), structure(list(conc = NA, percent = NA_real_), class = c("tbl_df", 
"tbl", "data.frame"), row.names = c(NA, -1L)))
  
  expect_equal(ssd_pp(boron_lnorm, 1)$percent, 0.0195430302556699)
  
  expect_equal(ssd_pp(boron_lnorm, 0), structure(list(conc = 0, percent = 0), class = c("tbl_df", "tbl", 
"data.frame"), row.names = c(NA, -1L)))
  
  expect_equal(ssd_pp(boron_lnorm, -1), structure(list(conc = -1, percent = 0), class = c("tbl_df", "tbl", 
"data.frame"), row.names = c(NA, -1L)))
  expect_equal(ssd_pp(boron_lnorm, -Inf), structure(list(conc = -Inf, percent = 0), class = c("tbl_df", "tbl", 
"data.frame"), row.names = c(NA, -1L)))
  expect_equal(ssd_pp(boron_lnorm, Inf), structure(list(conc = Inf, percent = 1), class = c("tbl_df", 
"tbl", "data.frame"), row.names = c(NA, -1L)))
  expect_equal(ssd_pp(boron_lnorm, c(1, 30))$percent,  c(0.0195430302556699, 
0.750549005516342))
})

test_that("pp fitdists with no dists", {
  x <- list()
  class(x) <- c("fitdists")
  expect_identical(ssd_pp(x, numeric(0)), structure(list(conc = numeric(0), percent = numeric(0)), class = c("tbl_df", 
"tbl", "data.frame"), row.names = integer(0)))
  
  expect_identical(ssd_pp(x, 2), structure(list(conc = 2, percent = NA_real_), class = c("tbl_df", 
"tbl", "data.frame"), row.names = c(NA, -1L)))
})

test_that("pp fitdists", {
  expect_equal(ssd_pp(boron_dists, 1), structure(list(conc = 1, percent = 0.0394776512989495, gamma = 0.046710582232319, 
    gompertz = 0.0386863765551047, lgumbel = 0.00857509719351262, 
    llog = 0.028009625988292, lnorm = 0.0195430302556699, weibull = 0.0462118773535592), row.names = c(NA, 
-1L), class = "data.frame"))
  expect_equal(ssd_pp(boron_dists, c(0, 1, 30, Inf)), structure(list(conc = c(0, 1, 30, Inf), percent = c(0, 0.0394776512989495, 
0.720361745625695, 1), gamma = c(0, 0.046710582232319, 0.716308860545863, 
1), gompertz = c(0, 0.0386863765551047, 0.707583410369993, 1), 
    lgumbel = c(0, 0.00857509719351262, 0.739910475559788, 1), 
    llog = c(0, 0.028009625988292, 0.740157684447419, 1), lnorm = c(0, 
    0.0195430302556699, 0.750549005516342, 1), weibull = c(0, 
    0.0462118773535592, 0.717935776292485, 1)), row.names = c(NA, 
-4L), class = "data.frame"))
})
