test_that("dweibull extremes", {
  expect_identical(dweibull(numeric(0)), numeric(0))
  expect_identical(dweibull(NA), NA_real_)
  expect_identical(dweibull(NaN), NaN)
  expect_identical(dweibull(0), 1)
  expect_equal(dweibull(1), 0.367879441171442)
  expect_equal(dweibull(1, log = TRUE), log(0.367879441171442))
  expect_equal(dweibull(1, shape = -1), NaN)
  expect_equal(dweibull(1, scale = -1), NaN)
  expect_identical(dweibull(0), 1)
  expect_identical(dweibull(-Inf), 0)
  expect_identical(dweibull(Inf), 0)
  expect_identical(dweibull(c(NA, NaN, 0, Inf, -Inf)), 
                   c(NA, NaN, 1, 0, 0))
  expect_equal(dweibull(1:2, shape = 1:2, scale = 3:4), 
               c(dweibull(1, 1, 3), dweibull(2, 2, 4)))
  expect_equal(dweibull(1:2, shape = c(1, NA), scale = 3:4), 
               c(dweibull(1, 1, 3), NA))
})

test_that("pweibull extremes", {
  expect_identical(pweibull(numeric(0)), numeric(0))
  expect_identical(pweibull(NA), NA_real_)
  expect_identical(pweibull(NaN), NaN)
  expect_identical(pweibull(0), 0)
  expect_equal(pweibull(1), 0.632120558828558)
  expect_equal(pweibull(1, log.p = TRUE), log(0.632120558828558))
  expect_equal(pweibull(1, lower.tail = FALSE), 1 - 0.632120558828558)
  expect_equal(pweibull(1, lower.tail = FALSE, log.p = TRUE), log(1 - 0.632120558828558))
  expect_equal(pweibull(1, shape = -1), NaN)
  expect_equal(pweibull(1, scale = -1), NaN)
  expect_identical(pweibull(0), 0)
  expect_identical(pweibull(-Inf), 0)
  expect_identical(pweibull(Inf), 1)
  expect_identical(pweibull(c(NA, NaN, 0, Inf, -Inf)), 
                   c(NA, NaN, 0, 1, 0))
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
  expect_equal(qweibull(log(0.75), log.p = TRUE), 1.38629436111989)
  expect_equal(qweibull(0.75, lower.tail = FALSE), qweibull(0.25))
  expect_equal(qweibull(log(0.75), lower.tail = FALSE, log.p = TRUE), qweibull(0.25))
  expect_equal(qweibull(0.5, shape = -1), NaN)
  expect_equal(qweibull(0.5, scale = -1), NaN)
  expect_identical(qweibull(0), 0)
  expect_identical(qweibull(-Inf), NaN)
  expect_identical(qweibull(Inf), NaN)
  expect_identical(qweibull(c(NA, NaN, 0, Inf, -Inf)), 
                   c(NA, NaN, 0, NaN, NaN))
  expect_equal(qweibull(1:2, shape = 1:2, scale = 3:4), 
               c(qweibull(1, 1, 3), qweibull(2, 2, 4)))
  expect_equal(qweibull(1:2, shape = c(1, NA), scale = 3:4), 
               c(qweibull(1, 1, 3), NA))
})

test_that("rweibull extremes", {
  expect_identical(rweibull(numeric(0)), numeric(0))
  expect_error(rweibull(NA))
  expect_identical(rweibull(0), numeric(0))
  expect_error(rweibull(1:2))
  set.seed(42)
  expect_equal(rweibull(1), 0.0890432104972705)
  set.seed(42)
  expect_equal(rweibull(2), c(0.0890432104972705, 0.0649915162066272))
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
  quin <- ssdtools::test_data[ssdtools::test_data$Chemical == "Quinoline", ]
  
  expect_warning(dist <- ssdtools:::ssd_fit_dist(quin, dist = "weibull"))
  expect_true(is.fitdist(dist))
  expect_equal(
    coef(dist),
    c(shape = 0.627542681172847, scale = 15343.492101029)
  )
  expect_equal(
    dist,
    structure(list(estimate = c(shape = 0.627542681172847, scale = 15343.492101029
    ), method = "mle", sd = c(shape = 0.164485792279984, scale = 8924.32277254317
    ), cor = structure(c(1, 0.341253282930738, 0.341253282930738, 
                         1), .Dim = c(2L, 2L), .Dimnames = list(c("shape", "scale"), c("shape", 
                                                                                       "scale"))), vcov = structure(c(0.0270555758619739, 500.933987084448, 
                                                                                                                      500.933987084448, 79643536.9485325), .Dim = c(2L, 2L), .Dimnames = list(
                                                                                                                        c("shape", "scale"), c("shape", "scale"))), loglik = -107.5037479865, 
    aic = 219.007495973, bic = 219.612666158989, n = 10L, data = c(160, 
                                                                   800, 840, 1500, 8200, 12800, 22000, 38000, 60900, 63000), 
    distname = "weibull", fix.arg = NULL, fix.arg.fun = NULL, 
    dots = NULL, convergence = 0L, discrete = FALSE, weights = NULL), class = "fitdist")
  )
})

test_that("fit weibull boron", {
  dist <- ssdtools:::ssd_fit_dist(ssdtools::boron_data, dist = "weibull")
  expect_true(is.fitdist(dist))
  expect_equal(
    coef(dist),
    c(shape = 0.966282452187714, scale = 23.5097477721338)
  )
  expect_equal(
    summary(dist),
    structure(list(estimate = c(shape = 0.966282452187714, scale = 23.5097477721338
    ), method = "mle", sd = c(shape = 0.145444552730083, scale = 4.85283131133218
    ), cor = structure(c(1, 0.320541303503894, 0.320541303503895, 
                         1), .Dim = c(2L, 2L), .Dimnames = list(c("shape", "scale"), c("shape", 
                                                                                       "scale"))), vcov = structure(c(0.0211541179188538, 0.226243783147712, 
                                                                                                                      0.226243783147712, 23.549971736246), .Dim = c(2L, 2L), .Dimnames = list(
                                                                                                                        c("shape", "scale"), c("shape", "scale"))), loglik = -116.812645566597, 
    aic = 237.625291133194, bic = 240.289700153545, n = 28L, 
    data = c(2.1, 2.4, 4.1, 10, 15.6, 18.3, 6, 10, 13.4, 15, 
             20, 20, 20.4, 48.6, 50, 70.7, 70.7, 70.7, 1, 1.8, 2, 4, 5.2, 
             12.3, 30, 34.2, 50, 60), distname = "weibull", fix.arg = NULL, 
    fix.arg.fun = NULL, dots = NULL, convergence = 0L, discrete = FALSE, 
    weights = NULL, ddistname = "dweibull", pdistname = "pweibull", 
    qdistname = "qweibull"), class = c("summary.fitdist", "fitdist"
    ))
  )
})
