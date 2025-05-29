test_that("ssd_ci_methods", {
  expect_identical(ssd_ci_methods(), 
                   c("MACL", "multi_fixed", "multi_free", "weighted_samples"))
})
