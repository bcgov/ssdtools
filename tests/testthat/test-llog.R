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

context("llog")

test_that("rllog", {
  set.seed(99)
  r <- rllog(100000)
  expect_identical(length(r), 100000L)
  expect_equal(mean(log(r)), 1, tolerance = 0.1)
})

test_that("pqllog", {
  expect_equal(log(qllog(0.5)), 1, tolerance = 0.000001)
  expect_equal(pllog(exp(3)), 0.8807971, tolerance = 0.0000001)
  expect_equal(pllog(exp(4)), 0.9525741, tolerance = 0.0000001)
  expect_identical(pllog(qllog(0.5, 3, 1), 3, 1), 0.5)
})

test_that("dllog", {
 expect_equal(dllog(exp(3), 3, 1), 0.003720046, tolerance = 0.0000001)
 expect_equal(dllog(exp(4), 3, 1), 0.001200358, tolerance = 0.0000001)
})
