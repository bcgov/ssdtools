test_that("npars", {
  expect_identical(npars(boron_lnorm), 2L)
  expect_identical(npars(boron_dists), c(
  gamma = 2L, llogis = 2L, lnorm = 2L
))
  expect_identical(npars(fluazinam_lnorm), 2L)
  expect_identical(npars(fluazinam_dists), c(gamma = 2L, llogis = 2L, lnorm = 2L))
})

test_that("npars", {
  fit <- ssd_fit_dists(ssdtools::boron_data, dists = c("lnorm", "llogis"), tmb = TRUE)
  expect_identical(npars(fit), c(llogis = 2L, lnorm = 2L))
})
