test_that("pweibull extremes", {
  expect_identical(pweibull(numeric(0)), numeric(0))
  expect_identical(pweibull(NA), NA_real_)
  expect_identical(pweibull(NaN), NaN)
  expect_identical(pweibull(0), 0)
  expect_equal(pweibull(1), 0.632120558828558)
  expect_equal(pweibull(1, log.p = TRUE), log(pweibull(1)))
  expect_equal(pweibull(1, lower.tail = FALSE), 1 - pweibull(1))
  expect_equal(pweibull(1, lower.tail = FALSE, log.p = TRUE), log(1 - pweibull(1)))
  expect_equal(pweibull(1, shape = -1), NaN)
  expect_equal(pweibull(1, scale = -1), NaN)
  expect_identical(pweibull(0), 0)
  expect_identical(pweibull(-Inf), 0)
  expect_identical(pweibull(Inf), 1)
  expect_identical(pweibull(c(NA, NaN, 0, Inf, -Inf)), 
                   c(pweibull(NA), pweibull(NaN), pweibull(0), pweibull(Inf), pweibull(-Inf)))
  expect_equal(pweibull(1:2, shape = 1:2, scale = 3:4), 
               c(pweibull(1, 1, 3), pweibull(2, 2, 4)))
  expect_equal(pweibull(1:2, shape = c(1, NA), scale = 3:4), 
               c(pweibull(1, 1, 3), NA))
})

test_that("qweibull extremes", {
  expect_identical(qweibull(numeric(0)), numeric(0))
  expect_identical(qweibull(NA), NA_real_)
  expect_identical(qweibull(NaN), NaN)
  expect_identical(qweibull(0), 0)
  expect_identical(qweibull(1), Inf)
  expect_equal(qweibull(0.75), 1.38629436111989)
  expect_equal(qweibull(0.75, log.p = TRUE), NaN)
  expect_equal(qweibull(log(0.75), log.p = TRUE), qweibull(0.75))
  expect_equal(qweibull(0.75, lower.tail = FALSE), qweibull(0.25))
  expect_equal(qweibull(log(0.75), lower.tail = FALSE, log.p = TRUE), qweibull(0.25))
  expect_equal(qweibull(0.5, shape = -1), NaN)
  expect_equal(qweibull(0.5, scale = -1), NaN)
  expect_identical(qweibull(0), 0)
  expect_identical(qweibull(-Inf), NaN)
  expect_identical(qweibull(Inf), NaN)
  expect_identical(qweibull(c(NA, NaN, 0, Inf, -Inf)), 
                   c(qweibull(NA), qweibull(NaN), qweibull(0), qweibull(Inf), qweibull(-Inf)))
  expect_equal(qweibull(1:2, shape = 1:2, scale = 3:4), 
               c(qweibull(1, 1, 3), qweibull(2, 2, 4)))
  expect_equal(qweibull(1:2, shape = c(1, NA), scale = 3:4), 
               c(qweibull(1, 1, 3), NA))
  expect_equal(qweibull(pweibull(c(0, 0.1, 0.5, 0.9, 1))), c(0, 0.1, 0.5, 0.9, 1))
})

test_that("rweibull extremes", {
  expect_identical(rweibull(numeric(0)), numeric(0))
  expect_error(rweibull(NA))
  expect_identical(rweibull(0), numeric(0))
  set.seed(42)
  expect_equal(rweibull(1), 0.0890432104972705)
  set.seed(42)
  expect_equal(rweibull(1.9), 0.0890432104972705)
  set.seed(42)
  expect_equal(rweibull(2), c(0.0890432104972705, 0.0649915162066272))
  set.seed(42)
  expect_equal(rweibull(3:4), c(0.0890432104972705, 0.0649915162066272))
  expect_equal(rweibull(0, shape = -1), numeric(0))
  expect_equal(rweibull(1, shape = -1), NaN)
  expect_equal(rweibull(2, shape = -1), c(NaN, NaN))
  expect_equal(rweibull(0, scale = -1), numeric(0))
  expect_equal(rweibull(1, scale = -1), NaN)
  expect_equal(rweibull(2, scale = -1), c(NaN, NaN))
  expect_error(rweibull(1, shape = 1:2))
  expect_error(rweibull(1, scale = 1:2))
  expect_identical(rweibull(1, shape = NA), NA_real_)
})

test_that("fit weibull quinoline", {
#  quin <- ssdtools::test_data[ssdtools::test_data$Chemical == "Quinoline", ]
  
#  expect_warning(dist <- ssd_fit_dists(quin, dists = "weibull"))
  # expect_true(is.tmbfit(dist))
  # expect_equal(
  #   coef(dist),
  #   c(shape = 0.627542681172847, scale = 15343.492101029)
  # )
})

test_that("fit weibull boron", {
  fit <- ssd_fit_dists(ssdtools::boron_data, dists = "weibull")
  expect_equal(
    estimates(fit$weibull),
    list(scale = 23.5139731632547, shape = 0.966099859069694),
    tolerance = 1e-06
  )
})
