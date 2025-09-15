test_that("ssd_est_methods", {
  expect_snapshot_value(ssd_est_methods(), style = "deparse")
})
