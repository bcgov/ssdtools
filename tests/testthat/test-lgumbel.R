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
  expect_equal(log(qlgumbel(c(0.2, 0.5, 0.9), 3, 1)), c(2.52411500467289, 3.36651292058166, 5.25036732731245))
  expect_equal(log(qlgumbel(c(0.2, 0.5, 0.9), 3, 1,
                            lower.tail = FALSE)), c(4.49993998675952, 3.36651292058166, 2.16596755475204))
  
  expect_identical(log(qlgumbel(-1, log.p = TRUE)), 
               log(qlgumbel(exp(-1))))

  expect_equal(plgumbel(exp(3), 3, 1), 0.3678794, tolerance = 0.0000001)
  expect_equal(plgumbel(exp(4), 3, 1), 0.6922006, tolerance = 0.0000001)
  expect_identical(plgumbel(qlgumbel(0.5, 3, 1), 3, 1), 0.5)
})

test_that("dlgumbel", {
  expect_equal(dlgumbel(exp(3), 3, 1), 0.01831564, tolerance = 0.0000001)
  expect_equal(dlgumbel(exp(4), 3, 1), 0.004664011, tolerance = 0.0000001)
})
