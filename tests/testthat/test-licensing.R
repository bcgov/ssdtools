test_that("licensing works", {
  expect_true(chk::vld_string(licensing_md()))
})
