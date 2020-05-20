test_that("dgamma extremes", {
  expect_identical(dgamma(numeric(0)), numeric(0))
  expect_identical(dgamma(NA), NA_real_)
  expect_identical(dgamma(NaN), NaN)
  expect_identical(dgamma(0), 1)
  expect_equal(dgamma(1), 0.367879441171442)
  expect_equal(dgamma(1, log = TRUE), log(0.367879441171442))
  expect_equal(dgamma(1, shape = -1), NaN)
  expect_equal(dgamma(1, scale = -1), NaN)
  expect_identical(dgamma(-Inf), 0)
  expect_identical(dgamma(Inf), 0)
  
})

test_that("dgamma vectorized", {
  expect_identical(dgamma(c(NA, NaN, 0, Inf, -Inf)), 
                   c(NA, NaN, 1, 0, 0))
  expect_equal(dgamma(1:2, shape = 1:2, scale = 3:4), 
                   c(0.238843770191263, 0.0758163324640792))
})

test_that("fit gamma quinoline", {
  quin <- ssdtools::test_data[ssdtools::test_data$Chemical == "Quinoline", ]

  expect_warning(dist <- ssdtools:::ssd_fit_dist(quin, dist = "gamma"))
  expect_true(is.fitdist(dist))
  expect_equal(
    coef(dist),
    c(scale = 41276.5658303504, shape = 0.504923953282222)
  )
  expect_equal(
    dist,
    structure(list(
      estimate = c(scale = 41276.5658303504, shape = 0.504923953282222), method = "mle", sd = c(scale = NaN, shape = 0), cor = structure(c(
        1,
        NaN, NaN, 1
      ), .Dim = c(2L, 2L), .Dimnames = list(c("scale", "shape"), c("scale", "shape"))), vcov = structure(c(
        -826841669.932486,
        4127.62272829551, 4127.62272829551, 0
      ), .Dim = c(2L, 2L), .Dimnames = list(
        c("scale", "shape"), c("scale", "shape")
      )), loglik = -107.351085142522,
      aic = 218.702170285044, bic = 219.307340471033, n = 10L,
      data = c(
        160, 800, 840, 1500, 8200, 12800, 22000, 38000,
        60900, 63000
      ), distname = "gamma", fix.arg = NULL, fix.arg.fun = NULL,
      dots = NULL, convergence = 0L, discrete = FALSE, weights = NULL
    ), class = "fitdist")
  )
})

test_that("fit gamma boron", {
  dist <- ssdtools:::ssd_fit_dist(ssdtools::boron_data, dist = "gamma")
  expect_true(is.fitdist(dist))
  expect_equal(
    coef(dist),
    c(scale = 25.1263768579472, shape = 0.950051285831343)
  )
  expect_equal(
    summary(dist),
    structure(list(
      estimate = c(scale = 25.1263768579472, shape = 0.950051285831343), method = "mle", sd = c(scale = 7.63754779620063, shape = 0.222498755506702), cor = structure(c(
        1, -0.77023555919141, -0.77023555919141,
        1
      ), .Dim = c(2L, 2L), .Dimnames = list(c("scale", "shape"), c(
        "scale",
        "shape"
      ))), vcov = structure(c(
        58.3321363392491, -1.30889585373456,
        -1.30889585373456, 0.0495056962020313
      ), .Dim = c(2L, 2L), .Dimnames = list(
        c("scale", "shape"), c("scale", "shape")
      )), loglik = -116.815159176174,
      aic = 237.630318352347, bic = 240.294727372698, n = 28L,
      data = c(
        2.1, 2.4, 4.1, 10, 15.6, 18.3, 6, 10, 13.4, 15,
        20, 20, 20.4, 48.6, 50, 70.7, 70.7, 70.7, 1, 1.8, 2, 4, 5.2,
        12.3, 30, 34.2, 50, 60
      ), distname = "gamma", fix.arg = NULL,
      fix.arg.fun = NULL, dots = NULL, convergence = 0L, discrete = FALSE,
      weights = NULL, ddistname = "dgamma", pdistname = "pgamma",
      qdistname = "qgamma"
    ), class = c("summary.fitdist", "fitdist"))
  )
})
