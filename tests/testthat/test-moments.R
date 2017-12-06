context("moments")

test_that("moments", {
  moments <- ssd_moments(ccme_data$Conc)
  expect_is(moments, "tbl")
  expect_identical(colnames(moments),
                   c("min", "max", "median", "mean", "sd",
                     "skewness", "kurtosis"))
  expect_identical(moments$min, 0.05)
})
