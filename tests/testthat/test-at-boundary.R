test_that("test at boundary 2 9", {
  withr::with_seed(42, {
    data <- data.frame(Conc = c(0.02, 0.01, rlnorm(9, 1)))
    fit <- ssd_fit_dists(data = data)
  })
  expect_equal(unname(fit$lnorm_lnorm$optim$par["pmix"]), ssd_min_pmix(nrow(data)))
  gof <- ssd_gof(fit)
  expect_snapshot_data(gof, "b29")
})

test_that("test at boundary 2 14", {
  withr::with_seed(42, {
    data <- data.frame(Conc = c(0.01, 0.02, rlnorm(14, 1)))
    fit <- ssd_fit_dists(data = data)
  })
  expect_equal(unname(fit$lnorm_lnorm$optim$par["pmix"]), ssd_min_pmix(nrow(data)))
  gof <- ssd_gof(fit)
  expect_snapshot_data(gof, "b214")
})

test_that("test at boundary 2 23", {
  withr::with_seed(42, {
    data <- data.frame(Conc = c(0.01, 0.012, rlnorm(23, 1)))
    fit <- ssd_fit_dists(data = data)
  })
  expect_equal(unname(fit$lnorm_lnorm$optim$par["pmix"]),
               0.211770893307891)
  gof <- ssd_gof(fit)
  expect_snapshot_data(gof, "b223")
})
