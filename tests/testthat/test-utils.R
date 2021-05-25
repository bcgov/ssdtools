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

test_that("utils", {
  expect_true(is.fitdists(boron_lnorm))
  expect_true(is.fitdists(boron_dists))

  expect_identical(nobs(boron_lnorm), 28L)
  expect_identical(nobs(boron_dists), nobs(boron_lnorm))
#  expect_identical(nobs(fluazinam_lnorm), NA_integer_)
#  expect_identical(nobs(fluazinam_dists), NA_integer_)
  
  expect_equal(ssd_ecd(1:10), seq(0.05, 0.95, by = 0.1))
})

test_that("comma_signif", {
  expect_identical(
    comma_signif(c(0.0191, 1, NA, 177, 1111)),
    c("0.0191", "1", NA, "177", "1,110")
  )
  expect_identical(
    comma_signif(c(0.0191, 1, NA, 177, 1111), digits = 1),
    c("0.02", "1", NA, "200", "1,000")
  )
  expect_identical(
    comma_signif(c(0.1, 1)),
    c("0.1", "1")
  )
  expect_identical(
    comma_signif(c(0.1, 1, 10)),
    c("0.1", "1", "10")
  )
  expect_identical(
    comma_signif(c(0.1, 1, 10, 1000)),
    c("0.1", "1", "10", "1,000")
  )
  expect_identical(
    comma_signif(c(0.55555, 55555)),
    c("0.556", "55,600")
  )
})
