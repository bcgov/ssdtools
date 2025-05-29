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

test_that("hp", {
  fits <- ssd_fit_dists(ssddata::ccme_boron)
  
  withr::with_seed(102, {
    hp <- ssd_hp(fits, conc = 1, ci = TRUE, nboot = 10, average = FALSE)
  })
  expect_s3_class(hp, "tbl")
  expect_snapshot_data(hp, "hp")
})

test_that("hp fitdists works with zero length conc", {
  fits <- ssd_fit_dists(ssddata::ccme_boron, dists = "lnorm")
  
  hp <- ssd_hp(fits, numeric(0))
  expect_s3_class(hp, "tbl_df")
  expect_identical(colnames(hp), c("dist", "conc", "est", "se", "lcl", "ucl", "wt", "est_method", "ci_method", "method", "nboot", "pboot", "samples"))
  expect_equal(hp$dist, character(0))
  expect_identical(hp$conc, numeric(0))
  expect_equal(hp$est, numeric(0))
  expect_equal(hp$se, numeric(0))
  expect_equal(hp$wt, numeric(0))
})

test_that("hp fitdist works with missing conc", {
  fits <- ssd_fit_dists(ssddata::ccme_boron, dists = "lnorm")
  
  hp <- ssd_hp(fits, NA_real_)
  expect_s3_class(hp, "tbl_df")
  expect_snapshot_data(hp, "hp41")
})

test_that("hp fitdist works with 0 conc", {
  fits <- ssd_fit_dists(ssddata::ccme_boron, dists = "lnorm")
  
  hp <- ssd_hp(fits, 0)
  expect_s3_class(hp, "tbl_df")
  expect_snapshot_data(hp, "hp49")
})

test_that("hp fitdist works with negative conc", {
  fits <- ssd_fit_dists(ssddata::ccme_boron, dists = "lnorm")
  
  hp <- ssd_hp(fits, -1)
  expect_s3_class(hp, "tbl_df")
  expect_snapshot_data(hp, "hp57")
})

test_that("hp fitdist works with -Inf conc", {
  fits <- ssd_fit_dists(ssddata::ccme_boron, dists = "lnorm")
  
  hp <- ssd_hp(fits, -Inf)
  expect_s3_class(hp, "tbl_df")
  expect_snapshot_data(hp, "hp65")
})

test_that("hp fitdist works with Inf conc", {
  fits <- ssd_fit_dists(ssddata::ccme_boron, dists = "lnorm")
  
  hp <- ssd_hp(fits, Inf)
  expect_s3_class(hp, "tbl_df")
  expect_snapshot_data(hp, "hp73")
})

test_that("hp fitdists works reasonable conc", {
  fits <- ssd_fit_dists(ssddata::ccme_boron, dists = "lnorm")
  
  hp <- ssd_hp(fits, 1)
  expect_s3_class(hp, "tbl_df")
  expect_snapshot_data(hp, "hp81")
})

test_that("hp fitdists works with multiple concs", {
  fits <- ssd_fit_dists(ssddata::ccme_boron, dists = "lnorm")
  
  hp <- ssd_hp(fits, c(2.5, 1), ci_method = "multi_fixed")
  expect_s3_class(hp, "tbl_df")
  expect_snapshot_data(hp, "hp89")
})

test_that("hp fitdists works with cis", {
  fits <- ssd_fit_dists(ssddata::ccme_boron, dists = "lnorm")
  
  withr::with_seed(10, {
    hp <- ssd_hp(fits, 1, ci = TRUE, nboot = 10, ci_method = "MACL", samples = TRUE)
  })
  expect_s3_class(hp, "tbl_df")
  expect_snapshot_data(hp, "hp98")
})

test_that("hp fitdists works with multiple dists", {
  fits <- ssd_fit_dists(ssddata::ccme_boron)
  
  hp <- ssd_hp(fits, 1)
  expect_s3_class(hp, "tbl_df")
  expect_snapshot_data(hp, "hp106")
})

test_that("hp fitdists works not average multiple dists", {
  fits <- ssd_fit_dists(ssddata::ccme_boron)
  
  hp <- ssd_hp(fits, 1, average = FALSE)
  expect_s3_class(hp, "tbl_df")
  expect_snapshot_data(hp, "hp114")
})

