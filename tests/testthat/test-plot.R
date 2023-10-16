test_that("plot fitdists now defunct", {
  fits <- ssd_fit_dists(ssddata::ccme_boron, dists = "lnorm")

  lifecycle::expect_defunct(plot(fits))
})
