# Copyright 2023 Province of British Columbia
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

test_that("dists all", {
  expect_identical(
    ssd_dists_all(),
    c(
      "burrIII3", "gamma", "gompertz", "invpareto", "lgumbel", "llogis",
      "llogis_llogis", "lnorm", "lnorm_lnorm", "weibull"
    )
  )
})

test_that("dists all", {
  expect_identical(ssd_dists(), ssd_dists_all())
})

test_that("dists can select none", {
  expect_identical(ssd_dists(npars = 4L), character(0))
})

test_that("dists without tails", {
  expect_identical(ssd_dists(tails = FALSE), "invpareto")
})

test_that("dists 5 pars", {
  expect_identical(ssd_dists(npars = 5L), c("llogis_llogis", "lnorm_lnorm"))
})
