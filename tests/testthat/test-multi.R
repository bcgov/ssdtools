# Copyright 2015-2023 Province of British Columbia
# Copyright 2021 Environment and Climate Change Canada
# Copyright 2023-2024 Australian Government Department of Climate Change,
# Energy, the Environment and Water
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
  expect_snapshot_value(ssd_pmulti(1, lnorm.weight = 0.5), style = "deparse")
  expect_snapshot_value(ssd_qmulti(0.75, lnorm.weight = 2), style = "deparse")
  withr::with_seed(50, {
    expect_snapshot_value(ssd_rmulti(2, lnorm.weight = 1), style = "deparse")
  })

  withr::with_seed(50, {
    expect_snapshot_value(ssd_rmulti(1, gamma.weight = 0.5, lnorm.weight = 0.5), style = "deparse")
  })

  withr::with_seed(50, {
    expect_snapshot_value(ssd_rmulti(1, gamma.weight = 1, lnorm.weight = 1), style = "deparse")
  })

  expect_snapshot_value(ssd_qmulti(ssd_pmulti(c(0, 0.1, 0.5, 0.9, 0.99), lnorm.weight = 1), lnorm.weight = 1),
                        style = "deparse"
  )

  expect_snapshot_value(ssd_pmulti(ssd_qmulti(c(0, 0.1, 0.5, 0.9, 0.99), lnorm.weight = 1), lnorm.weight = 1),
                        style = "deparse"
  )
  expect_error(ssd_pmulti(0.5), "^At least one distribution must have a positive weight\\.$")
  expect_error(ssd_qmulti(0.75), "^At least one distribution must have a positive weight\\.$")
  expect_error(ssd_rmulti(1), "^At least one distribution must have a positive weight\\.$")
  test_dist("multi", multi = TRUE)
})

test_that("ssd_pmulti", {
  fit <- ssd_fit_dists(data = ssddata::ccme_boron)
  expect_identical(ssd_pmulti_fitdists(numeric(0), fit), numeric(0))
  expect_identical(ssd_pmulti_fitdists(NA_real_, fit), NA_real_)
  expect_identical(ssd_pmulti_fitdists(-Inf, fit), 0)
  expect_equal(ssd_pmulti_fitdists(Inf, fit), 1)
  expect_equal(ssd_pmulti_fitdists(0, fit), 0)
  pone <- 0.0389879276872944
  expect_equal(ssd_pmulti_fitdists(1, fit), pone, tolerance = 1e-5)
  expect_equal(ssd_pmulti_fitdists(10000, fit), 0.999954703139271, tolerance = 1e-6)
  expect_equal(ssd_pmulti_fitdists(c(1, 2), fit), c(pone, 0.0830184001863268), tolerance = 1e-5)
  expect_equal(ssd_pmulti_fitdists(c(1, NA), fit), c(pone, NA), tolerance = 1e-5)
  expect_equal(ssd_pmulti_fitdists(1, fit, lower.tail = FALSE), 1 - pone, tolerance = 1e-6)
  expect_equal(ssd_pmulti_fitdists(1, fit, log.p = TRUE), log(pone), tolerance = 1e-6)
  expect_equal(ssd_pmulti_fitdists(1, fit, lower.tail = FALSE, log.p = TRUE), log(1 - pone), tolerance = 1e-5)
})

test_that("ssd_pmulti weights", {
  fit <- ssd_fit_dists(data = ssddata::ccme_boron)
  args <- estimates(fit)
  args$q <- 1
  expect_equal(do.call("ssd_pmulti", args), 0.0389879276872944, tolerance = 1e-5)
  args$gamma.weight <- 0
  args$lgumbel.weight <- 0
  args$llogis.weight <- 0
  args$lnorm_lnorm.weight <- 0
  args$weibull.weight <- 0
  expect_equal(do.call("ssd_pmulti", args), 0.0195430301950878, tolerance = 1e-5)
  args$lnorm.weight <- 0
  expect_error(do.call("ssd_pmulti", args), "^At least one distribution must have a positive weight\\.$")
  args$lnorm.weight <- 1.1
  expect_equal(do.call("ssd_pmulti", args), 0.0195430301950878, tolerance = 1e-5)
  args$lnorm.weight <- 1
  expect_equal(do.call("ssd_pmulti", args), 0.0195430301950878, tolerance = 1e-5)
})

