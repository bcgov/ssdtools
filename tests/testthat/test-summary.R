test_that("summary tmbfit", {
  data <- ssdtools::boron_data
  fits <- ssd_fit_dists(data, dists = "lnorm", rescale = FALSE)
  summary <- summary(fits$lnorm)
  expect_s3_class(summary, "summary_tmbfit")
  expect_identical(names(summary), c("dist", "estimates"))
  expect_identical(summary$dist, "lnorm")
  expect_equal(summary$estimates, list(meanlog = 2.56164496371788, sdlog = 1.24154032419128))
})

test_that("summary fitdists", {
  data <- ssdtools::boron_data
  fits <- ssd_fit_dists(data, dists = "lnorm")
  summary <- summary(fits)
  expect_s3_class(summary, "summary_fitdists")
  expect_identical(names(summary), c("fits", "censored", "nrow", "rescaled", "weighted"))
  expect_identical(summary$censored, FALSE)
  expect_identical(summary$nrow, 28L)
  expect_identical(summary$rescaled, 70.7)
  expect_identical(summary$weighted, FALSE)
})

test_that("summary fitdists with multiple dists", {
  data <- ssdtools::boron_data
  fits <- ssd_fit_dists(data, dists = c("gamma", "llogis", "lnorm"),
                        rescale = TRUE)
  summary <- summary(fits)
  expect_s3_class(summary, "summary_fitdists")
  expect_identical(names(summary), c("fits", "censored", "nrow", "rescaled", "weighted"))
  expect_identical(summary$censored, FALSE)
  expect_identical(summary$nrow, 28L)
  expect_identical(summary$rescaled, 70.7)
  expect_identical(summary$weighted, FALSE)
})

test_that("summary fitdists with censored, rescaled, weighted data", {
  data <- ssdtools::boron_data
  data$Mass <- 1:nrow(data)
  data$Other <- data$Conc
  data$Conc[2] <- NA
  fits <- ssd_fit_dists(data, right = "Other", weight = "Mass", rescale = TRUE, dists = "lnorm")
  summary <- summary(fits)
  expect_s3_class(summary, "summary_fitdists")
  expect_identical(names(summary), c("fits", "censored", "nrow", "rescaled", "weighted"))
  expect_identical(summary$censored, TRUE)
  expect_identical(summary$nrow, 28L)
  expect_identical(summary$rescaled, 70.7)
  expect_identical(summary$weighted, TRUE)
})