test_that("hp fitdists gives different answer with model averaging as hp not same for either", {
  data <- ssddata::aims_molybdenum_marine
  
  fits_lgumbel <- ssd_fit_dists(data, dists = "lgumbel")
  expect_equal(ssd_hp(fits_lgumbel, ssd_hc(fits_lgumbel, proportion = 5 / 100)$est)$est, 5)
  
  fits_lnorm_lnorm <- ssd_fit_dists(data, dists = "lnorm_lnorm")
  expect_equal(ssd_hp(fits_lnorm_lnorm, ssd_hc(fits_lnorm_lnorm, proportion = 5 / 100)$est)$est, 5)
  
  fits_both <- ssd_fit_dists(data, dists = c("lgumbel", "lnorm_lnorm"), min_pmix = 0)
  expect_equal(ssd_hp(fits_both, ssd_hc(fits_both, proportion = 5 / 100, ci_method = "MACL",est_method = "arithmetic")$est)$est, 4.59194131309822, tolerance = 1e-06)
})

test_that("ssd_hp fitdists averages", {
  fits <- ssd_fit_dists(ssddata::ccme_boron)
  hp <- ssd_hp(fits, ci_method = "MACL", est_method = "arithmetic")
  expect_s3_class(hp, "tbl_df")
  expect_snapshot_data(hp, "hp145")
})

test_that("ssd_hp fitdists geomean", {
  fits <- ssd_fit_dists(ssddata::ccme_boron)
  hp <- ssd_hp(fits, ci_method = "MACL", est_method = "geometric")
  expect_s3_class(hp, "tbl_df")
  expect_snapshot_data(hp, "hp145g")
})

test_that("ssd_hp fitdists correct for rescaling", {
  fits <- ssd_fit_dists(ssddata::ccme_boron)
  fits_rescale <- ssd_fit_dists(ssddata::ccme_boron, rescale = TRUE)
  hp <- ssd_hp(fits, 1)
  hp_rescale <- ssd_hp(fits_rescale, 1)
  expect_equal(hp_rescale, hp, tolerance = 1e-04)
})

test_that("hp fitdists with no fitdists", {
  x <- list()
  class(x) <- c("fitdists")
  hp <- ssd_hp(x, 1)
  expect_s3_class(hp, c("tbl_df", "tbl", "data.frame"))
  expect_snapshot_data(hp, "hp130")
})

test_that("ssd_hp doesn't calculate cis with inconsistent censoring", {
  data <- ssddata::ccme_boron
  data$Conc2 <- data$Conc
  data$Conc[1] <- 0.5
  data$Conc2[1] <- 1.0
  fits <- ssd_fit_dists(data, dists = c("lnorm", "llogis"))
  withr::with_seed(10, {
    hp <- ssd_hp(fits, 1, ci = TRUE, nboot = 10, ci_method = "MACL")
  })
  expect_equal(hp$se, 1.88668081916483, tolerance = 1e-6)
  
  fits <- ssd_fit_dists(data, right = "Conc2", dists = c("lnorm", "llogis"))
  withr::with_seed(10, {
    expect_warning(
      hp <- ssd_hp(fits, 1, ci = TRUE, nboot = 10),
      "^Parametric CIs cannot be calculated for censored data[.]$"
    )
  })
  expect_identical(hp$se, NA_real_)
})

test_that("ssd_hp same with equally weighted data", {
  data <- ssddata::ccme_boron
  data$Weight <- rep(1, nrow(data))
  fits <- ssd_fit_dists(data, weight = "Weight", dists = "lnorm")
  withr::with_seed(10, {
    hp <- ssd_hp(fits, 1, ci = TRUE, nboot = 10)
  })
  
  data$Weight <- rep(2, nrow(data))
  fits2 <- ssd_fit_dists(data, weight = "Weight", dists = "lnorm")
  withr::with_seed(10, {
    hp2 <- ssd_hp(fits2, 1, ci = TRUE, nboot = 10)
  })
  expect_equal(hp2, hp)
})

