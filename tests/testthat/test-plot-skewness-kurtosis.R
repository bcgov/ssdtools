context("plot_skewness_kurtosis")

test_that("plot_skewness_kurtosis", {
  expect_true(ssd_plot_skewness_kurtosis(ccme_data$Conc))
})
