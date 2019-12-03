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

context("gompertz")

test_that("dgompertz", {
  expect_equal(dgompertz(1, shape = 1), 0.487589298719261)
  expect_equal(dgompertz(1, shape = 1, log = TRUE), log(0.487589298719261))
  expect_identical(dgompertz(numeric(0), shape = 1, log = TRUE), numeric(0))
})

test_that("fit gompertz", {
  dist <- ssdtools:::ssd_fit_dist(ssdtools::boron_data, dist = "gompertz")

  expect_true(is.fitdist(dist))
  expect_equal(coef(dist),
  c(shape = 0.0394118062171637, scale = 0.00260015114608545),
  tolerance = 1e-05)
})

test_that("qgompertz", {
  expect_identical(qgompertz(numeric(0)), numeric(0))
  expect_identical(
    qgompertz(0.8),
    0.959134838920824
  )
  expect_identical(qgompertz(log(0.8), log.p = TRUE), qgompertz(0.8))
  expect_equal(qgompertz(pgompertz(0.9)), 0.9)
})

test_that("pgompertz", {
  expect_equal(pgompertz(1), 0.820625921265983)
  expect_equal(pgompertz(1, lower.tail = FALSE), 1 - pgompertz(1))
  expect_equal(pgompertz(1, log.p = TRUE), log(pgompertz(1)))
  expect_identical(pgompertz(numeric(0)), numeric(0))
})

test_that("rgompertz", {
  set.seed(1)
  expect_equal(rgompertz(1, shape = 1), 0.268940346907911)
})
