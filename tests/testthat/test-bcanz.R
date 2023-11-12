test_that("ssd_dists_bcanz works", {
  expect_identical(
    ssd_dists_bcanz(),
    c(
      "gamma", "lgumbel", "llogis",
      "lnorm", "lnorm_lnorm", "weibull"
    )
  )
})

test_that("ssd_dists_bcanz works", {
  fit <- ssd_fit_bcanz(data = ssddata::ccme_boron)
  set.seed(10)
  hc <- ssd_hc_bcanz(fit, nboot = 10)
  expect_snapshot_data(hc, "hc_chloride")
})