test_that("ssd_hp calculates cis with equally weighted data", {
  data <- ssddata::ccme_boron
  data$Weight <- rep(2, nrow(data))
  fits <- ssd_fit_dists(data, weight = "Weight", dists = "lnorm")
  withr::with_seed(10, {
    hp <- ssd_hp(fits, 1, ci = TRUE, nboot = 10, ci_method = "MACL")
  })
  expect_equal(hp$se, 1.4551513510538, tolerance = 1e-5)
})

test_that("ssd_hp calculates cis with two distributions", {
  data <- ssddata::ccme_boron
  fits <- ssd_fit_dists(data, dists = c("lnorm", "llogis"))
  withr::with_seed(10, {
    hp <- ssd_hp(fits, 1, ci = TRUE, nboot = 10, ci_method = "MACL")
  })
  expect_equal(hp$se, 1.4500084773305, tolerance = 1e-5)
})

test_that("ssd_hp calculates cis in parallel but one distribution", {
  local_multisession()
  data <- ssddata::ccme_boron
  fits <- ssd_fit_dists(data, dists = "lnorm")
  withr::with_seed(10, {
    hp <- ssd_hp(fits, 1, ci = TRUE, nboot = 10, ci_method = "MACL")
  })
  expect_equal(hp$se, 1.4551513510538, tolerance = 1e-5)
})

test_that("ssd_hp calculates cis in parallel with two distributions", {
  local_multisession()
  data <- ssddata::ccme_boron
  fits <- ssd_fit_dists(data, dists = c("lnorm", "llogis"))
  withr::with_seed(10, {
    hp <- ssd_hp(fits, 1, ci = TRUE, nboot = 10, ci_method = "MACL")
  })
  expect_equal(hp$se, 1.4500084773305, tolerance = 1e-5)
})

test_that("ssd_hp doesn't calculate cis with unequally weighted data", {
  data <- ssddata::ccme_boron
  data$Weight <- rep(1, nrow(data))
  data$Weight[1] <- 2
  fits <- ssd_fit_dists(data, weight = "Weight", dists = "lnorm")
  expect_warning(
    hp <- ssd_hp(fits, 1, ci = TRUE, nboot = 10),
    "^Parametric CIs cannot be calculated for unequally weighted data[.]$"
  )
  expect_identical(hp$se, NA_real_)
})

test_that("ssd_hp no effect with higher weight one distribution", {
  data <- ssddata::ccme_boron
  data$Weight <- rep(1, nrow(data))
  fits <- ssd_fit_dists(data, weight = "Weight", dists = "lnorm")
  data$Weight <- rep(10, nrow(data))
  fits_10 <- ssd_fit_dists(data, weight = "Weight", dists = "lnorm")
  withr::with_seed(10, {
    hp <- ssd_hp(fits, 3, ci = TRUE, nboot = 10)
  })
  withr::with_seed(10, {
    hp_10 <- ssd_hp(fits_10, 3, ci = TRUE, nboot = 10)
  })
  expect_equal(hp_10, hp)
})

test_that("ssd_hp effect with higher weight two distributions", {
  data <- ssddata::ccme_boron
  data$Weight <- rep(1, nrow(data))
  fits <- ssd_fit_dists(data, weight = "Weight", dists = c("lnorm", "llogis"))
  data$Weight <- rep(10, nrow(data))
  fits_10 <- ssd_fit_dists(data, weight = "Weight", dists = c("lnorm", "llogis"))
  withr::with_seed(10, {
    hp <- ssd_hp(fits, 3, ci = TRUE, nboot = 10, ci_method = "MACL")
  })
  withr::with_seed(10, {
    hp_10 <- ssd_hp(fits_10, 3, ci = TRUE, nboot = 10, ci_method = "MACL")
  })
  expect_equal(hp$est, 11.753562486648, tolerance = 1e-5)
  expect_equal(hp_10$est, 11.931807182972, tolerance = 1e-5)
  expect_equal(hp$se, 4.5637225910467, tolerance = 1e-5)
  expect_equal(hp_10$se, 4.83426079388412, tolerance = 1e-5)
})

