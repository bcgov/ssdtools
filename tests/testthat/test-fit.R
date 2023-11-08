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

test_that("ssd_fit_dists gives error with unrecognized dist", {
  chk::expect_chk_error(ssd_fit_dists(ssddata::ccme_boron, dists = "lnorm2"))
})

test_that("ssd_fit_dists gives chk error if insufficient data", {
  data <- ssddata::ccme_boron[1:5, ]
  chk::expect_chk_error(ssd_fit_dists(data))
})

test_that("ssd_fit_dists gives chk error if less than 6 rows of data", {
  data <- ssddata::ccme_boron[1:5, ]
  chk::expect_chk_error(ssd_fit_dists(data))
})

test_that("ssd_fit_dists gives chk error if less than required rows of data", {
  data <- ssddata::ccme_boron
  chk::expect_chk_error(ssd_fit_dists(data, nrow = 29))
})

test_that("ssd_fit_dists gives chk error if missing left column", {
  data <- ssddata::ccme_boron
  chk::expect_chk_error(ssd_fit_dists(data, left = "Conc2"))
})

test_that("ssd_fit_dists gives chk error if missing right column", {
  data <- ssddata::ccme_boron
  chk::expect_chk_error(ssd_fit_dists(data, right = "Conc2"))
})

test_that("ssd_fit_dists gives chk error if missing weight column", {
  data <- ssddata::ccme_boron
  chk::expect_chk_error(ssd_fit_dists(data, weight = "Conc2"))
})

test_that("ssd_fit_dists gives chk error if right call left", {
  data <- ssddata::ccme_boron
  data$left <- data$Conc
  chk::expect_chk_error(ssd_fit_dists(data, right = "left"))
})

test_that("ssd_fit_dists gives chk error if left called right", {
  data <- ssddata::ccme_boron
  data$right <- data$Conc
  chk::expect_chk_error(ssd_fit_dists(data, left = "right"))
})

test_that("ssd_fit_dists not happy with left as left by default", {
  data <- ssddata::ccme_boron
  data$left <- data$Conc
  chk::expect_chk_error(ssd_fit_dists(data, left = "left"))
})

test_that("ssd_fit_dists returns object class fitdists", {
  fit <- ssd_fit_dists(ssddata::ccme_boron,
    dists = c("lnorm", "llogis"),
    rescale = FALSE
  )
  expect_s3_class(fit, "fitdists")
})

test_that("ssd_fit_dists happy with left as left but happy if right other", {
  data <- ssddata::ccme_boron
  data$left <- data$Conc
  data$right <- data$Conc
  expect_s3_class(ssd_fit_dists(data, left = "left", right = "right"), "fitdists")
})

test_that("ssd_fit_dists not affected if all weight 1", {
  data <- ssddata::ccme_boron
  fits <- ssd_fit_dists(data, dists = "lnorm")
  data$Mass <- rep(1, nrow(data))
  fits_right <- ssd_fit_dists(data, weight = "Mass", dists = "lnorm")
  expect_equal(estimates(fits_right), estimates(fits))
})

test_that("ssd_fit_dists not affected if all equal weight ", {
  data <- ssddata::ccme_boron
  fits <- ssd_fit_dists(data, dists = "lnorm")
  data$Mass <- rep(0.1, nrow(data))
  fits_right <- ssd_fit_dists(data, weight = "Mass", dists = "lnorm")
  expect_equal(estimates(fits_right), estimates(fits))
})

test_that("ssd_fit_dists gives correct chk error if zero weight", {
  data <- ssddata::ccme_boron
  data$Heavy <- rep(1, nrow(data))
  data$Heavy[2] <- 0
  chk::expect_chk_error(
    ssd_fit_dists(data, weight = "Heavy"),
    "^`data` has 1 row with zero weight in 'Heavy'\\.$"
  )
})

test_that("ssd_fit_dists gives chk error if negative weights", {
  data <- ssddata::ccme_boron
  data$Mass <- rep(1, nrow(data))
  data$Mass[1] <- -1
  chk::expect_chk_error(ssd_fit_dists(data, weight = "Mass"))
})

test_that("ssd_fit_dists gives chk error if missing weight values", {
  data <- ssddata::ccme_boron
  data$Mass <- rep(1, nrow(data))
  data$Mass[1] <- NA
  chk::expect_chk_error(ssd_fit_dists(data, weight = "Mass"))
})

