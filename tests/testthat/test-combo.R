test_that("wt_est_nest works", {
  fit <- ssd_fit_dists(data = ssddata::ccme_boron)
  wt_est <- wt_est_nest(fit)
  expect_identical(check_wt_est(wt_est), wt_est)
})

test_that("ssd_pcombo", {
  fit <- ssd_fit_dists(data = ssddata::ccme_boron)
  wt_est <- wt_est_nest(fit)
  expect_equal(ssd_pcombo(1, wt_est), 0.0391103597328257)
  expect_equal(ssd_pcombo(numeric(0), wt_est), numeric(0))
})

test_that("ssd_qcombo", {
  fit <- ssd_fit_dists(data = ssddata::ccme_boron)
  wt_est <- wt_est_nest(fit)
  expect_equal(ssd_qcombo(0.5, wt_est, upper = 100), 15.3258287163047)
  expect_equal(ssd_qcombo(numeric(0), wt_est), numeric(0))
})
