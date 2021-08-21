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

test_that("invpareto", {
  test_dist("invpareto", upadj = 1e-03)
  expect_equal(ssd_pinvpareto(0.5), 0.125)
  expect_equal(ssd_qinvpareto(0.125), 0.5)
  set.seed(42)
  expect_equal(ssd_rinvpareto(2), c(0.970755086941947, 0.978569136804486))
})

test_that("invpareto fits with anon_a", {
  fit <- ssd_fit_dists(ssddata::anon_a, dists = "invpareto")
  expect_s3_class(fit, "fitdists")
  tidy <- tidy(fit)
  expect_snapshot_data(tidy, "anon_a")
})

test_that("invpareto gives cis with ccme_boron", {
  fit <- ssd_fit_dists(ssddata::ccme_boron, dists = "invpareto")
  expect_s3_class(fit, "fitdists")
  set.seed(99)
  hc <- ssd_hc(fit, nboot = 100, ci = TRUE)
  expect_snapshot_data(hc, "hc_boron")
})

test_that("invpareto initial shape is MLEs", {
  set.seed(99)
  data <- data.frame(Conc = ssd_rinvpareto(6), weight = 1)
  data$left <- data$Conc
  data$right <- data$left
  initial <- ssdtools:::sinvpareto(data)
  expect_equal(lapply(initial, exp), list(log_scale = 1.03299515712949, log_shape = 4.14668077241))
  fit <- ssd_fit_dists(data, dists = "invpareto")
  expect_equal(estimates(fit), 
               list(invpareto = list(scale = 1.03299515712949, shape = 4.14668077241)))
})

test_that("invpareto unbiased scale estimator small n", {
  set.seed(99)
  fun <- function(n) {
    exp(ssdtools:::sinvpareto(data.frame(right = ssd_rinvpareto(n)))$log_scale)
  }
  expect_equal(mean(vapply(rep(6, 1000), fun, 1)), 0.992849622620409)
})

test_that("invpareto biased shape estimator small n", {
  set.seed(99)
  fun <- function(n) {
    exp(ssdtools:::sinvpareto(data.frame(right = ssd_rinvpareto(n)))$log_shape)
  }
  expect_equal(mean(vapply(rep(6, 1000), fun, 1)), 3.8284232651135)
})

test_that("invpareto unbiased scale estimator large n", {
  set.seed(99)
  fun <- function(n) {
    exp(ssdtools:::sinvpareto(data.frame(right = ssd_rinvpareto(n)))$log_scale)
  }
  expect_equal(mean(vapply(rep(1000, 1000), fun, 1)), 1.00001036453276)
})

test_that("invpareto unbiased shape estimator large n", {
  set.seed(99)
  fun <- function(n) {
    exp(ssdtools:::sinvpareto(data.frame(right = ssd_rinvpareto(n)))$log_shape)
  }
  expect_equal(mean(vapply(rep(1000, 1000), fun, 1)), 3.00215185407015)
})
