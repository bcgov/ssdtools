#    Copyright 2021 Province of British Columbia
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

test_that("weibull", {
  test_dist("weibull")
  expect_equal(ssd_pweibull(1), 0.632120558828558)
  expect_equal(ssd_qweibull(0.75), 1.38629436111989)
  set.seed(42)
  expect_equal(ssd_rweibull(2), c(0.0890432104972705, 0.0649915162066272))
})

test_that("weibull", {
  library(ssdtools)
  set.seed(99)
  data <- data.frame(Conc = ssd_rweibull(1000, shape = 0.5, scale = 2))
  fit <- ssd_fit_dists(data, dists = c("weibull", "lgumbel"))
  tidy <- tidy(fit)
  tidy
  expect_snapshot_data(tidy, "tidy")
})

