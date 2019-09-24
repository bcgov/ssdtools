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

context("utils")

test_that("utils", {
  expect_true(is.fitdist(boron_lnorm))
  expect_true(is.fitdists(boron_dists))
  expect_true(is.fitdist(boron_dists[["lnorm"]]))
  expect_identical(nobs(boron_lnorm), 28L)
  expect_identical(nobs(boron_dists), nobs(boron_lnorm))
  expect_identical(npars(boron_lnorm), 2L)
  expect_identical(npars(boron_dists), c(
    gamma = 2L, gompertz = 2L, lgumbel = 2L,
    llog = 2L, lnorm = 2L, weibull = 2L
  ))
  expect_identical(
    comma_signif(c(0.0191, 1, NA, 1111)),
    c("0.02", "1", NA, "1,000")
  )
  expect_equal(ssd_ecd(1:10), seq(0.05, 0.95, by = 0.1))
})
