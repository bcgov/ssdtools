context("deprecated")

test_that("ssd_cfplot", {
  setup(pdf(tempfile(fileext = ".pdf")))
  teardown(dev.off())

  expect_warning(ssd_cfplot(boron_data), "is deprecated as of")
})
