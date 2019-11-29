context("hp")

test_that("hp fitdist", {
  expect_equal(ssd_hp(boron_lnorm, numeric(0)), structure(list(conc = numeric(0), percent = numeric(0)), class = c("tbl_df", 
"tbl", "data.frame"), row.names = integer(0)))
  
  expect_identical(ssd_hp(boron_lnorm, NA), structure(list(conc = NA, percent = NA_real_), class = c("tbl_df", 
"tbl", "data.frame"), row.names = c(NA, -1L)))
  
  expect_equal(ssd_hp(boron_lnorm, 1)$percent, 1.95430302556699)
  
  expect_equal(ssd_hp(boron_lnorm, 0), structure(list(conc = 0, percent = 0), class = c("tbl_df", "tbl", 
"data.frame"), row.names = c(NA, -1L)))
  
  expect_equal(ssd_hp(boron_lnorm, -1), structure(list(conc = -1, percent = 0), class = c("tbl_df", "tbl", 
"data.frame"), row.names = c(NA, -1L)))
  expect_equal(ssd_hp(boron_lnorm, -Inf), structure(list(conc = -Inf, percent = 0), class = c("tbl_df", "tbl", 
"data.frame"), row.names = c(NA, -1L)))
  expect_equal(ssd_hp(boron_lnorm, Inf), structure(list(conc = Inf, percent = 100), class = c("tbl_df", 
"tbl", "data.frame"), row.names = c(NA, -1L)))
  expect_equal(ssd_hp(boron_lnorm, c(1, 30))$percent,  c(1.95430302556699, 75.0549005516342))
})

test_that("pp fitdists with no dists", {
  x <- list()
  class(x) <- c("fitdists")
  expect_identical(ssd_hp(x, numeric(0)), structure(list(conc = numeric(0), percent = numeric(0)), class = c("tbl_df", 
"tbl", "data.frame"), row.names = integer(0)))
  
  expect_identical(ssd_hp(x, 2), structure(list(conc = 2, percent = NA_real_), class = c("tbl_df", 
"tbl", "data.frame"), row.names = c(NA, -1L)))
})

test_that("pp fitdists", {
  expect_equal(ssd_hp(boron_dists, 1), structure(list(conc = 1, percent = 3.94776512989495), row.names = c(NA, 
-1L), class = "data.frame"))
  expect_equal(ssd_hp(boron_dists, c(0, 1, 30, Inf)), structure(list(conc = c(0, 1, 30, Inf), percent = c(0, 3.94776512989495, 
72.0361745625695, 100)), row.names = c(NA, -4L), class = "data.frame"))
})

test_that("pp fitdistcens", {
  expect_equal(ssd_hp(fluazinam_lnorm, c(0, 1, 30, Inf))$percent,
               c(0, 3.20358281527575, 27.8852630254455, 100))
})