test_that("ssd_hp cis with non-convergence", {
  withr::with_seed(99, {
    conc <- ssd_rlnorm_lnorm(100, meanlog1 = 0, meanlog2 = 1, sdlog1 = 1 / 10, sdlog2 = 1 / 10, pmix = 0.2)
    data <- data.frame(Conc = conc)
    fit <- ssd_fit_dists(data, dists = "lnorm_lnorm", min_pmix = 0.15)
    expect_identical(attr(fit, "min_pmix"), 0.15)
    hp15 <- ssd_hp(fit, conc = 1, ci = TRUE, nboot = 100, min_pboot = 0.9)
    attr(fit, "min_pmix") <- 0.3
    expect_identical(attr(fit, "min_pmix"), 0.3)
    hp30 <- ssd_hp(fit, conc = 1, ci = TRUE, nboot = 100, min_pboot = 0.9, ci_method = "MACL", samples = TRUE)
  })
  expect_s3_class(hp30, "tbl")
  expect_snapshot_data(hp30, "hp_30")
})

test_that("ssd_hp cis with error and multiple dists", {
  withr::with_seed(99, {
    conc <- ssd_rlnorm_lnorm(30, meanlog1 = 0, meanlog2 = 1, sdlog1 = 1 / 10, sdlog2 = 1 / 10, pmix = 0.2)
  })
  data <- data.frame(Conc = conc)
  fit <- ssd_fit_dists(data, dists = c("lnorm", "llogis_llogis"), min_pmix = 0.1)
  expect_identical(attr(fit, "min_pmix"), 0.1)
  skip_on_cran() # did not throw the expected warning.
  withr::with_seed(99, {
    expect_warning(hp_err_two <- ssd_hp(fit,
                                        conc = 1, ci = TRUE, nboot = 100, average = FALSE,
                                        delta = 100
    ))
  })
  expect_snapshot_boot_data(hp_err_two, "hp_err_two")
  withr::with_seed(99, {
    expect_warning(hp_err_avg <- ssd_hp(fit,
                                        conc = 1, ci = TRUE, nboot = 100,
                                        delta = 100, ci_method = "MACL"
    ))
  })
  expect_snapshot_boot_data(hp_err_avg, "hp_err_avg")
})

test_that("ssd_hp with 1 bootstrap", {
  fit <- ssd_fit_dists(ssddata::ccme_boron, dists = "lnorm")
  withr::with_seed(10, {
    hp <- ssd_hp(fit, 1, ci = TRUE, nboot = 1, ci_method = "MACL", samples = TRUE)
  })
  expect_snapshot_data(hp, "hp_1")
})

test_that("ssd_hp fix_weight", {
  fits <- ssd_fit_dists(ssddata::ccme_boron, dists = c("lnorm", "lgumbel"))
  
  withr::with_seed(102, {
    hc_unfix <- ssd_hp(fits, nboot = 100, ci = TRUE, ci_method = "multi_free", samples = TRUE)
  })
  expect_snapshot_data(hc_unfix, "hc_unfix")
  
  withr::with_seed(102, {
    hc_fix <- ssd_hp(fits, nboot = 100, ci = TRUE, ci_method = "multi_fixed", samples = TRUE)
  })
  expect_snapshot_data(hc_fix, "hc_fix")
})

test_that("hp multis match", {
  fits <- ssd_fit_dists(ssddata::ccme_boron, dists = c("lnorm", "gamma"))
  withr::with_seed(102, {
    hp_tf <- ssd_hp(fits, ci = TRUE, nboot = 10, average = TRUE, ci_method = "weighted_samples")
  })
  withr::with_seed(102, {
    hp_ft <- ssd_hp(fits, ci = TRUE, nboot = 10, average = TRUE, est_method = "arithmetic", ci_method = "multi_fixed")
  })
  withr::with_seed(102, {
    hp_ff <- ssd_hp(fits, ci = TRUE, nboot = 10, average = TRUE, est_method = "arithmetic", ci_method = "weighted_samples")
  })
  withr::with_seed(102, {
    hp_tt <- ssd_hp(fits, ci = TRUE, nboot = 10, average = TRUE, ci_method = "multi_fixed")
  })
  
  expect_identical(hp_tf$est, hp_tt$est)
  expect_identical(hp_ft$est, hp_ff$est)
  expect_identical(hp_ft$se, hp_tt$se)
  expect_identical(hp_ff$se, hp_tf$se)
})

