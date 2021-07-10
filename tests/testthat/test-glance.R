test_that("glance weights rescale log_lik", {
  fits <- ssd_fit_dists(ssdtools::boron_data, dists = c("gamma", "llogis", "lnorm"))
  
  glance <- glance(fits)
  expect_s3_class(glance, "tbl")
  expect_snapshot_data(glance, "glance")
})

test_that("glance weights independent of rescaling", {
  fit <- ssd_fit_dists(boron_data, rescale = FALSE)
  fit_rescale <- ssd_fit_dists(boron_data, rescale = TRUE)
  
  glance <- glance(fit)
  glance_rescale <- glance(fit_rescale)
  expect_equal(glance_rescale$weight, glance$weight)
})

test_that("glance weights rescale log_lik", {
  data <- boron_data
  data$weight <- rep(1, nrow(data))
  fit <- ssd_fit_dists(data, weight = "weight")
  data$weight <- rep(2, nrow(data))
  fit_weight <- ssd_fit_dists(data, weight = "weight")
  
  glance <- glance(fit)
  glance_weight <- glance(fit_weight)
  expect_equal(glance_weight$log_lik/2, glance$log_lik)
})

test_that("glance reweight same log_lik", {
  data <- boron_data
  data$weight <- rep(1, nrow(data))
  fit <- ssd_fit_dists(data, weight = "weight")
  data$weight <- rep(2, nrow(data))
  fit_weight <- ssd_fit_dists(data, weight = "weight", reweight = TRUE)
  
  glance <- glance(fit)
  glance_weight <- glance(fit_weight)
  expect_equal(glance_weight$log_lik, glance$log_lik)
})
