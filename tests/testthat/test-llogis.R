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

test_that("dllogis", {
  expect_equal(dllogis(exp(3), 3, 1), 0.003720046, tolerance = 0.0000001)
  expect_equal(dllogis(exp(4), 3, 1), 0.001200358, tolerance = 0.0000001)
})

test_that("fit llogis", {
  dist <- ssdtools:::ssd_fit_dist(ssdtools::boron_data, dist = "llogis")

  expect_true(is.fitdist(dist))
  expect_equal(
    coef(dist),
    c(lscale = 2.6261248978507, lshape = 0.740309228071107)
  )
})

test_that("pqllogis", {
  expect_equal(log(qllogis(0.5, 1, 1)), 1, tolerance = 0.000001)
  expect_equal(pllogis(exp(3), 1, 1), 0.8807971, tolerance = 0.0000001)
  expect_equal(pllogis(exp(4), 1, 1), 0.9525741, tolerance = 0.0000001)
  expect_identical(pllogis(qllogis(0.5, 3, 1), 3, 1), 0.5)
})

test_that("rllogis", {
  set.seed(99)
  r <- rllogis(100000, 1, 1)
  expect_identical(length(r), 100000L)
  expect_equal(mean(log(r)), 1, tolerance = 0.1)
})
