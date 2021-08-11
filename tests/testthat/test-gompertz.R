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

test_that("gompertz", {
  test_dist("gompertz")
  expect_equal(ssd_pgompertz(1), 0.820625921265983)
  expect_equal(ssd_qgompertz(0.75), 0.869741686191944)
  set.seed(42)
  expect_equal(ssd_rgompertz(2), c(1.24208466660006, 1.32596518320944))
})

test_that("bootstrap gompertz with problem data", {
  data <- data.frame(Conc = c(0.12, 1.8, 0.26, 0.5, 0.35, 1.7, 4.3, 3.2))
  fit <- ssdtools::ssd_fit_dists(data, dists = 'gompertz')
  set.seed(99)
  hc <- ssd_hc(fit, ci = TRUE, nboot = 11, min_pboot = 0.9)
  expect_snapshot_data(hc, "hc_prob")
})

test_that("sgompertz completely unstable!", {
  x <- c(3.15284072848962, 1.77947821504531, 0.507778085984185, 1.650387414067, 
         1.00725113964435, 7.04244885481452, 1.32336941144339, 1.51533791792454
  )
  data <- data.frame(left = x, right = x, weight = 1)
  set.seed(94)
  expect_equal(ssdtools:::sgompertz(data),
  list(log_location = -0.809751972284548, log_shape = -301.126320260922))
  set.seed(99)
  expect_equal(ssdtools:::sgompertz(data),
               list(log_location = -0.96528645818605, log_shape = -2.6047441710778))
  set.seed(100)
  expect_error(ssdtools:::sgompertz(data))
})