test_that("ssd_qmulti", {
  fit <- ssd_fit_dists(data = ssddata::ccme_boron)
  expect_identical(ssd_qmulti_fitdists(numeric(0), fit), numeric(0))
  expect_identical(ssd_qmulti_fitdists(NA_real_, fit), NA_real_)
  expect_identical(ssd_qmulti_fitdists(-1, fit), NaN)
  expect_identical(ssd_qmulti_fitdists(-Inf, fit), NaN)
  expect_identical(ssd_qmulti_fitdists(Inf, fit), NaN)
  expect_identical(ssd_qmulti_fitdists(1, fit), Inf)
  expect_equal(ssd_qmulti_fitdists(0, fit), 0)
  q75 <- 32.47404165648
  expect_equal(ssd_qmulti_fitdists(0.5, fit), 15.3258154238153, tolerance = 1e-5)
  expect_equal(ssd_qmulti_fitdists(c(0.5, 0.75), fit), c(15.3258154238153, q75), tolerance = 1e-5)
  expect_equal(ssd_qmulti_fitdists(0.25, fit, lower.tail = FALSE), q75, tolerance = 1e-6)
  expect_equal(ssd_qmulti_fitdists(log(0.75), fit, log.p = TRUE), q75, tolerance = 1e-6)
  expect_equal(ssd_qmulti_fitdists(log(0.25), fit, lower.tail = FALSE, log.p = TRUE), q75, tolerance = 1e-6)
})

test_that("ssd_qmulti weights", {
  fit <- ssd_fit_dists(data = ssddata::ccme_boron)
  args <- estimates(fit)
  args$p <- 0.25
  expect_equal(do.call("ssd_qmulti", args), 6.18242170864532, tolerance = 1e-6)
  args$gamma.weight <- 0
  args$lgumbel.weight <- 0
  args$llogis.weight <- 0
  args$lnorm_lnorm.weight <- 0
  args$weibull.weight <- 0
  expect_equal(do.call("ssd_qmulti", args), 5.60825605931917, tolerance = 1e-6)
  args$lnorm.weight <- 0
  expect_error(do.call("ssd_qmulti", args), "^At least one distribution must have a positive weight\\.$")
  args$lnorm.weight <- 1.1
  expect_equal(do.call("ssd_qmulti", args), 5.60825605931917, tolerance = 1e-6)
  args$lnorm.weight <- 1.0
  expect_equal(do.call("ssd_qmulti", args), 5.60825605931917, tolerance = 1e-6)
})

test_that("ssd_rmulti", {
  fit <- ssd_fit_dists(data = ssddata::ccme_boron)
  args <- estimates(fit)
  args$n <- 0
  expect_equal(ssd_rmulti_fitdists(n = 0, fit), numeric(0))
  withr::with_seed(50, {
    expect_snapshot_value(ssd_rmulti_fitdists(n = 1, fit), style = "deparse")
  })
  withr::with_seed(50, {
    expect_snapshot_value(ssd_rmulti_fitdists(2, fit), style = "deparse")
  })
  withr::with_seed(50, {
    n100 <- ssd_rmulti_fitdists(100, fit)
  })
  expect_identical(length(n100), 100L)
  expect_snapshot_value(min(n100), style = "deparse")
  expect_snapshot_value(max(n100), style = "deparse")
  expect_snapshot_value(mean(n100), style = "deparse")
})

test_that("ssd_rmulti all", {
  withr::with_seed(50, {
    n100 <- ssd_rmulti(
      n = 100,
      burrIII3.weight = 1 / 9,
      gamma.weight = 1 / 9,
      gompertz.weight = 1 / 9,
      lgumbel.weight = 1 / 9,
      llogis.weight = 1 / 9,
      llogis_llogis.weight = 1 / 9,
      lnorm.weight = 1 / 9,
      lnorm_lnorm.weight = 1 / 9,
      weibull.weight = 1 / 9
    )
  })

  expect_identical(length(n100), 100L)
  expect_snapshot_value(min(n100), style = "deparse")
  expect_snapshot_value(max(n100), style = "deparse")
  expect_snapshot_value(mean(n100), style = "deparse")
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
  expect_equal(q, 1)
})

test_that("ssd_pmulti same as pmulti_list", {
  fit <- ssd_fit_dists(data = ssddata::ccme_boron)
  args1 <- estimates(fit)
  args1$q <- 1
  hc1 <- do.call("ssd_pmulti", args1)
  args2 <- list()
  args2$list <- .list_estimates(fit, all_estimates = FALSE)
  args2$q <- 1
  hc2 <- do.call("pmulti_list", args2)
  expect_identical(hc1, hc2)
})