test_that("ssd_fit_dists gives chk error if missing left values", {
  data <- ssddata::ccme_boron
  data$Conc[1] <- NA
  chk::expect_chk_error(
    ssd_fit_dists(data),
    "^`data` has 1 row with effectively missing values in 'Conc'\\.$"
  )
})

test_that("ssd_fit_dists gives chk error if 0 left values", {
  data <- ssddata::ccme_boron
  data$Conc[1] <- 0
  chk::expect_chk_error(
    ssd_fit_dists(data),
    "^`data` has 1 row with effectively missing values in 'Conc'\\.$"
  )
})

test_that("ssd_fit_dists all distributions fail to fit if Inf weight", {
  data <- ssddata::ccme_boron
  data$Mass <- rep(1, nrow(data))
  data$Mass[1] <- Inf
  expect_error(
    expect_warning(
      ssd_fit_dists(data, weight = "Mass", dists = "lnorm"),
      "^Distribution 'lnorm' failed to fit"
    ),
    "^All distributions failed to fit\\."
  )
})

test_that("ssd_fit_dists not affected if right values identical to left but in different column", {
  data <- ssddata::ccme_boron
  fits <- ssd_fit_dists(data, dists = "lnorm")
  data$Other <- data$Conc
  fits_right <- ssd_fit_dists(data, right = "Other", dists = "lnorm")
  expect_equal(estimates(fits_right), estimates(fits))
})

test_that("ssd_fit_dists gives correct chk error if missing values in non-censored data", {
  data <- ssddata::ccme_boron
  data$Conc[2] <- NA
  chk::expect_chk_error(
    ssd_fit_dists(data),
    "^`data` has 1 row with effectively missing values in 'Conc'\\.$"
  )
})

test_that("ssd_fit_dists gives correct chk error if missing values in censored data", {
  data <- ssddata::ccme_boron
  data$Other <- data$Conc
  data$Other[1] <- data$Conc[1] + 0.1 # to make censored
  data$Conc[2:3] <- NA
  data$Other[2:3] <- NA
  chk::expect_chk_error(
    ssd_fit_dists(data, right = "Other"),
    "^`data` has 2 rows with effectively missing values in 'Conc' and 'Other'\\.$"
  )
})

test_that("ssd_fit_dists gives chk error if negative left ", {
  data <- ssddata::ccme_boron
  data$Conc[1] <- -1
  chk::expect_chk_error(ssd_fit_dists(data))
})

test_that("ssd_fit_dists all distributions fail to fit if Inf left", {
  data <- ssddata::ccme_boron
  data$Conc[1] <- Inf
  expect_error(
    ssd_fit_dists(data, dists = "lnorm"),
    "^`data` has 1 row with effectively missing values in 'Conc'\\."
  )
})

test_that("ssd_fit_dists gives correct chk error any right < left", {
  data <- ssddata::ccme_boron
  data$Other <- data$Conc
  data$Other[2] <- data$Conc[1] / 2
  chk::expect_chk_error(
    ssd_fit_dists(data, right = "Other"),
    "^`data\\$Other` must have values greater than or equal to `data\\$Conc`\\.$"
  )
})

test_that("ssd_fit_dists warns to rescale data", {
  data <- data.frame(Conc = rep(2, 6))
  expect_error(
    expect_warning(
      ssd_fit_dists(data, dist = "lnorm", , rescale = FALSE),
      "^Distribution 'lnorm' failed to fit \\(try rescaling data\\):"
    )
  )
})

test_that("ssd_fit_dists doesn't warns to rescale data if already rescaled", {
  data <- data.frame(Conc = rep(2, 6))
  expect_error(expect_warning(ssd_fit_dists(data, rescale = TRUE, dist = "lnorm"),
    regexp = "^Distribution 'lnorm' failed to fit:"
  ))
})

test_that("ssd_fit_dists warns of optimizer convergence code error", {
  data <- ssddata::ccme_boron
  expect_error(
    expect_warning(ssd_fit_dists(data, control = list(maxit = 1), dist = "lnorm"),
      regexp = "^Distribution 'lnorm' failed to converge \\(try rescaling data\\): Iteration limit maxit reach \\(try increasing the maximum number of iterations in control\\)\\.$"
    )
  )
})

