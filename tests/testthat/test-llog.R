test_that("deprecated llog", {
  rlang::scoped_options(lifecycle_verbosity = "warning")
  lifecycle::expect_deprecated(dist <- ssd_fit_dist(ssdtools::boron_data, dist = "llog"))
  
  expect_true(is.fitdist(dist))
  expect_equal(
    coef(dist),
    c(locationlog = 2.6261248978507, scalelog = 0.740309228071107
    )
  )
  set.seed(101)
  lifecycle::expect_deprecated(pred <- predict(dist, percent = 1, ci = TRUE, nboot = 10L))
  expect_is(pred, "tbl_df")
  expect_identical(colnames(pred), c("percent", "est", "se", "lcl", "ucl", "dist", "wt"))
  expect_identical(pred$percent, 1)
  expect_equal(pred$est, 0.460388430679064)
  expect_equal(pred$se, 0.305015200817155)
  expect_equal(pred$lcl, 0.124204402582017)
  expect_equal(pred$ucl, 1.04527103315379)
  expect_equal(pred$dist, "llog")
  expect_equal(pred$wt, 1)
})

test_that("error llog", {
  expect_error(ssd_fit_dists(ssdtools::boron_data, dist = c("llog", "llogis")), "Distributions 'llog', 'burrIII2' and 'llogis' are identical. Please just use 'llogis'.")
})
