context("burrIII3")

test_that("dburrIII3", {
  expect_identical(dburrIII3(numeric(0)), numeric(0))
  expect_identical(dburrIII3(NA), NA_real_)

  expect_equal(
    dburrIII3(c(31, 15, 32, 32, 642, 778, 187, 12)),
    c(
      0.0009765625, 0.00390625, 0.000918273645546373, 0.000918273645546373,
      2.41867799897932e-06, 1.64787810975198e-06, 2.82933454051607e-05,
      0.00591715976331361
    )
  )
  expect_equal(
    dburrIII3(c(31, 15, 32, 32, 642, 778, 187, 12), log = TRUE),
    log(c(
      0.0009765625, 0.00390625, 0.000918273645546373, 0.000918273645546373,
      2.41867799897932e-06, 1.64787810975198e-06, 2.82933454051607e-05,
      0.00591715976331361
    ))
  )

  data <- data.frame(Conc = c(31, 15, 32, 32, 642, 778, 187, 12))

  dist <- ssdtools:::ssd_fit_dist(data, dist = "burrIII3")

  expect_true(is.fitdist(dist))
  expect_equal(coef(dist), c(shape1log = 13.7306749122748, shape2log = -0.148593002318655, scalelog = 12.4107584491757))

  data$Conc <- data$Conc / 1000

  dist <- ssdtools:::ssd_fit_dist(data, dist = "burrIII3")

  expect_true(is.fitdist(dist))
  expect_equal(coef(dist), c(shape1log = 14.9250144484367, shape2log = -0.148438502049071, scalelog = 20.7011702445245))
})

test_that("qburrIII3", {
  expect_identical(qburrIII3(numeric(0)), numeric(0))
  expect_identical(qburrIII3(0), 0)
  expect_identical(qburrIII3(1), Inf)
  expect_identical(qburrIII3(NA), NA_real_)
  expect_identical(qburrIII3(0.5), 1)
  expect_equal(qburrIII3(c(0.1, 0.2)), c(0.111111111111111, 0.25))
})

test_that("pburrIII3", {
  expect_identical(pburrIII3(numeric(0)), numeric(0))
  expect_identical(pburrIII3(0), 0)
  expect_identical(pburrIII3(1), 0.5)
  expect_identical(pburrIII3(NA), NA_real_)
  expect_identical(pburrIII3(qburrIII3(0.5)), 0.5)
  expect_equal(
    pburrIII3(qburrIII3(c(.001, .01, .05, .50, .99))),
    c(.001, .01, .05, .50, .99)
  )
})

test_that("rburrIII3", {
  expect_identical(rburrIII3(0), numeric(0))
  set.seed(101)
  expect_equal(
    rburrIII3(10),
    c(
      0.592859849849427, 0.0458334582732346, 2.44452273715775, 1.92133200433186,
      0.33307689063302, 0.428683341542249, 1.40886438557549, 0.500301132990527,
      1.6455863786175, 1.20181169357475
    )
  )
})
