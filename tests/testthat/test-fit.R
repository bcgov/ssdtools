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
  dist <- ssd_fit_dist(boron_data)
  expect_true(is.fitdist(dist))
  expect_identical(dist, boron_lnorm)
})

test_that("fit_dists", {
  dist_names <- c("burr", "gamma", "gompertz", "lgumbel",
                        "llog", "lnorm", "pareto", "weibull")
  dists <- ssd_fit_dists(boron_data, dists = dist_names)
  expect_true(is.fitdists(dists))
  expect_identical(names(dists), dist_names)
})

test_that("fit_dist", {
  dist <- ssd_fit_dist(boron_data)
  expect_true(is.fitdist(dist))
  expect_identical(dist, boron_lnorm)
  expect_equal(coef(dist), c(meanlog = 2.561645, sdlog = 1.241540), tolerance = 0.0000001)

  boron_data2 <- boron_data[rev(order(boron_data$Conc)),]
  boron_data2$Weight <- 1:nrow(boron_data2)

  dist <- ssd_fit_dist(boron_data2, weight = "Weight")
  expect_true(is.fitdist(dist))
  expect_equal(coef(dist), c(meanlog = 1.879717, sdlog = 1.127537), tolerance = 0.000001)
})
