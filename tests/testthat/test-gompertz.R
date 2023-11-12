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

test_that("gompertz", {
  test_dist("gompertz")
  expect_equal(ssd_pgompertz(1), 0.820625921265983)
  expect_equal(ssd_qgompertz(0.75), 0.869741686191944)
  set.seed(42)
  expect_equal(ssd_rgompertz(2), c(1.24208466660006, 1.32596518320944))
})

test_that("bootstrap gompertz with problem data", {
  set.seed(99)
  data <- data.frame(Conc = ssd_rgompertz(6, location = 0.6, shape = 0.07))
  fit <- ssdtools::ssd_fit_dists(data, dists = "gompertz")
  set.seed(99)
  hc <- ssd_hc(fit, ci = TRUE, nboot = 100, min_pboot = 0.8)
  testthat::skip_on_os("windows")
  testthat::skip_on_os("linux")
  testthat::skip_on_os("solaris")
  expect_snapshot_data(hc, "hc_prob")
})

test_that("sgompertz completely unstable!", {
  skip_on_ci() # as incredibly unstable
  skip_on_cran()
  x <- c(
    3.15284072848962, 1.77947821504531, 0.507778085984185, 1.650387414067,
    1.00725113964435, 7.04244885481452, 1.32336941144339, 1.51533791792454
  )
  data <- data.frame(left = x, right = x, weight = 1)
  set.seed(94)
  expect_equal(ssdtools:::sgompertz(data),
    list(log_location = -0.8097519, log_shape = -301.126),
    tolerance = 1e-06
  )
  set.seed(99)
  expect_equal(
    ssdtools:::sgompertz(data),
    list(log_location = -0.96528645818605, log_shape = -2.6047441710778)
  )
  set.seed(100)
  expect_error(ssdtools:::sgompertz(data))
})

test_that("sgompertz with initial values still unstable!", {
  skip_on_ci() # as incredibly unstable
  skip_on_cran()
  x <- c(
    3.15284072848962, 1.77947821504531, 0.507778085984185, 1.650387414067,
    1.00725113964435, 7.04244885481452, 1.32336941144339, 1.51533791792454
  )
  data <- data.frame(Conc = x)
  set.seed(11)
  expect_error(expect_warning(
    fit <- ssd_fit_dists(data, dists = "gompertz"),
    "Some elements in the working weights variable 'wz' are not finite"
  ))
  set.seed(21)
  expect_error(expect_warning(
    fit <- ssd_fit_dists(data, dists = "gompertz"),
    "L-BFGS-B needs finite values of 'fn'"
  ))
  set.seed(10)
  fit <- ssd_fit_dists(data, dists = "gompertz")

  sdata <- data.frame(left = x, right = x, weight = 1)
  pars <- estimates(fit$gompertz)

  set.seed(94)
  expect_equal(ssdtools:::sgompertz(sdata),
    list(log_location = -0.809751972284548, log_shape = -301.126),
    tolerance = 1e-06
  )
  set.seed(94)
  expect_equal(
    ssdtools:::sgompertz(sdata, pars),
    list(log_location = 4.06999915669631, log_shape = -2936.08880499417)
  )
  set.seed(99)
  expect_equal(
    ssdtools:::sgompertz(sdata),
    list(log_location = -0.96528645818605, log_shape = -2.6047441710778)
  )
  set.seed(99)
  expect_equal(
    ssdtools:::sgompertz(sdata, pars),
    list(log_location = 3.42665325399873, log_shape = -102.775579919568)
  )
  set.seed(100)
  expect_error(ssdtools:::sgompertz(sdata))
  set.seed(100)
  expect_equal(
    ssdtools:::sgompertz(sdata, pars),
    list(log_location = 3.80715953030506, log_shape = -658.432910074053)
  )
})
