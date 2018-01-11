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

context("lgumbel")

test_that("rlgumbel", {
  set.seed(99)
  r <- rlgumbel(100000, location = 100, scale = 3)
  expect_identical(length(r), 100000L)
  expect_equal(mean(log(r)), 3 * 0.57721 + 100, tolerance = 0.001)
})

test_that("pqlgumbel", {
  expect_equal(log(qlgumbel(0.5, 3, 1)), 3.366513, tolerance = 0.000001)
  expect_equal(plgumbel(exp(3), 3, 1), 0.3678794, tolerance = 0.0000001)
  expect_equal(plgumbel(exp(4), 3, 1), 0.6922006, tolerance = 0.0000001)
  expect_identical(plgumbel(qlgumbel(0.5, 3, 1), 3, 1), 0.5)
})

test_that("dlgumbel", {
 # expect_equal(dlgumbel(exp(3), 3, 1), 0.3678794, tolerance = 0.0000001)
#  expect_equal(dlgumbel(exp(4), 3, 1), 0.2546464, tolerance = 0.0000001)
})