test_that("ssd_fit_dists estimates for ssddata::ccme_boron on bcanz dists", {
  fits <- ssd_fit_dists(ssddata::ccme_boron, rescale = TRUE)

  tidy <- tidy(fits)
  expect_s3_class(tidy, "tbl")
  expect_snapshot_data(tidy, "tidy_stable_rescale")
})

test_that("ssd_fit_dists not reorder", {
  fit <- ssd_fit_dists(ssddata::ccme_boron,
    dists = c("lnorm", "llogis"),
    rescale = FALSE
  )

  expect_identical(npars(fit), c(lnorm = 2L, llogis = 2L))
  expect_equal(logLik(fit), c(lnorm = -117.514216489547, llogis = -118.507435324581))
})

test_that("ssd_fit_dists equal weights no effect", {
  fits <- ssd_fit_dists(ssddata::ccme_boron)
  data <- ssddata::ccme_boron
  data$weight <- rep(2, nrow(data))
  fits_weight <- ssd_fit_dists(data)

  expect_equal(estimates(fits_weight), estimates(fits))
})

test_that("ssd_fit_dists computable = TRUE allows for fits without standard errors", {
  data <- ssddata::ccme_boron
  data$Other <- data$Conc
  data$Conc <- data$Conc / max(data$Conc)

  expect_warning(
    expect_warning(
      ssd_fit_dists(data, right = "Other", rescale = FALSE),
      "^Distribution 'lnorm_lnorm' failed to compute standard errors \\(try rescaling data\\)\\.$"
    ),
    "^Distribution 'lgumbel' failed to compute standard errors \\(try rescaling data\\)\\.$"
  )

  set.seed(102)
  fits <- ssd_fit_dists(data, right = "Other", dists = c("lgumbel", "llogis", "lnorm", "lnorm_lnorm"), rescale = FALSE, computable = FALSE)

  tidy <- tidy(fits)
  expect_s3_class(tidy, "tbl")
  expect_snapshot_data(tidy, "tidy_stable_computable", digits = 3)
})

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

test_that("ssd_fit_dists works with slightly censored data", {
  data <- ssddata::ccme_boron

  data$right <- data$Conc * 2
  data$Conc <- data$Conc * 0.5

  fits <- ssd_fit_dists(data, dists = "lnorm", right = "right", rescale = FALSE)

  tidy <- tidy(fits)

  expect_equal(tidy$est, c(2.56052524750529, 1.17234562953404))
  expect_equal(tidy$se, c(0.234063281091344, 0.175423555900586))
})

test_that("ssd_fit_dists accepts 0 for left censored data", {
  data <- ssddata::ccme_boron

  data$right <- data$Conc
  data$Conc[1] <- 0

  fits <- ssd_fit_dists(data, dists = "lnorm", right = "right", rescale = FALSE)

  tidy <- tidy(fits)

  expect_equal(tidy$est, c(2.54093502870563, 1.27968456496323))
  expect_equal(tidy$se, c(0.242558677928804, 0.175719927258761))
})

test_that("ssd_fit_dists gives same values with zero and missing left values", {
  data <- ssddata::ccme_boron

  data$right <- data$Conc
  data$Conc[1] <- 0

  fits0 <- ssd_fit_dists(data, dists = "lnorm", right = "right")

  data$Conc[1] <- NA

  fitsna <- ssd_fit_dists(data, dists = "lnorm", right = "right")

  expect_equal(tidy(fits0), tidy(fitsna))
})

test_that("ssd_fit_dists works with right censored data", {
  data <- ssddata::ccme_boron

  data$right <- data$Conc
  data$right[1] <- Inf

  expect_error(
    fits <- ssd_fit_dists(data, dists = "lnorm", right = "right"),
    "^Distributions cannot currently be fitted to right censored data\\.$"
  )

  #
  # tidy <- tidy(fits)
  #
  # expect_equal(tidy$est, c(2.54093502870563, 1.27968456496323))
  # expect_equal(tidy$se, c(0.242558677928804, 0.175719927258761))
})

