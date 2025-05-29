test_that("ssd_est_methods", {
  expect_identical(ssd_est_methods(), 
                   c("arithmetic", "geometric", "multi"))
})

