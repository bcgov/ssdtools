context("burrIII2")

test_that("dburrIII2", {
  expect_identical(dburrIII2(numeric(0)), numeric(0))
  expect_identical(dburrIII2(NA), NA_real_)

  expect_equal(
    dburrIII2(c(31, 15, 32, 32, 642, 778, 187, 12), scalelog = 0),
    c(
      0.0009765625, 0.00390625, 0.000918273645546373, 0.000918273645546373,
      2.41867799897932e-06, 1.64787810975198e-06, 2.82933454051607e-05,
      0.00591715976331361
    )
  )
  expect_equal(
    dburrIII2(c(31, 15, 32, 32, 642, 778, 187, 12),  scalelog = 0, log = TRUE),
    log(c(
      0.0009765625, 0.00390625, 0.000918273645546373, 0.000918273645546373,
      2.41867799897932e-06, 1.64787810975198e-06, 2.82933454051607e-05,
      0.00591715976331361
    ))
  )
})

test_that("fit burrIII2", {
  data <- data.frame(Conc = c(31, 15, 32, 32, 642, 778, 187, 12))

  dist <- ssdtools:::ssd_fit_dist(data, dist = "burrIII2")

  expect_true(is.fitdist(dist))
  expect_equal(coef(dist), c(shapelog = 0.101242679105766, scalelog = -3.92364881206751))

  data$Conc <- data$Conc / 1000

  dist <- ssdtools:::ssd_fit_dist(data, dist = "burrIII2")

  expect_true(is.fitdist(dist))
  expect_equal(coef(dist), c(shapelog = 0.101250994107126, scalelog = 2.98432920414956))
})

test_that("qburrIII2", {
  expect_identical(qburrIII2(numeric(0)), numeric(0))
  expect_identical(qburrIII2(0), 0)
  expect_identical(qburrIII2(1), Inf)
  expect_identical(qburrIII2(NA), NA_real_)
  expect_identical(qburrIII2(0.5, scalelog = 0), 1)
  expect_equal(qburrIII2(c(0.1, 0.2), scalelog = 0), c(0.111111111111111, 0.25))
})

test_that("pburrIII2", {
  expect_identical(pburrIII2(numeric(0)), numeric(0))
  expect_identical(pburrIII2(0), 0)
  expect_identical(pburrIII2(1, scalelog = 0), 0.5)
  expect_identical(pburrIII2(NA), NA_real_)
  expect_identical(pburrIII2(qburrIII2(0.5)), 0.5)
  expect_equal(
    pburrIII2(qburrIII2(c(.001, .01, .05, .50, .99))),
    c(.001, .01, .05, .50, .99)
  )
})

test_that("rburrIII2", {
  expect_identical(rburrIII2(0), numeric(0))
  set.seed(101)
  expect_equal(
    rburrIII2(10, scalelog = 0),
    c(
      0.592859849849427, 0.0458334582732346, 2.44452273715775, 1.92133200433186,
      0.33307689063302, 0.428683341542249, 1.40886438557549, 0.500301132990527,
      1.6455863786175, 1.20181169357475
    )
  )
})
