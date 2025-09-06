test_that("[ works", {
  fit <- ssd_fit_dists(ssddata::ccme_boron)
  x <- fit[names(fit)]
  expect_identical(x, fit)
  x2 <- fit[2:3]
  expect_s3_class(x2, "fitdists")
  expect_snapshot(x2)
  x1 <- fit[4]
  expect_s3_class(x1, "fitdists")
  expect_snapshot(x1)
  x0 <- fit[FALSE]
  expect_s3_class(x1, "fitdists")
  expect_snapshot(x0)
})

test_that("[[]] works", {
  fit <- ssd_fit_dists(ssddata::ccme_boron)
  expect_error(fit[[names(fit)]])
  expect_error(fit[[2:3]], "inherits\\(x, \"tmbfit\"\\) is not TRUE")
  x1 <- fit[[4]]
  expect_s3_class(x1, "tmbfit")
  expect_snapshot(x1)
  lnorm <- fit[["lnorm"]]
  expect_identical(x1, lnorm)
  expect_error(fit[[FALSE]])
})

test_that("$ works", {
  fit <- ssd_fit_dists(ssddata::ccme_boron)
  lnorm <- fit$lnorm
  expect_s3_class(lnorm, "tmbfit")
  expect_snapshot(lnorm)
})
