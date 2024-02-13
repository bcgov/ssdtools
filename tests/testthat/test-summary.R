test_that("summary tmbfit", {
  data <- ssddata::ccme_boron
  fits <- ssd_fit_dists(data, dists = "lnorm", rescale = FALSE)
  summary <- summary(fits$lnorm)
  expect_s3_class(summary, "summary_tmbfit")
  expect_identical(names(summary), c("dist", "estimates"))
  expect_identical(summary$dist, "lnorm")
  expect_equal(summary$estimates, list(meanlog = 2.56164496371788, sdlog = 1.24154032419128))
})

test_that("summary fitdists", {
  data <- ssddata::ccme_boron
  fits <- ssd_fit_dists(data,
    dists = "lnorm", rescale = FALSE,
    min_pmix = 0.01
  )
  summary <- summary(fits)
  expect_s3_class(summary, "summary_fitdists")
  expect_identical(names(summary), c("fits", "censoring", "nrow", "rescaled", "weighted", "unequal", "min_pmix"))
  expect_identical(summary$censoring, c(0, Inf))
  expect_identical(summary$nrow, 28L)
  expect_identical(summary$min_pmix, 0.01)
  expect_identical(summary$rescaled, 1)
  expect_identical(summary$weighted, 1)
  expect_identical(summary$unequal, FALSE)
})

test_that("summary fitdists with multiple dists", {
  data <- ssddata::ccme_boron
  fits <- ssd_fit_dists(data, rescale = TRUE)
  summary <- summary(fits)
  expect_s3_class(summary, "summary_fitdists")
  expect_identical(names(summary), c("fits", "censoring", "nrow", "rescaled", "weighted", "unequal", "min_pmix"))
  expect_identical(summary$censoring, c(0, Inf))
  expect_identical(summary$nrow, 28L)
  expect_equal(summary$rescaled, 8.40832920383116)
  expect_identical(summary$weighted, 1)
  expect_identical(summary$unequal, FALSE)
})

test_that("summary min_pmix 0.1", {
  data <- ssddata::ccme_boron
  fits <- ssd_fit_dists(data, dists = "lnorm", min_pmix = 0.1)
  summary <- summary(fits)
  expect_s3_class(summary, "summary_fitdists")
  expect_identical(summary$min_pmix, 0.1)
})
