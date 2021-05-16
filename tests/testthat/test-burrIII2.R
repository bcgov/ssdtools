#    Copyright 2015 Province of British Columbia
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

test_that("dburrIII2 extremes", {
  lifecycle::expect_deprecated(dburrIII2(1))
  rlang::scoped_options(lifecycle_verbosity = "quiet")

  expect_identical(dburrIII2(numeric(0)), numeric(0))
  expect_identical(dburrIII2(NA), NA_real_)
  expect_identical(dburrIII2(NaN), NaN)
  expect_identical(dburrIII2(0), 0)
  expect_equal(dburrIII2(1), 0.25)
  expect_equal(dburrIII2(1, log = TRUE), log(dburrIII2(1)))
  expect_identical(dburrIII2(0), 0)
  expect_identical(dburrIII2(-Inf), 0)
  expect_identical(dburrIII2(Inf), 0)
  expect_identical(dburrIII2(c(NA, NaN, 0, Inf, -Inf)), 
                   c(dburrIII2(NA), dburrIII2(NaN), dburrIII2(0), dburrIII2(Inf), dburrIII2(-Inf)))
  expect_equal(dburrIII2(1:2, 1:2, 3:4), 
               c(dburrIII2(1, 1, 3), dburrIII2(2, 2, 4)))
  expect_equal(dburrIII2(1:2, c(1, NA), 3:4), 
               c(dburrIII2(1, 1, 3), NA))
})

test_that("pburrIII2 extremes", {
  lifecycle::expect_deprecated(pburrIII2(1))
  rlang::scoped_options(lifecycle_verbosity = "quiet")

  expect_identical(pburrIII2(numeric(0)), numeric(0))
  expect_identical(pburrIII2(NA), NA_real_)
  expect_identical(pburrIII2(NaN), NaN)
  expect_identical(pburrIII2(0), 0)
  expect_equal(pburrIII2(1), 0.5)
  expect_equal(pburrIII2(1, log.p = TRUE), log(pburrIII2(1)))
  expect_equal(pburrIII2(1, lower.tail = FALSE), 1 - 0.5)
  expect_equal(pburrIII2(1, lower.tail = FALSE, log.p = TRUE), log(1 - 0.5))
  expect_identical(pburrIII2(0), 0)
  expect_identical(pburrIII2(-Inf), 0)
  expect_identical(pburrIII2(Inf), 1)
  expect_identical(pburrIII2(c(NA, NaN, 0, Inf, -Inf)), 
                   c(pburrIII2(NA), pburrIII2(NaN), pburrIII2(0), pburrIII2(Inf), pburrIII2(-Inf)))
  expect_equal(pburrIII2(1:2, 1:2, 3:4), 
               c(pburrIII2(1, 1, 3), pburrIII2(2, 2, 4)))
  expect_equal(pburrIII2(1:2, c(1, NA), 3:4), 
               c(pburrIII2(1, 1, 3), NA))
})

test_that("qburrIII2 extremes", {
  lifecycle::expect_deprecated(qburrIII2(1))
  rlang::scoped_options(lifecycle_verbosity = "quiet")

  expect_identical(qburrIII2(numeric(0)), numeric(0))
  expect_identical(qburrIII2(NA), NA_real_)
  expect_identical(qburrIII2(NaN), NaN)
  expect_identical(qburrIII2(0), 0)
  expect_identical(qburrIII2(1), Inf)
  expect_equal(qburrIII2(0.75), 3)
  expect_equal(qburrIII2(0.75, log.p = TRUE), NaN)
  expect_equal(qburrIII2(log(0.75), log.p = TRUE), qburrIII2(0.75))
  expect_equal(qburrIII2(0.75, lower.tail = FALSE), qburrIII2(0.25))
  expect_equal(qburrIII2(log(0.75), lower.tail = FALSE, log.p = TRUE), qburrIII2(0.25))
  expect_identical(qburrIII2(0), 0)
  expect_identical(qburrIII2(-Inf), NaN)
  expect_identical(qburrIII2(Inf), NaN)
  expect_identical(qburrIII2(c(NA, NaN, 0, Inf, -Inf)), 
                   c(qburrIII2(NA), qburrIII2(NaN), qburrIII2(0), qburrIII2(Inf), qburrIII2(-Inf)))
  expect_equal(qburrIII2(1:2, 1:2, 3:4), 
               c(qburrIII2(1, 1, 3), qburrIII2(2, 2, 4)))
  expect_equal(qburrIII2(1:2, c(1, NA), 3:4), 
               c(qburrIII2(1, 1, 3), NA))
  expect_equal(qburrIII2(pburrIII2(c(0, 0.1, 0.5, 0.9, 1))), c(0, 0.1, 0.5, 0.9, 1))
})

