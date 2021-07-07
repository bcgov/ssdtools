test_that("pgamma extremes", {
  test_dist("gamma")
  expect_equal(pgamma(1), 0.632120558828558)
  expect_equal(qgamma(0.75), 1.38629436111989)
  set.seed(42)
  expect_equal(rgamma(2), c(1.93929578065309, 0.180419099876704))
})

test_that("fit gamma quinoline", {
  quin <- ssdtools::test_data[ssdtools::test_data$Chemical == "Quinoline", ]

  fit <- ssd_fit_dists(quin, dists = "gamma", rescale = FALSE)
  expect_equal(
    estimates(fit$gamma),
    list(scale = 41201.4269426879, shape = 0.505315645508966),
    tolerance = 1e-05
  )
})

test_that("fit gamma boron", {
  fit <- ssd_fit_dists(ssdtools::boron_data, dists = "gamma", rescale = FALSE)
  expect_equal(
    estimates(fit$gamma),
    list(scale = 25.1268322377578, shape = 0.950179464489889),
    tolerance = 1e-06
  )
})
