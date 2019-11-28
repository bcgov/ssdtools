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

context("hc")

test_that("ssd_hc fitdist", {
  x <- ssd_hc(boron_lnorm, nboot = 10L)
  expect_is(x, "tbl")
  expect_identical(colnames(x), c("percent", "est", "se", "lcl", "ucl"))
  expect_identical(x$percent, 5L)
  expect_equal(x$est, 1.68117483775796)
})

test_that("ssd_hc fitdistcens", {
  x <- ssd_hc(fluazinam_lnorm, nboot = 10L)
  expect_is(x, "tbl")
  expect_identical(colnames(x), c("percent", "est", "se", "lcl", "ucl"))
  expect_identical(x$percent, 5L)
  expect_equal(x$est, 1.74352219048516)
})

test_that("ssd_hc fitdists", {
  x <- ssd_hc(boron_dists, nboot = 10L)
  expect_is(x, "tbl")
  expect_identical(colnames(x), c("percent", "est", "se", "lcl", "ucl"))
  expect_identical(x$percent, 5L)
  expect_equal(x$est, 1.25078185265013)
})

test_that("ssd_hc fitdistscens", {
  x <- ssd_hc(fluazinam_dists, nboot = 10L)
  expect_is(x, "tbl")
  expect_identical(colnames(x), c("percent", "est", "se", "lcl", "ucl"))
  expect_identical(x$percent, 5L)
  expect_equal(x$est, 1.61325245103811)
})
