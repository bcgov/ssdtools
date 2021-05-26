test_that("dists sorted character", {
  dists <- ssd_dists()
  dists <- dists[!dists %in% c("llog", "burrIII2")]
  fit <- ssd_fit_dists(ssdtools::boron_data, dists = dists)
  expect_identical(names(fit), dists)
  
  fit <- subset(fit, dists[!dists %in% c("gompertz")])
  
  set.seed(101) # for gompertz
  expect_equal(
    estimates(fit),
    list(burrIII3 = list(shape2 = 1.59329245511215, scale = 0.0497870683678639, 
                         shape1 = 0.688625082850707), gamma = list(scale = 25.1268319779061, 
                                                                   shape = 0.950179460431249), lgumbel = list(locationlog = 1.92263082409711, 
                                                                                                              scalelog = 1.23223883525026), llogis = list(locationlog = 2.62627625930417, 
                                                                                                                                                          scalelog = 0.740426376456358), lnorm = list(meanlog = 2.56164496371788, 
                                                                                                                                                                                                      sdlog = 1.24154032419128), mx_llogis_llogis = list(locationlog1 = 0.896785336771335, 
                                                                                                                                                                                                                                                         locationlog2 = 3.14917770255953, scalelog2 = 0.496708998267848, 
                                                                                                                                                                                                                                                         pmix = 0.255223497712533, scalelog1 = 0.317650881482978), 
         weibull = list(scale = 23.5139783002509, shape = 0.966099901938021)))
})
