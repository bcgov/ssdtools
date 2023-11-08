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

test_that("subset", {
  x <- list()
  class(x) <- c("fitdists")
  expect_identical(subset(x), x)

  fits <- ssd_fit_dists(ssddata::ccme_boron)

  expect_identical(subset(fits), fits)
  expect_identical(names(subset(fits, c("lnorm", "gamma"))), c("gamma", "lnorm"))
  expect_identical(subset(fits, delta = 10), fits)
  expect_identical(names(subset(fits, delta = 0)), "weibull")
  expect_identical(names(subset(fits, delta = 0.01)), c("gamma", "weibull"))
  expect_identical(names(subset(fits, c("gamma", "lnorm"), delta = 1.5)), c("gamma", "lnorm"))
})
