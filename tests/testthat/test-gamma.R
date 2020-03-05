test_that("fit gamma quinoline", {
  quin <- ssdtools::test_data[ssdtools::test_data$Chemical == "Quinoline",]
  
  expect_warning(dist <- ssdtools:::ssd_fit_dist(quin, dist = "gamma"))
  expect_true(is.fitdist(dist))
  expect_equal(
    coef(dist),
    c(scale = 41276.5658303504, shape = 0.504923953282222)
  )
  expect_equal(dist,
               structure(list(estimate = c(scale = 41276.5658303504, shape = 0.504923953282222
), method = "mle", sd = c(scale = NaN, shape = 0), cor = structure(c(1, 
NaN, NaN, 1), .Dim = c(2L, 2L), .Dimnames = list(c("scale", "shape"
), c("scale", "shape"))), vcov = structure(c(-826841669.932486, 
4127.62272829551, 4127.62272829551, 0), .Dim = c(2L, 2L), .Dimnames = list(
    c("scale", "shape"), c("scale", "shape"))), loglik = -107.351085142522, 
    aic = 218.702170285044, bic = 219.307340471033, n = 10L, 
    data = c(160, 800, 840, 1500, 8200, 12800, 22000, 38000, 
    60900, 63000), distname = "gamma", fix.arg = NULL, fix.arg.fun = NULL, 
    dots = NULL, convergence = 0L, discrete = FALSE, weights = NULL), class = "fitdist"))
})
