test_that("lnorm", {
  x <- ssd_fit_dists(ssdtools::boron_data, dists = "lnorm", tmb = TRUE)
  expect_is(x, "fitdists")
})

test_that("lnorm", {
  x <- ssd_fit_dists(ssdtools::boron_data, dists = "llogis", tmb = TRUE)
  expect_is(x, "fitdists")
})

test_that("combine", {
  x <- ssd_fit_dists(ssdtools::boron_data, dists = c("lnorm", "llogis"), tmb = TRUE)
  expect_is(x, "fitdists")
})
