test_that("print tmbfit", {
  fits <- ssd_fit_dists(ssdtools::boron_data, dists = "lnorm")
  expect_snapshot_output(print(fits$lnorm))
})

test_that("print fitdists", {
  fits <- ssd_fit_dists(ssdtools::boron_data, dists = "lnorm")
  expect_snapshot_output(print(fits))
})

test_that("summary fitdists with left censored, rescaled, weighted data", {
  data <- ssdtools::boron_data
  data$Mass <- 1:nrow(data)
  data$Other <- data$Conc
  data$Conc[2] <- NA
  fits <- ssd_fit_dists(data, right = "Other", weight = "Mass", rescale = TRUE, dists = "lnorm")
  expect_snapshot_output(print(fits))
})

test_that("summary fitdists with inconsistently censored data", {
  data <- ssdtools::boron_data
  data$Conc2 <- data$Conc
  data$Conc[1] <- 1
  data$Conc2[1] <- 2
  fits <- ssd_fit_dists(data, right = "Conc2", dists = "lnorm")
  expect_snapshot_output(print(fits))
})

test_that("summary fitdists with right censored, rescaled, weighted data", {
  data <- ssdtools::boron_data
  data$Mass <- 1:nrow(data)
  data$Other <- data$Conc
  data$Other[1] <- Inf
  expect_error(fits <- ssd_fit_dists(data, right = "Other", weight = "Mass", rescale = TRUE, dists = "lnorm"))
  # expect_snapshot_output(print(fits))
})

test_that("print fitdists with multiple distributions", {
  boron_dists <- ssd_fit_dists(ssdtools::boron_data)
  expect_snapshot_output(print(boron_dists))
})
