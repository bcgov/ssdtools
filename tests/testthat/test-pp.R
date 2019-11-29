context("pp")

test_that("pp fitdist", {
  expect_equal(ssd_pp(boron_lnorm, numeric(0)), numeric(0))
  expect_identical(ssd_pp(boron_lnorm, NA), NA_real_)
  expect_equal(ssd_pp(boron_lnorm, 1), 1.95430302556699)
  expect_equal(ssd_pp(boron_lnorm, 0), 0)
  expect_equal(ssd_pp(boron_lnorm, -1), 0)
  expect_equal(ssd_pp(boron_lnorm, -Inf), 0)
  expect_equal(ssd_pp(boron_lnorm, Inf), 100)
  expect_equal(ssd_pp(boron_lnorm, c(1, 30)), c(1.954303, 75.054901))
})
