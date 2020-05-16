test_that("vectorise_vectors works", {
  expect_identical(vectorise_vectors(x = 1), list(x = 1))
  expect_identical(vectorise_vectors(x = "1"), list(x = "1"))
  expect_identical(vectorise_vectors(x = factor("1")), list(x = factor("1")))
  expect_identical(vectorise_vectors(x = 1, y = 2), list(x = 1, y = 2))
  expect_identical(vectorise_vectors(x = 1, y = 1:2), list(x = c(1,1), y = 1:2))
})

test_that("vectorise_vectors edge cases", {
  expect_identical(vectorise_vectors(), structure(list(), .Names = character(0)))
  expect_identical(vectorise_vectors(x = numeric(0)), list(x = numeric(0)))
})

test_that("vectorise_vectors chk_errors", {
  expect_chk_error(vectorise_vectors(x = numeric(0), y = 2))
  expect_chk_error(vectorise_vectors(x = 1:2, y = 1:3))
})
