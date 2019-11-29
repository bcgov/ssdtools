context("hp")

test_that("hp fitdist", {
  expect_equal(ssd_hp(boron_lnorm, numeric(0)), structure(list(conc = numeric(0), est = numeric(0)), class = c("tbl_df", 
"tbl", "data.frame"), row.names = integer(0)))
  
  expect_identical(ssd_hp(boron_lnorm, NA_real_), structure(list(conc = NA_real_, est = NA_real_), class = c("tbl_df", 
"tbl", "data.frame"), row.names = c(NA, -1L)))
  
  expect_equal(ssd_hp(boron_lnorm, 1)$est, 1.95430302556699)
  
  expect_equal(ssd_hp(boron_lnorm, 0), structure(list(conc = 0, est = 0), class = c("tbl_df", "tbl", 
"data.frame"), row.names = c(NA, -1L)))
  
  expect_equal(ssd_hp(boron_lnorm, -1), structure(list(conc = -1, est = 0), class = c("tbl_df", "tbl", 
"data.frame"), row.names = c(NA, -1L)))
  expect_equal(ssd_hp(boron_lnorm, -Inf), structure(list(conc = -Inf, est = 0), class = c("tbl_df", "tbl", 
"data.frame"), row.names = c(NA, -1L)))
  expect_equal(ssd_hp(boron_lnorm, Inf), structure(list(conc = Inf, est = 100), class = c("tbl_df", 
"tbl", "data.frame"), row.names = c(NA, -1L)))
  expect_equal(ssd_hp(boron_lnorm, c(1, 30))$est,  c(1.95430302556699, 75.0549005516342))
})

test_that("hp fitdists with no dists", {
  x <- list()
  class(x) <- c("fitdists")
  expect_identical(ssd_hp(x, numeric(0)), structure(list(conc = numeric(0), est = numeric(0)), class = c("tbl_df", 
"tbl", "data.frame"), row.names = integer(0)))
  
  expect_identical(ssd_hp(x, 2), structure(list(conc = 2, est = NA_real_), class = c("tbl_df", 
"tbl", "data.frame"), row.names = c(NA, -1L)))
})

test_that("hp fitdists", {
  expect_equal(ssd_hp(boron_dists, 1), structure(list(conc = 1, est = 3.94776512989495), row.names = c(NA, 
-1L), class = "data.frame"))
  expect_equal(ssd_hp(boron_dists, c(0, 1, 30, Inf)), structure(list(conc = c(0, 1, 30, Inf), est = c(0, 3.94776512989495, 
72.0361745625695, 100)), row.names = c(NA, -4L), class = "data.frame"))
})

test_that("hp fitdistcens", {
  expect_equal(ssd_hp(fluazinam_lnorm, c(0, 1, 30, Inf))$est,
               c(0, 3.20358281527575, 27.8852630254455, 100))
})

test_that("hp fitdistscens", {
  expect_equal(ssd_hp(fluazinam_dists, c(0, 1, 30, Inf))$est,
               c(0, 3.58823076789627, 28.6257342451691, 100))
})
