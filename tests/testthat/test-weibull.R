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

test_that("weibull", {
  expect_equal(ssd_pweibull(1), 0.632120558828558)
  expect_equal(ssd_qweibull(0.75), 1.38629436111989)
  set.seed(42)
  expect_equal(ssd_rweibull(2), c(0.0890432104972705, 0.0649915162066272))
  test_dist("weibull")
})

test_that("weibull", {
  set.seed(99)
  data <- data.frame(Conc = ssd_rweibull(1000, shape = 0.5, scale = 2))
  fit <- ssd_fit_dists(data, dists = c("weibull", "lgumbel"))
  tidy <- tidy(fit)
  expect_snapshot_data(tidy, "tidy")
})

test_that("weibull works anona", {
  set.seed(99)
  fit <- ssd_fit_dists(ssddata::anon_a, dists = c("weibull", "lgumbel"))
  tidy <- tidy(fit)
  expect_snapshot_data(tidy, "tidy_anona")
})

test_that("weibull bootstraps anona", {
  set.seed(99)
  fit <- ssd_fit_dists(ssddata::anon_a, dists = "weibull")
  hc <- ssd_hc(fit, nboot = 1000, ci = TRUE, multi = FALSE)
  expect_snapshot_data(hc, "hc_anona")
})

test_that("weibull with challenging data", {
  data <- data.frame(Conc = c(868.24508,
    1713.82388,
    3161.70678,
    454.65412,
    3971.75890,
    37.69471,
    262.14053,
    363.20288,
    1940.43277,
    3218.05296,
    77.48251,
    1214.70521,
    1329.27005,
    1108.05761,
    339.91458,
    437.52104))
  
  fits <- ssd_fit_dists(data=data,
                left = 'Conc', dists = c('gamma', 'weibull'),
                silent = TRUE, reweight = FALSE, min_pmix = 0, nrow = 6L,
                computable = TRUE, at_boundary_ok = FALSE, rescale = FALSE)
  
  expect_identical(names(fits), c('gamma', 'weibull'))
})
