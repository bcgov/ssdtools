context("deprecated")

test_that("deprecated llog", {
  dist <- ssdtools:::ssd_fit_dist(ssdtools::boron_data, dist = "llogis")

  expect_true(is.fitdist(dist))
  expect_equal(coef(dist),
  c(scalelog = 0.965466010495141, shapelog = -0.300741556664549))
})
