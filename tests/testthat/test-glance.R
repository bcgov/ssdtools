test_that("glance weights rescale log_lik", {
  fits <- ssd_fit_dists(ssddata::ccme_boron)

  glance <- glance(fits)
  expect_s3_class(glance, "tbl")
  expect_snapshot_data(glance, "glance")
})

test_that("glance weights independent of rescaling", {
  fit <- ssd_fit_dists(ssddata::ccme_boron, rescale = FALSE)
  fit_rescale <- ssd_fit_dists(ssddata::ccme_boron, rescale = TRUE)

  glance <- glance(fit)
  glance_rescale <- glance(fit_rescale)
  expect_equal(glance_rescale$weight, glance$weight)
})

test_that("glance weights rescale log_lik", {
  data <- ssddata::ccme_boron
  data$weight <- rep(1, nrow(data))
  fit <- ssd_fit_dists(data, weight = "weight")
  data$weight <- rep(2, nrow(data))
  fit_weight <- ssd_fit_dists(data, weight = "weight")

  glance <- glance(fit)
  glance_weight <- glance(fit_weight)
  expect_equal(glance_weight$log_lik / 2, glance$log_lik)
})

test_that("glance reweight same log_lik", {
  data <- ssddata::ccme_boron
  data$weight <- rep(1, nrow(data))
  fit <- ssd_fit_dists(data, weight = "weight")
  data$weight <- rep(2, nrow(data))
  fit_weight <- ssd_fit_dists(data, weight = "weight", reweight = TRUE)

  glance <- glance(fit)
  glance_weight <- glance(fit_weight)
  expect_equal(glance_weight$log_lik, glance$log_lik)
})

test_that("glance reweight same log_lik", {
  data <- ssddata::ccme_boron
  data$Upper <- data$Conc
  data$Upper[1] <- data$Conc[1] * 1.0001

  fit <- ssd_fit_dists(data, dists = c("gamma", "llogis", "lnorm"))
  fit_cens <- ssd_fit_dists(data, dists = c("gamma", "llogis", "lnorm"), right = "Upper")
  fit_cens_n <- ssd_fit_dists(data, dists = c("gamma", "llogis", "lnorm_lnorm"), right = "Upper")

  glance <- glance(fit)
  glance_cens <- glance(fit_cens)
  glance_cens_n <- glance(fit_cens_n)

  expect_snapshot_data(glance, "fit")
  expect_snapshot_data(glance_cens, "fit_cens")
  expect_snapshot_data(glance_cens_n, "fit_cens_n")
  expect_identical(glance$nobs, rep(28L, 3))
  expect_identical(glance_cens$aicc, rep(NA_real_, 3))
  expect_identical(glance_cens$nobs, rep(NA_integer_, 3))
  expect_equal(glance_cens$weight, glance$weight, tolerance = 1e-04)
  expect_identical(glance_cens_n$weight, rep(NA_real_, 3))
})
