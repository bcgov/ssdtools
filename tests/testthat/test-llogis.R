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

test_that("dllogis", {
  expect_equal(dllogis(exp(3), 1, 3), 0.003720046)
  expect_equal(dllogis(exp(4), 1, 3), 0.001200358)
})

test_that("fit llogis", {
  dist <- ssd_fit_dist(ssdtools::boron_data, dist = "llogis")

  expect_true(is.fitdist(dist))
  expect_equal(
    coef(dist),
    c(locationlog = 2.6261248978507, scalelog = 0.740309228071107)
  )
})

test_that("pqllogis", {
  expect_equal(log(qllogis(0.5, 1, 1)), 1)
  expect_equal(pllogis(exp(3), 1, 1), 0.880797077977882)
  expect_equal(pllogis(exp(4), 1, 1), 0.952574126822433)
  expect_identical(pllogis(qllogis(0.5, 3, 1), 3, 1), 0.5)
})

test_that("rllogis", {
  set.seed(99)
  r <- rllogis(100000, 1, 1)
  expect_identical(length(r), 100000L)
  expect_equal(mean(log(r)), 0.99552614238909)
})
