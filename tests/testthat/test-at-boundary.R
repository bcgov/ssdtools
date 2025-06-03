# Copyright 2025 Australian Government Department of Climate Change,
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

test_that("test at boundary 2 9", {
  withr::with_seed(42, {
    data <- data.frame(Conc = c(0.02, 0.01, rlnorm(9, 1)))
    fit <- ssd_fit_dists(data = data)
  })
  expect_equal(unname(fit$lnorm_lnorm$optim$par["pmix"]), ssd_min_pmix(nrow(data)))
  gof <- ssd_gof(fit, wt = TRUE)
  expect_snapshot_data(gof, "b29")
  expect_identical(ssd_at_boundary(fit),
                   c(gamma = FALSE, lgumbel = FALSE, llogis = FALSE, lnorm = FALSE, 
                     lnorm_lnorm = TRUE, weibull = FALSE))
  expect_false(ssd_at_boundary(fit$lnorm))
  expect_true(ssd_at_boundary(fit$lnorm_lnorm))
})

test_that("test at boundary 2 14", {
  withr::with_seed(42, {
    data <- data.frame(Conc = c(0.01, 0.02, rlnorm(14, 1)))
    fit <- ssd_fit_dists(data = data)
  })
  expect_equal(unname(fit$lnorm_lnorm$optim$par["pmix"]), ssd_min_pmix(nrow(data)))
  gof <- ssd_gof(fit, wt = TRUE)
  expect_snapshot_data(gof, "b214")
  expect_identical(ssd_at_boundary(fit),
                   c(gamma = FALSE, lgumbel = FALSE, llogis = FALSE, lnorm = FALSE, 
                     lnorm_lnorm = TRUE, weibull = FALSE))
  expect_false(ssd_at_boundary(fit$lnorm))
  expect_true(ssd_at_boundary(fit$lnorm_lnorm))
})

test_that("test at boundary 2 23", {
  withr::with_seed(42, {
    data <- data.frame(Conc = c(0.01, 0.012, rlnorm(23, 1)))
    fit <- ssd_fit_dists(data = data)
  })
  expect_equal(unname(fit$lnorm_lnorm$optim$par["pmix"]),
               0.211770893307891)
  gof <- ssd_gof(fit, wt = TRUE)
  expect_snapshot_data(gof, "b223")
  expect_identical(ssd_at_boundary(fit),
                   c(gamma = FALSE, lgumbel = FALSE, llogis = FALSE, lnorm = FALSE, 
                     lnorm_lnorm = FALSE, weibull = FALSE))
  expect_false(ssd_at_boundary(fit$lnorm))
  expect_false(ssd_at_boundary(fit$lnorm_lnorm))
})

test_that("test at_boundary fits2.3", {
  fits <- ssdtools:::fits2.3
  expect_identical(ssd_at_boundary(fits),
                   c(gamma = NA, lgumbel = NA, llogis = NA, lnorm = NA, 
                     lnorm_lnorm = NA, weibull = NA))
  expect_identical(ssd_at_boundary(fits$lnorm), NA)
  expect_identical(ssd_at_boundary(fits$lnorm_lnorm), NA)
})
