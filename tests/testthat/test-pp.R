context("pp")

test_that("pp fitdist", {
  expect_equal(ssd_pp(boron_lnorm, numeric(0)), structure(list(conc = numeric(0), percent = numeric(0)), class = c("tbl_df", 
"tbl", "data.frame"), row.names = integer(0)))
  
  expect_identical(ssd_pp(boron_lnorm, NA), structure(list(conc = NA, percent = NA_real_), class = c("tbl_df", 
"tbl", "data.frame"), row.names = c(NA, -1L)))
  
  expect_equal(ssd_pp(boron_lnorm, 1)$percent, 1.95430302556699)
  
  expect_equal(ssd_pp(boron_lnorm, 0), structure(list(conc = 0, percent = 0), class = c("tbl_df", "tbl", 
"data.frame"), row.names = c(NA, -1L)))
  
  expect_equal(ssd_pp(boron_lnorm, -1), structure(list(conc = -1, percent = 0), class = c("tbl_df", "tbl", 
"data.frame"), row.names = c(NA, -1L)))
  expect_equal(ssd_pp(boron_lnorm, -Inf), structure(list(conc = -Inf, percent = 0), class = c("tbl_df", "tbl", 
"data.frame"), row.names = c(NA, -1L)))
  expect_equal(ssd_pp(boron_lnorm, Inf), structure(list(conc = Inf, percent = 100), class = c("tbl_df", 
"tbl", "data.frame"), row.names = c(NA, -1L)))
  expect_equal(ssd_pp(boron_lnorm, c(1, 30))$percent,  c(1.95430302556699, 75.0549005516342))
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
  expect_equal(ssd_pp(boron_dists, 1), structure(list(conc = 1, percent = 3.94776512989495, gamma = 4.6710582232319, 
    gompertz = 3.86863765551047, lgumbel = 0.857509719351262, 
    llog = 2.8009625988292, lnorm = 1.95430302556699, weibull = 4.62118773535592), row.names = c(NA, 
-1L), class = "data.frame"))
  expect_equal(ssd_pp(boron_dists, c(0, 1, 30, Inf)), structure(list(conc = c(0, 1, 30, Inf), percent = c(0, 3.94776512989495, 
72.0361745625695, 100), gamma = c(0, 4.6710582232319, 71.6308860545863, 
100), gompertz = c(0, 3.86863765551047, 70.7583410369993, 100
), lgumbel = c(0, 0.857509719351262, 73.9910475559788, 100), 
    llog = c(0, 2.8009625988292, 74.0157684447419, 100), lnorm = c(0, 
    1.95430302556699, 75.0549005516342, 100), weibull = c(0, 
    4.62118773535592, 71.7935776292485, 100)), row.names = c(NA, 
-4L), class = "data.frame"))
})

test_that("pp fitdistcens", {
  expect_equal(ssd_pp(fluazinam_lnorm, c(0, 1, 30, Inf))$percent,
               c(0, 3.20358281527575, 27.8852630254455, 100))
})