test_that("rburrIII2 extremes", {
  lifecycle::expect_deprecated(rburrIII2(1))
  rlang::scoped_options(lifecycle_verbosity = "quiet")

  expect_identical(rburrIII2(numeric(0)), numeric(0))
  expect_error(rburrIII2(NA))
  expect_identical(rburrIII2(0), numeric(0))
  set.seed(42)
  expect_equal(rburrIII2(1), 10.7379218085407)
  set.seed(42)
  expect_equal(rburrIII2(1.9), 10.7379218085407)
  set.seed(42)
  expect_equal(rburrIII2(2), c(10.7379218085407, 14.8920392236127))
  set.seed(42)
  expect_equal(rburrIII2(3:4), c(10.7379218085407, 14.8920392236127))
  expect_equal(rburrIII2(0), numeric(0))
  expect_error(rburrIII2(1, shape1 = 1:2))
  expect_error(rburrIII2(1, shape2 = 1:2))
  expect_identical(rburrIII2(1, NA), NA_real_)
})

test_that("dburrIII2", {
  rlang::scoped_options(lifecycle_verbosity = "quiet")

  expect_equal(
    dburrIII2(c(31, 15, 32, 32, 642, 778, 187, 12)),
    c(
      0.0009765625, 0.00390625, 0.000918273645546373, 0.000918273645546373,
      2.41867799897932e-06, 1.64787810975198e-06, 2.82933454051607e-05,
      0.00591715976331361
    )
  )
})

test_that("fit dburrIII2", {
  rlang::scoped_options(lifecycle_verbosity = "quiet")
  data <- data.frame(Conc = c(31, 15, 32, 32, 642, 778, 187, 12))

  dist <- ssd_fit_dist(data, dist = "burrIII2")

  expect_true(is.fitdist(dist))
  expect_equal(coef(dist), c(locationlog = 4.07989187488155, scalelog = 0.937136717088929
  ))

  data$Conc <- data$Conc / 1000

  dist <- ssd_fit_dist(data, dist = "burrIII2")

  expect_true(is.fitdist(dist))
  expect_equal(coef(dist), c(locationlog = -2.82742464158491, scalelog = 0.937137287983746
  ))
})

test_that("fit dburrIII2 cis", {
  rlang::scoped_options(lifecycle_verbosity = "quiet")
  dist <- ssd_fit_dist(ssdtools::boron_data, dist = "burrIII2")

  set.seed(77)
  hc <- ssd_hc(dist, ci = TRUE, nboot = 10)
  expect_is(hc, "tbl_df")
  expect_identical(colnames(hc), c("dist", "percent", "est", "se", "lcl", "ucl"))
  expect_identical(hc$percent, 5)
  expect_equal(hc$est, 1.56256632555312)
  expect_equal(hc$se, 0.533080817076427)
  expect_equal(hc$lcl, 1.02028787432084)
  expect_equal(hc$ucl, 2.4100026087857)
  expect_equal(hc$dist, "burrIII2")
  
  set.seed(77)
  hp <- ssd_hp(dist, conc = 2, ci = TRUE, nboot = 10)
  expect_is(hp, "tbl_df")
  expect_identical(colnames(hp), c("conc", "est", "se", "lcl", "ucl", "dist"))
  expect_equal(hp$conc, 2)
  expect_equal(hp$est, 6.8431214411277)
  expect_equal(hp$se, 2.53471375726922)
  expect_equal(hp$lcl, 3.73102816675466)
  expect_equal(hp$ucl, 10.3929969316288)
  expect_equal(hp$dist, "burrIII2")
})

test_that("burrIII2 and llogis identical", {
  rlang::scoped_options(lifecycle_verbosity = "quiet")
  burr <- ssd_fit_dist(ssdtools::boron_data, dist = "burrIII2")
  llogis <- ssd_fit_dist(ssdtools::boron_data, dist = "llogis")
  expect_identical(ssd_hc(burr)$est, ssd_hc(llogis)$est)
})

test_that("deprecated dburrIII2", {
  expect_error(ssd_fit_dists(ssdtools::boron_data, dist = c("llog", "burrIII2")), "Distributions 'llog', 'burrIII2' and 'llogis' are identical. Please just use 'llogis'.")
})

test_that("deprecated dburrIII2", {
  expect_error(ssd_fit_dists(ssdtools::boron_data, dist = c("llogis", "burrIII2")), "Distributions 'llog', 'burrIII2' and 'llogis' are identical. Please just use 'llogis'.")
})

test_that("burrIII2", {
  rlang::scoped_options(lifecycle_verbosity = "quiet")
  dists <- ssd_fit_dists(boron_data[1:6, ], dists = c("burrIII2", "gamma", "lnorm"))
  expect_identical(names(dists), c("burrIII2", "gamma", "lnorm"))
  expect_equal(coef(dists$burrIII2), c(locationlog = 1.8357959974758, scalelog = 0.547213918037133
  ))
})
