test_that("augment with lnorm", {
  data <- ssdtools::boron_data
  fits <- ssd_fit_dists(data, dists = "lnorm")
  expect_identical(augment(fits), data)
})

test_that("augment with dists", {
  data <- ssdtools::boron_data
  fits <- ssd_fit_dists(data)
  expect_identical(augment(fits), data)
})
