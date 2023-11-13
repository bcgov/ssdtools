#    Copyright 2023 Australian Government Department of 
#    Climate Change, Energy, the Environment and Water
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

test_that("gamma parameters are extremely unstable", {
  data <- ssddata::ccme_boron
  data$Other <- data$Conc
  data$Conc <- data$Conc / max(data$Conc)
  
  # gamma shape change from 913 to 868 on most recent version
  set.seed(102)
  fits <- ssd_fit_dists(data, dists = c("lnorm", "gamma"), right = "Other", rescale = FALSE, computable = FALSE)
  
  tidy <- tidy(fits)
  expect_s3_class(tidy, "tbl")
  testthat::skip_on_ci() # not sure why gamma shape is 908 on GitHub actions windows and 841 on GitHub actions ubuntu
  testthat::skip_on_cran()
  expect_snapshot_data(tidy, "tidy_gamma_unstable", digits = 1)
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

test_that("ssd_hc cis with error", {
  skip_on_ci()
  skip_on_cran()
  
  set.seed(99)
  conc <- ssd_rlnorm_lnorm(30, meanlog1 = 0, meanlog2 = 1, sdlog1 = 1 / 10, sdlog2 = 1 / 10, pmix = 0.2)
  data <- data.frame(Conc = conc)
  fit <- ssd_fit_dists(data, dists = "lnorm_lnorm", min_pmix = 0.1)
  expect_identical(attr(fit, "min_pmix"), 0.1)
  expect_warning(hc_err <- ssd_hc(fit, ci = TRUE, nboot = 100))
  expect_s3_class(hc_err, "tbl")
  expect_snapshot_boot_data(hc_err, "hc_err_na")
  hc_err <- ssd_hc(fit, ci = TRUE, nboot = 100, min_pboot = 0.92)
  expect_s3_class(hc_err, "tbl")
  expect_snapshot_boot_data(hc_err, "hc_err")
})

test_that("ssd_hc comparable parametric and non-parametric big sample size", {
  skip_on_ci()
  skip_on_cran()
  
  set.seed(99)
  data <- data.frame(Conc = ssd_rlnorm(10000, 2, 1))
  fit <- ssd_fit_dists(data, dists = "lnorm")
  set.seed(10)
  hc_para <- ssd_hc(fit, ci = TRUE, nboot = 10)
  expect_snapshot_data(hc_para, "hc_para")
  set.seed(10)
  hc_nonpara <- ssd_hc(fit, ci = TRUE, nboot = 10, parametric = FALSE)
  expect_snapshot_boot_data(hc_nonpara, "hc_nonpara")
})

test_that("ssd_hp cis with error", {
  skip_on_ci()
  skip_on_cran()
  
  set.seed(99)
  conc <- ssd_rlnorm_lnorm(30, meanlog1 = 0, meanlog2 = 1, sdlog1 = 1 / 10, sdlog2 = 1 / 10, pmix = 0.2)
  data <- data.frame(Conc = conc)
  fit <- ssd_fit_dists(data, dists = "lnorm_lnorm", min_pmix = 0.1)
  expect_identical(attr(fit, "min_pmix"), 0.1)
  expect_warning(hp_err <- ssd_hp(fit, conc = 1, ci = TRUE, nboot = 100))
  expect_s3_class(hp_err, "tbl")
  expect_snapshot_boot_data(hp_err, "hp_err_na")
  hp_err <- ssd_hp(fit, conc = 1, ci = TRUE, nboot = 100, min_pboot = 0.92)
  expect_s3_class(hp_err, "tbl")
  expect_snapshot_boot_data(hp_err, "hp_err")
})

test_that("ssd_hp comparable parametric and non-parametric big sample size", {
  skip_on_ci()
  skip_on_cran()
  
  set.seed(99)
  data <- data.frame(Conc = ssd_rlnorm(10000, 2, 1))
  fit <- ssd_fit_dists(data, dists = "lnorm")
  set.seed(10)
  hp_para <- ssd_hp(fit, 1, ci = TRUE, nboot = 10)
  expect_snapshot_boot_data(hp_para, "hp_para")
  set.seed(10)
  hp_nonpara <- ssd_hp(fit, 1, ci = TRUE, nboot = 10, parametric = FALSE)
  expect_snapshot_boot_data(hp_nonpara, "hp_nonpara")
})
