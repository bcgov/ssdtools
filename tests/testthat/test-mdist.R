# Copyright 2015-2023 Province of British Columbia
# Copyright 2021 Environment and Climate Change Canada
# Copyright 2023-2024 Australian Government Department of Climate Change,
# Energy, the Environment and Water
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

test_that("mdist returns empty list when no package map exists", {
  expect_identical(ssdtools:::mdist("lnorm"), list())
})

test_that("mdist finds package map functions in the ssdtools namespace", {
  expect_identical(
    ssdtools:::mdist("invpareto"),
    list(log_scale = factor(NA))
  )
})

test_that("mdist ignores conflicting m* functions on the search path (#479)", {
  # Simulate actuar::mlnorm(order, ...) without requiring actuar.
  assign(
    "mlnorm",
    function(order, meanlog = 0, sdlog = 1) {
      stop("search-path mlnorm should not be called", call. = FALSE)
    },
    envir = .GlobalEnv
  )
  withr::defer(rm("mlnorm", envir = .GlobalEnv))

  expect_identical(ssdtools:::mdist("lnorm"), list())
  expect_no_error(
    ssd_fit_dists(ssddata::ccme_boron, dists = c("lnorm", "gamma"))
  )
})

test_that("ssd_fit_dists works with actuar attached (#479)", {
  skip_if_not_installed("actuar")
  withr::local_package("actuar")

  expect_no_error(
    fit <- ssd_fit_dists(
      ssddata::ccme_boron,
      dists = c("lnorm", "llogis", "gamma", "weibull")
    )
  )
  expect_s3_class(fit, "fitdists")
  expect_identical(names(fit), c("lnorm", "llogis", "gamma", "weibull"))
})

test_that("ssd_fit_dists censored data works with actuar attached (#479)", {
  skip_if_not_installed("actuar")
  withr::local_package("actuar")

  data <- data.frame(
    left = c(1, 2, 3, 4, 5, 6),
    right = c(1, 2, Inf, 4, Inf, 6)
  )
  expect_no_error(
    fit <- ssd_fit_dists(data, left = "left", right = "right", dists = "lnorm")
  )
  expect_s3_class(fit, "fitdists")
})
