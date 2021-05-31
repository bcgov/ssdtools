test_that("print tmbfit", {
  fits <- ssd_fit_dists(boron_data, dists = "lnorm")
  expect_snapshot_output(print(fits$lnorm))
})

test_that("print fitdists", {
  fits <- ssd_fit_dists(boron_data, dists = "lnorm")
  expect_snapshot_output(print(fits))
})

test_that("summary fitdists with censored, rescaled, weighted data", {
  data <- ssdtools::boron_data
  data$Mass <- 1:nrow(data)
  data$Other <- data$Conc
  data$Conc[2] <- NA
  fits <- ssd_fit_dists(data, right = "Other", weight = "Mass", rescale = TRUE, dists = "lnorm")
  expect_snapshot_output(print(fits))
})

test_that("print fitdists with multiple distributions", {
  fits <- ssd_fit_dists(boron_data, dists = c("gamma", "llogis", "lnorm"))
  expect_snapshot_output(print(fits))
})
