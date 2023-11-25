#    Copyright 2023 Australian Government Department of 
#    Climate Change, Energy, the Environment and Water
#
#    Licensed under the Apache License, Version 2.0 (the "License");
#    you may not use this file except in compliance with the License.
#    You may obtain a copy of the License at
#
#       https://www.apache.org/licenses/LICENSE-2.0
#
#    Unless required by applicable law or agreed to in writing, software
#    distributed under the License is distributed on an "AS IS" BASIS,
#    WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
#    See the License for the specific language governing permissions and
#    limitations under the License.

test_that("multi", {
  test_dist("multi", multi = TRUE)
  expect_equal(ssd_pmulti(1), 0.493574697632382)
  expect_equal(ssd_qmulti(0.75), 2.21920049918256)
  set.seed(42)
  expect_equal(ssd_rmulti(2), c(5.53133427815926, 7.11054891201997))
  
  expect_equal(ssd_qmulti(ssd_pmulti(c(0, 0.1, 0.5, 0.9, 0.99))), 
               c(0, 0.1, 0.5, 0.9, 0.99), tolerance = 1e-5)
  
  expect_equal(ssd_pmulti(ssd_qmulti(c(0, 0.1, 0.5, 0.9, 0.99))), 
               c(0, 0.1, 0.5, 0.9, 0.99), tolerance = 1e-6)
})

test_that("ssd_pmulti", {
  fit <- ssd_fit_dists(data = ssddata::ccme_boron)
  expect_identical(.ssd_pmulti_fitdists(numeric(0), fit), numeric(0))
  expect_identical(.ssd_pmulti_fitdists(NA_real_, fit), NA_real_)
  expect_identical(.ssd_pmulti_fitdists(-1, fit), 0)
  expect_identical(.ssd_pmulti_fitdists(-Inf, fit), 0)
  expect_equal(.ssd_pmulti_fitdists(Inf, fit), 1)
  expect_equal(.ssd_pmulti_fitdists(0, fit), 0)
  pone <- 0.0389879358571718
  expect_equal(.ssd_pmulti_fitdists(1, fit), pone)
  expect_equal(.ssd_pmulti_fitdists(10000, fit), 0.999954703139271)
  expect_equal(.ssd_pmulti_fitdists(c(1,2), fit), c(pone, 0.0830181438743114))
  expect_equal(.ssd_pmulti_fitdists(c(1,NA), fit), c(pone, NA))
  expect_equal(.ssd_pmulti_fitdists(1, fit, lower.tail = FALSE),  1-pone)
  expect_equal(.ssd_pmulti_fitdists(1, fit, log.p = TRUE), log(pone))
  expect_equal(.ssd_pmulti_fitdists(1, fit, lower.tail = FALSE, log.p = TRUE),  log(1-pone))
})

test_that("ssd_pmulti weights", {
  fit <- ssd_fit_dists(data = ssddata::ccme_boron)
  args <- estimates(fit)
  args$q <- 1
  expect_equal(do.call("ssd_pmulti", args), 0.0389879358571718)
  args$gamma.weight <- 0
  args$lgumbel.weight <- 0
  args$llogis.weight <- 0
  args$lnorm_lnorm.weight <- 0
  args$weibull.weight <- 0
  expect_equal(do.call("ssd_pmulti", args), 0.0195430301950878)
  args$lnorm.weight <- 0
  expect_error(do.call("ssd_pmulti", args), "must be greater than 0")
  args$lnorm.weight <- 1.1
  expect_equal(do.call("ssd_pmulti", args), 0.0195430301950878)
  args$lnorm.weight <- 1
  expect_equal(do.call("ssd_pmulti", args), 0.0195430301950878)
})

