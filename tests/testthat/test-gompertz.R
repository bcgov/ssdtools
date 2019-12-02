context("gompertz")

test_that("dgompertz", {
  expect_equal(dgompertz(1, shape = 1), 0.487589298719261)
  expect_equal(dgompertz(1, shape = 1, log = TRUE), log(0.487589298719261))
  expect_identical(dgompertz(numeric(0), shape = 1, log = TRUE), numeric(0))
})

test_that("qgompertz", {
  expect_identical(qgompertz(numeric(0)), numeric(0))
  expect_identical(
    qgompertz(0.8),
    0.959134838920824
  )
  expect_identical(qgompertz(log(0.8), log.p = TRUE), qgompertz(0.8))
  expect_equal(qgompertz(pgompertz(0.9)), 0.9)
})

test_that("pgompertz", {
  expect_equal(pgompertz(1), 0.820625921265983)
  expect_equal(pgompertz(1, lower.tail = FALSE), 1 - pgompertz(1))
  expect_equal(pgompertz(1, log.p = TRUE), log(pgompertz(1)))
  expect_identical(pgompertz(numeric(0)), numeric(0))
})

test_that("rgompertz", {
  set.seed(1)
  expect_equal(rgompertz(1, shape = 1), 0.268940346907911)
})
