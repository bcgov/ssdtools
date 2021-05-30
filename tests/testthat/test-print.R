test_that("print tmbfit", {
  local_edition(3)
  data <- ssdtools::boron_data
  fits <- ssd_fit_dists(data, dists = "lnorm")
  expect_snapshot_output(print(fits$lnorm))
})

test_that("print fitdists", {
  local_edition(3)
  data <- ssdtools::boron_data
  fits <- ssd_fit_dists(data, dists = "lnorm")
  expect_snapshot_output(print(fits))
})

test_that("summary fitdists with censored, rescaled, weighted data", {
  local_edition(3)
  data <- ssdtools::boron_data
  data$Mass <- 1:nrow(data)
  data$Other <- data$Conc
  data$Conc[2] <- NA
  fits <- ssd_fit_dists(data, right = "Other", weight = "Mass", rescale = TRUE, dists = "lnorm")
  expect_snapshot_output(print(fits))
})