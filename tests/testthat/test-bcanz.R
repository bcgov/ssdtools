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
  expect_identical(ssd_dists_bcanz(), ssd_dists(bcanz = TRUE))
})