test_that("ssd_fit_dists gives same answer for missing versus Inf right", {
  data <- ssddata::ccme_boron

  data$right <- data$Conc
  data$right[1] <- Inf

  expect_error(
    fits <- ssd_fit_dists(data, dists = "lnorm", right = "right"),
    "^Distributions cannot currently be fitted to right censored data\\.$"
  )

  data$right[1] <- NA

  expect_error(
    fits <- ssd_fit_dists(data, dists = "lnorm", right = "right"),
    "^Distributions cannot currently be fitted to right censored data\\.$"
  )

  # fits0 <- ssd_fit_dists(data, dists = "lnorm", right = "right")
  #
  # data$right[1] <- NA
  #
  # fitsna <- ssd_fit_dists(data, dists = "lnorm", right = "right")
  #
  # expect_equal(tidy(fits0), tidy(fitsna))
})

test_that("ssd_fit_dists min_pmix", {
  set.seed(99)
  conc <- ssd_rlnorm_lnorm(1000, meanlog1 = 0, meanlog2 = 1, sdlog1 = 1 / 10, sdlog2 = 1 / 10, pmix = 0.1)
  data <- data.frame(Conc = conc)
  fits <- ssd_fit_dists(data, dists = c("lnorm_lnorm", "llogis_llogis"), min_pmix = 0.1)
  tidy <- tidy(fits)
  expect_error(
    expect_warning(expect_warning(ssd_fit_dists(data, dists = c("lnorm_lnorm", "llogis_llogis"), min_pmix = 0.11))),
    "All distributions failed to fit."
  )
  testthat::skip_on_os("windows")
  testthat::skip_on_os("linux")
  testthat::skip_on_os("solaris")
  expect_snapshot_data(tidy, "min_pmix5")
})

test_that("ssd_fit_dists min_pmix", {
  set.seed(99)
  conc <- ssd_rlnorm_lnorm(1000, meanlog1 = 0, meanlog2 = 1, sdlog1 = 1 / 10, sdlog2 = 1 / 10, pmix = 0.1)
  data <- data.frame(Conc = conc)
  fits <- ssd_fit_dists(data, dists = c("lnorm_lnorm"), min_pmix = 0.11, at_boundary_ok = TRUE)
  tidy <- tidy(fits)
  expect_equal(tidy$est[tidy$term == "pmix"], 0.11)
})

test_that("ssd_fit_dists at_boundary_ok message", {
  set.seed(99)
  expect_warning(
    ssd_fit_dists(ssddata::ccme_boron, dists = c("lnorm", "burrIII3")),
    "one or more parameters at boundary[.]$"
  )
  expect_warning(
    ssd_fit_dists(ssddata::ccme_boron,
      dists = c("lnorm", "burrIII3"),
      at_boundary_ok = TRUE
    ),
    "failed to compute standard errors \\(try rescaling data\\)\\.$"
  )
})

test_that("ssd_fit_dists bcanz with anon_e", {
  fit <- ssd_fit_dists(ssddata::anon_e)
  tidy <- tidy(fit)
  expect_snapshot_data(tidy, "tidy_stable_anon_e")
})

test_that("ssd_fit_dists unstable with anon_e", {
  expect_warning(expect_warning(
    fit <- ssd_fit_dists(ssddata::anon_e, dists = ssd_dists(bcanz = FALSE)),
    "burrIII3"
  ), "gompertz")
  tidy <- tidy(fit)
  expect_snapshot_data(tidy, "tidy_unstable_anon_e")
})

test_that("ssd_fit_dists works min_pmix = 0.5 and at_boundary_ok = TRUE and computable = FALSE", {
  fit <- ssd_fit_dists(ssddata::ccme_boron,
    dists = c("lnorm", "lnorm_lnorm"), min_pmix = 0.5,
    at_boundary_ok = TRUE, computable = FALSE
  )
  tidy <- tidy(fit)
  expect_snapshot_data(tidy, "min_pmix_05")
})

test_that("ssd_fit_dists min_pmix 0", {
  set.seed(99)
  data <- data.frame(Conc = ssd_rlnorm_lnorm(100, meanlog1 = 0, meanlog2 = 2, pmix = 0.01))
  fit <- ssd_fit_dists(data, dists = c("lnorm_lnorm", "llogis_llogis"), min_pmix = 0)
  tidy <- tidy(fit)
  testthat::skip_on_os("windows")
  testthat::skip_on_os("linux")
  testthat::skip_on_os("solaris")
  expect_snapshot_data(tidy, "tidy_pmix0")
})
