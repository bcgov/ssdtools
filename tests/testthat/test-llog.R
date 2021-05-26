test_that("deprecated llog", {
  rlang::scoped_options(lifecycle_verbosity = "warning")
  lifecycle::expect_deprecated(fit <- ssd_fit_dists(ssdtools::boron_data, dists = "llog"))
  
  expect_equal(
    estimates(fit$llog),
    list(locationlog = 2.62627762517872, scalelog = 0.740423704979968),
    tolerance = 1e-05
  )
  set.seed(101)
  lifecycle::expect_deprecated(pred <- predict(fit, percent = 1, ci = TRUE, nboot = 10L))
  expect_is(pred, "tbl_df")
  expect_identical(colnames(pred), c("dist", "percent", "est", "se", "lcl", "ucl"))
  expect_identical(pred$percent, 1)
  expect_equal(pred$est, 0.460210318106718)
  expect_equal(pred$se, 0.304821708553508)
  expect_equal(pred$lcl, 0.124061195170828)
  expect_equal(pred$ucl, 1.04405421144148)
  expect_equal(pred$dist, "average")
})

test_that("error llog", {
  expect_error(ssd_fit_dists(ssdtools::boron_data, dist = c("llog", "llogis")), "Distributions 'llog', 'burrIII2' and 'llogis' are identical. Please just use 'llogis'.")
})
