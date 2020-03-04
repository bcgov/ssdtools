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

context("data")

test_that("data", {
  expect_null(chk::check_data(
    ccme_data,
    values = list(
      Chemical = "",
      Species = "",
      Units = c("mg/L", "ug/L", "ng/L"),
      Conc = c(0, Inf),
      Group = factor(c("Amphibian", "Fish", "Invertebrate", "Plant"))
    ),
    nrow = c(1L, 2147483647L)
  ))
  expect_is(ccme_data, "tbl")

  expect_null(chk::check_data(
    boron_data,
    values = list(
      Chemical = c("Boron", "Boron"),
      Species = "",
      Units = c("mg/L", "mg/L"),
      Conc = c(1.0, 70.7),
      Group = factor(c("Amphibian", "Fish", "Invertebrate", "Plant"))
    ),
    nrow = 28
  ))
  expect_is(boron_data, "tbl")

  expect_null(chk::check_data(
    boron_pred,
    values = list(
      percent = 1L,
      est = 1,
      se = 1,
      lcl = 1,
      ucl = 1
    ),
    nrow = 99L
  ))
  expect_is(boron_pred, "tbl")

  expect_is(boron_lnorm, "fitdist")
  expect_is(boron_dists, "fitdists")
})
