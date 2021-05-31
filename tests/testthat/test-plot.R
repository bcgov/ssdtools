test_that("plot fitdists deprecated to autoplot", {
  lifecycle::expect_deprecated(plot(boron_lnorm))
})

test_that("plot fitdists give ggplot2 object", {
  withr::local_options(lifecycle_verbosity = "quiet")
  expect_s3_class(autoplot(boron_lnorm), "ggplot")
})
