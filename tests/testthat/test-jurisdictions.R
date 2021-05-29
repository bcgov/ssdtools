test_that("ssd_fit_dists_bc", {
  data <- ssdtools::boron_data
  fits_bc <- ssdtools:::ssd_fit_dists_bc(data)
  fits <- ssdtools:::ssd_fit_dists(data, dists = c("gamma", "llogis", "lnorm"))
  
  expect_identical(estimates(fits_bc), estimates(fits))
})