test_that("ssd_qmulti", {
  fit <- ssd_fit_dists(data = ssddata::ccme_boron)
  expect_identical(.ssd_qmulti_fitdists(numeric(0), fit), numeric(0))
  expect_identical(.ssd_qmulti_fitdists(NA_real_, fit), NA_real_)
  expect_identical(.ssd_qmulti_fitdists(-1, fit), NaN)
  expect_identical(.ssd_qmulti_fitdists(-Inf, fit), NaN)
  expect_identical(.ssd_qmulti_fitdists(Inf, fit), NaN)
  expect_identical(.ssd_qmulti_fitdists(1, fit), Inf)
  expect_equal(.ssd_qmulti_fitdists(0, fit), 0)
  q75 <- 32.4740714551225
  expect_equal(.ssd_qmulti_fitdists(0.5, fit), 15.3258170124633)
  expect_equal(.ssd_qmulti_fitdists(c(0.5, 0.75), fit), c(15.3258170124633, q75))
  expect_equal(.ssd_qmulti_fitdists(0.25, fit, lower.tail = FALSE), q75)
  expect_equal(.ssd_qmulti_fitdists(log(0.75), fit, log.p = TRUE), q75)
  expect_equal(.ssd_qmulti_fitdists(log(0.25), fit, lower.tail = FALSE, log.p = TRUE), q75)
})

test_that("ssd_qmulti weights", {
  fit <- ssd_fit_dists(data = ssddata::ccme_boron)
  args <- estimates(fit)
  args$p <- 0.25
  expect_equal(do.call("ssd_qmulti", args), 6.1824250029426)
  args$gamma.weight <- 0
  args$lgumbel.weight <- 0
  args$llogis.weight <- 0
  args$lnorm_lnorm.weight <- 0
  args$weibull.weight <- 0
  expect_equal(do.call("ssd_qmulti", args), 5.60825007113764)
  args$lnorm.weight <- 0
  expect_error(do.call("ssd_qmulti", args), "must be greater than 0")
  args$lnorm.weight <- 1.1
  expect_equal(do.call("ssd_qmulti", args), 5.60825007113764)
  args$lnorm.weight <- 1.0
  expect_equal(do.call("ssd_qmulti", args), 5.60825007113764)
})

test_that("ssd_rmulti", {
  fit <- ssd_fit_dists(data = ssddata::ccme_boron)
  args$n <- 0
  expect_equal(.ssd_rmulti_fitdists(n = 0, fit), numeric(0))
  set.seed(99)
  expect_equal(.ssd_rmulti_fitdists(n = 1, fit), 19.752684425643)
  set.seed(99)
  expect_equal(.ssd_rmulti_fitdists(2, fit), c(19.752684425643, 2.69562027500859))
  set.seed(99)
  n100 <- .ssd_rmulti_fitdists(100, fit)
  expect_identical(length(n100), 100L)
  expect_equal(min(n100), 0.0295884248732781)
  expect_equal(max(n100), 168.790837219526)
  expect_equal(mean(n100), 23.4076761093969)
})

test_that("ssd_rmulti all", {
  set.seed(99)
  n100 <- ssd_rmulti(n = 100, 
             burrIII3.weight = 1/10,
             gamma.weight = 1/10,
             gompertz.weight = 1/10,
             invpareto.weight = 1/10,
             lgumbel.weight = 1/10,
             llogis.weight = 1/10,
             llogis_llogis.weight = 1/10,
             lnorm.weight = 1/10,
             lnorm_lnorm.weight = 1/10,
             weibull.weight = 1/10)
  
  expect_identical(length(n100), 100L)
  expect_equal(min(n100), 0.00210111986245713)
  expect_equal(max(n100), 1.58071260063502)
  expect_equal(mean(n100), 0.835204190471024)
})

test_that("ssd_emulti", {
  estimates <- ssd_emulti() 
  expect_snapshot(estimates)
  args <- estimates
  args$q <- 1
  p <- do.call("ssd_pmulti", args)
  args$q <- NULL
  args$p <- p
  q <- do.call("ssd_qmulti", args)
  expect_equal(q, 1.00000074289656)
})
