test_that("ssd_ci_methods", {
  expect_snapshot_value(ssd_ci_methods(), style = "deparse")
})
