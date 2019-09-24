#    Copyright 2015 Province of British Columbia
#
#    Licensed under the Apache License, Version 2.0 (the "License");
#    you may not use this file except in compliance with the License.
#    You may obtain a copy of the License at
#
#       http://www.apache.org/licenses/LICENSE-2.0
#
#    Unless required by applicable law or agreed to in writing, software
#    distributed under the License is distributed on an "AS IS" BASIS,
#    WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
#    See the License for the specific language governing permissions and
#    limitations under the License.

context("fit")

test_that("fit_dist", {
  dist <- ssd_fit_dist(ssdtools::boron_data)
  expect_true(is.fitdist(dist))
  expect_identical(dist, boron_lnorm)
})

test_that("fit_dist tiny llog", {
  data <- ssdtools::boron_data
  data$Conc <- data$Conc / 100
  # llog initial values need adjusting when small values
  expect_error(ssd_fit_dist(data, dist = "llog"), "the function mle failed to estimate the parameters")
})

test_that("fit_dists", {
  dist_names <- c(
    "gamma", "gompertz", "lgumbel",
    "llog", "lnorm", "pareto", "weibull"
  )
  expect_error(ssd_fit_dists(boron_data[1:5, ]), "all distributions failed to fit")
  dists <- ssd_fit_dists(boron_data[1:6, ], dists = dist_names)
  expect_true(is.fitdists(dists))
  expect_identical(names(dists), dist_names)
  coef <- stats::coef(dists)
  expect_identical(names(coef), dist_names)
})

test_that("fit_dist", {
  expect_error(ssd_fit_dist(boron_data[1:5, ]), "data must have at least 6 rows")
  dist <- ssd_fit_dist(boron_data)
  expect_true(is.fitdist(dist))
  expect_identical(dist, boron_lnorm)
  expect_equal(coef(dist), c(meanlog = 2.561645, sdlog = 1.241540), tolerance = 0.0000001)

  boron_data2 <- boron_data[rev(order(boron_data$Conc)), ]
  boron_data2$Weight <- 1:nrow(boron_data2)

  dist <- ssd_fit_dist(boron_data2, weight = "Weight")
  expect_true(is.fitdist(dist))
  expect_equal(coef(dist), c(meanlog = 1.879717, sdlog = 1.127537), tolerance = 0.000001)
})

test_that("fluazinam", {
  data(fluazinam, package = "fitdistrplus")
  dist <- ssd_fit_dist(fluazinam, left = "left")
  expect_true(is.fitdist(dist))
  expect_false(is.fitdistcens(dist))
  expect_equal(coef(dist), c(meanlog = 4.660186, sdlog = 2.197562), tolerance = 0.0000001)

  dist <- ssd_fit_dist(fluazinam, left = "left", right = "right")
  expect_false(is.fitdist(dist))
  expect_true(is.fitdistcens(dist))
  expect_equal(coef(dist), c(meanlog = 4.976920, sdlog = 2.687785), tolerance = 0.0000001)

  fluazinam2 <- fluazinam[rev(order(fluazinam$left)), ]
  fluazinam2$Weight <- 1:nrow(fluazinam2)

  dist <- ssd_fit_dist(fluazinam2, weight = "Weight", left = "left", right = "right")
  expect_false(is.fitdist(dist))
  expect_true(is.fitdistcens(dist))
  expect_equal(coef(dist), c(meanlog = 3.566750, sdlog = 2.182757), tolerance = 0.000001)
})
