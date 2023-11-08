test_that("wt_est_nest works", {
  fit <- ssd_fit_dists(data = ssddata::ccme_boron)
  wt_est <- ssd_wt_est(fit)
  expect_identical(check_wt_est(wt_est), wt_est)
})

test_that("ssd_pmulti", {
  fit <- ssd_fit_dists(data = ssddata::ccme_boron)
  wt_est <- ssd_wt_est(fit)
  expect_identical(ssd_pmulti(numeric(0), wt_est), numeric(0))
  expect_identical(ssd_pmulti(NA_real_, wt_est), NA_real_)
  expect_identical(ssd_pmulti(-1, wt_est), 0)
  expect_identical(ssd_pmulti(-Inf, wt_est), 0)
  expect_identical(ssd_pmulti(Inf, wt_est), 1)
  expect_equal(ssd_pmulti(0, wt_est), 0)
  pone <- 0.0391155639855389
  expect_equal(ssd_pmulti(1, wt_est), pone)
  expect_equal(ssd_pmulti(10000, wt_est), 0.99991762078885, tolerance = 1e-5)
  expect_equal(ssd_pmulti(c(1,2), wt_est), c(pone, 0.083756266589807))
  expect_equal(ssd_pmulti(c(1,NA), wt_est), c(pone, NA))
  expect_equal(ssd_pmulti(1, wt_est, lower.tail = FALSE),  1-pone)
  expect_equal(ssd_pmulti(1, wt_est, log.p = TRUE), log(pone))
  expect_equal(ssd_pmulti(1, wt_est, lower.tail = FALSE, log.p = TRUE),  log(1-pone))
})

test_that("ssd_pmulti weights", {
  fit <- ssd_fit_dists(data = ssddata::ccme_boron)
  wt_est <- ssd_wt_est(fit)
  expect_equal(ssd_pmulti(1, wt_est), 0.0391155639855389)
  wt_est$weight[wt_est$dist != "lnorm"] <- 0
  expect_equal(ssd_pmulti(1, wt_est), 0.0195438776703809)
  wt_est$weight[wt_est$dist == "lnorm"] <- 0
  expect_error(ssd_pmulti(1, wt_est), "must be greater than 0")
  wt_est$weight[wt_est$dist == "lnorm"] <- 1.1
  expect_error(ssd_pmulti(1, wt_est), "must have values between 0 and 1")
  wt_est$weight[wt_est$dist == "lnorm"] <- 1
  expect_equal(ssd_pmulti(1, wt_est), 0.0195438776703809)
})
  
test_that("ssd_qmulti", {
  fit <- ssd_fit_dists(data = ssddata::ccme_boron)
  wt_est <- ssd_wt_est(fit)
  expect_identical(ssd_qmulti(numeric(0), wt_est), numeric(0))
  expect_identical(ssd_qmulti(NA_real_, wt_est), NA_real_)
  expect_identical(ssd_qmulti(-1, wt_est), NaN)
  expect_identical(ssd_qmulti(-Inf, wt_est), NaN)
  expect_identical(ssd_qmulti(Inf, wt_est), NaN)
  expect_identical(ssd_qmulti(1, wt_est), Inf)
  expect_equal(ssd_qmulti(0, wt_est), 0)
  q75 <- 32.4740714551225
  expect_equal(ssd_qmulti(0.5, wt_est), 15.3258170124633)
  expect_equal(ssd_qmulti(c(0.5, 0.75), wt_est), c(15.3258170124633, q75))
  expect_equal(ssd_qmulti(0.25, wt_est, lower.tail = FALSE), q75)
  expect_equal(ssd_qmulti(log(0.75), wt_est, log.p = TRUE), q75)
  expect_equal(ssd_qmulti(log(0.25), wt_est, lower.tail = FALSE, log.p = TRUE), q75)
})

test_that("ssd_qmulti weights", {
  fit <- ssd_fit_dists(data = ssddata::ccme_boron)
  wt_est <- ssd_wt_est(fit)
  expect_equal(ssd_qmulti(0.25, wt_est), 6.1824250029426)
  wt_est$weight[wt_est$dist != "lnorm"] <- 0
  expect_equal(ssd_qmulti(0.25, wt_est), 5.60825026439554)
  wt_est$weight[wt_est$dist == "lnorm"] <- 0
  expect_error(ssd_qmulti(0.25, wt_est), "must be greater than 0")
  wt_est$weight[wt_est$dist == "lnorm"] <- 1.1
  expect_error(ssd_qmulti(0.25, wt_est), "must have values between 0 and 1")
  wt_est$weight[wt_est$dist == "lnorm"] <- 1
  expect_equal(ssd_qmulti(0.25, wt_est), 5.60825026439554)
})

test_that("ssd_rmulti", {
  fit <- ssd_fit_dists(data = ssddata::ccme_boron)
  wt_est <- ssd_wt_est(fit)
  expect_equal(ssd_rmulti(0, wt_est), numeric(0))
  set.seed(99)
  expect_equal(ssd_rmulti(1, wt_est), 19.752684425643)
  set.seed(99)
  expect_equal(ssd_rmulti(2, wt_est), c(19.752684425643, 2.69562027500859))
  set.seed(99)
  n100 <- ssd_rmulti(100, wt_est)
  expect_identical(length(n100), 100L)
  expect_equal(min(n100), 0.0295884248732781)
  expect_equal(max(n100), 168.790837219526)
  expect_equal(mean(n100), 23.4076761093969)
})
