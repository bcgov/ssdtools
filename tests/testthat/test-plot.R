test_that("plot fitdists deprecated to autoplot", {
  fits <- ssd_fit_dists(ssdtools::boron_data, dists = "lnorm")
  
  lifecycle::expect_deprecated(plot(fits))
})

test_that("plot fitdists give ggplot2 object", {
  fits <- ssd_fit_dists(ssdtools::boron_data)
  withr::local_options(lifecycle_verbosity = "quiet")
  expect_snapshot_plot(plot(fits), "plot")
})
