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
  expect_equal(dgompertz(1, lshape = 0), 0.487589298719261)
  expect_equal(dgompertz(1, lshape = 0, log = TRUE), log(0.487589298719261))
  expect_identical(dgompertz(numeric(0), lshape = 0, log = TRUE), numeric(0))
})

test_that("fit gompertz", {
  set.seed(9)
  dist <- ssdtools:::ssd_fit_dist(ssdtools::boron_data, dist = "gompertz")
  
  expect_true(is.fitdist(dist))
  expect_equal(coef(dist),
               c(lshape = -3.23394197210355, lscale = -5.94837894139464))
})

test_that("fit gompertz cis", {
  dist <- ssdtools:::ssd_fit_dist(ssdtools::boron_data, dist = "gompertz")
  
  set.seed(77)
  expect_equal(as.data.frame(ssd_hc(dist, ci = TRUE, nboot = 10)),
  structure(list(percent = 5, est = 1.29966505882089, se = 0.210577831926091, 
    lcl = 1.06020559561544, ucl = 1.65959404402591, dist = "gompertz"), class = "data.frame", row.names = c(NA, 
-1L)), tolerance = 1e-03)
  
  set.seed(77)
   expect_equal(as.data.frame(ssd_hp(dist, conc = 2, ci = TRUE, nboot = 10)),
structure(list(conc = 2, est = 7.59650778517607, se = 1.14878323330099, 
    lcl = 6.00209908449661, ucl = 9.2251620377782, dist = "gompertz"), class = "data.frame", row.names = c(NA, 
-1L)), tolerance = 1e-03)
})

test_that("qgompertz", {
  expect_identical(qgompertz(numeric(0)), numeric(0))
  expect_identical(
    qgompertz(0.8),
    0.959134838920824
  )
  expect_identical(
    qgompertz(0),
    0
  )
  expect_identical(
    qgompertz(1),
    Inf
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
  expect_equal(rgompertz(1, lshape = 0), 0.268940346907911)
})
