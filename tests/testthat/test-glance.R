test_that("glance weights independent of rescaling", {
  fit <- ssd_fit_dists(boron_data, rescale = FALSE)
  fit_rescale <- ssd_fit_dists(boron_data, rescale = TRUE)
  
  glance <- glance(fit)
  glance_rescale <- glance(fit_rescale)
  expect_equal(glance_rescale$weight, glance$weight)
})
