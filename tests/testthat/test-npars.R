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

test_that("npars", {
  expect_identical(npars(boron_lnorm), c(lnorm = 2L))
  expect_identical(npars(boron_dists), c(gamma = 2L, llogis = 2L, lnorm = 2L))
  dists <- ssd_fit_dists(ssdtools::boron_data, dists = c("llogis_llogis", "lnorm_lnorm", "lnorm", "invpareto"))
  expect_identical(npars(dists), c(llogis_llogis = 5L, lnorm_lnorm = 5L, lnorm = 2L, invpareto = 1L))
})