test_that("hp weighted bootie", {
  fits <- ssd_fit_dists(ssddata::ccme_boron)
  withr::with_seed(102, {
    hp_weighted2 <- ssd_hp(fits,
                           ci = TRUE, nboot = 10, average = TRUE,est_method = "arithmetic", ci_method = "weighted_samples",
                           samples = TRUE
    )
  })
  withr::with_seed(102, {
    hp_unweighted2 <- ssd_hp(fits, ci = TRUE, nboot = 10, average = TRUE,est_method = "arithmetic", ci_method = "MACL", samples = TRUE)
  })
  
  expect_identical(hp_weighted2$est, hp_unweighted2$est)
  expect_identical(length(hp_weighted2$samples[[1]]), 11L)
  expect_identical(length(hp_unweighted2$samples[[1]]), 60L)
  
  expect_snapshot_boot_data(hp_weighted2, "hp_weighted2")
  expect_snapshot_boot_data(hp_unweighted2, "hp_unweighted2")
})

test_that("hp multi_est = TRUE deprecated", {
  fits <- ssd_fit_dists(ssddata::ccme_boron)
  withr::with_seed(10, {
    multi <- ssd_hc(fits)
  })
  
  withr::with_seed(10, {
    lifecycle::expect_deprecated({
      true <- ssd_hc(fits, multi_est = TRUE)
    })
  })
  expect_identical(true, multi)
})

test_that("hp est_method = FALSE deprecated and overrides est_method", {
  fits <- ssd_fit_dists(ssddata::ccme_boron)
  withr::with_seed(10, {
    arithmetic <- ssd_hp(fits, est_method = "arithmetic")
  })
  
  withr::with_seed(10, {
    lifecycle::expect_deprecated({
      false <- ssd_hp(fits, multi_est = FALSE, est_method = "geometric")
    })  
  })
  
  expect_identical(false, arithmetic)
})

test_that("hp ci_method = 'weighted_arithmetic' deprecated for MACL", {
  fits <- ssd_fit_dists(ssddata::ccme_boron)
  withr::with_seed(10, {
    lifecycle::expect_deprecated({
      weighted_arithmetic <- ssd_hp(fits, ci_method = "weighted_arithmetic")
    })
  })
  
  withr::with_seed(10, {
    macl <- ssd_hp(fits, ci_method = "MACL")
  })
  
  expect_identical(macl, weighted_arithmetic)
})

## TODO: add ssd_est_methods() and ssd_ci_methods() functions.
test_that("hp est_method and ci_method combos", {
  fit <- ssd_fit_dists(ssddata::ccme_boron, dists = c("lnorm", "llogis"))
  
  est_methods <- c("multi", "arithmetic", "geometric")
  ci_methods <- c("multi_fixed", "multi_free", "weighted_samples", "MACL")
  parametric <- c(TRUE, FALSE)
  ci <- c(FALSE, TRUE)
  
  data <- tidyr::expand_grid(fit = list(fit), est_method = est_methods, ci = ci, parametric = parametric, ci_method = ci_methods)
  data$id <- 1:nrow(data)
  
  func <- function(fit, est_method, ci_method, parametric, ci, id) {
    suppressWarnings(
      withr::with_seed(10, {
        hp <- ssd_hp(fit, est_method = est_method, ci_method = ci_method, parametric = parametric, ci = ci, nboot = 10)
      })
    )
    expect_s3_class(hp, "tbl")
    hp$id <- id
    hp
  }
  ls <- purrr::pmap(data, .f = func)
  
  ls <- dplyr::bind_rows(ls)
  data <- dplyr::rename(data, ci_method_arg = "ci_method", est_method_arg = "est_method")
  data <- dplyr::inner_join(data, ls, by = "id")
  data$fit <- NULL
  expect_snapshot_data(data, "all_hp_combos")
})
