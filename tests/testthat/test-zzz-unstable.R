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
#    
test_that("weibull is unstable", {
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
  
  # not sure why weibull dropping on some linux on github actions and windows
  # on other folks machines
  testthat::skip_on_ci()
  testthat::skip_on_cran()
  expect_identical(names(fits), c('gamma', 'weibull'))
})

test_that("hc multi lnorm default 100", {
  fits <- ssd_fit_dists(ssddata::ccme_boron)
  set.seed(102)
  hc_average <- ssd_hc(fits, average = TRUE, ci = TRUE, nboot = 100, multi = FALSE)
  set.seed(102)
  hc_multi <- ssd_hc(fits, average = TRUE, multi = TRUE, ci = TRUE, nboot = 100,
                     min_pboot = 0.8)
  
  testthat::expect_snapshot({
    hc_average
  })
  
  # not sure why hc multi is different on windows
  # ══ Failed tests ════════════════════════════════════════════════════════════════
  # ── Failure ('test-hc-root.R:77:3'): hc multi lnorm default 100 ─────────────────
  # Snapshot of code has changed:
  #   old[4:7] vs new[4:7]
  # # A tibble: 1 x 10
  # dist    percent   est    se   lcl   ucl    wt method     nboot pboot
  # <chr>     <dbl> <dbl> <dbl> <dbl> <dbl> <dbl> <chr>      <dbl> <dbl>
  #   -   1 average       5  1.26 0.781 0.331  3.25     1 parametric   100  0.86
  #   +   1 average       5  1.26 0.769 0.410  3.25     1 parametric   100  0.86
  testthat::skip_on_ci() 
  testthat::skip_on_cran()
  testthat::expect_snapshot({
    hc_multi
  })
})

test_that("hp multi lnorm default 100", {
  fits <- ssd_fit_dists(ssddata::ccme_boron)
  set.seed(102)
  hp_average <- ssd_hp(fits, average = TRUE, ci = TRUE, nboot = 100, multi = FALSE)
  set.seed(102)
  hp_multi <- ssd_hp(fits, average = TRUE, multi = TRUE, ci = TRUE, nboot = 100,
                     min_pboot = 0.8)
  
  testthat::expect_snapshot({
    hp_average
  })
  testthat::skip_on_ci() 
  testthat::skip_on_cran()
  # ── Failure ('test-hp-root.R:79:3'): hp multi lnorm default 100 ─────────────────
  # Snapshot of code has changed:
  #   old[4:7] vs new[4:7]
  # # A tibble: 1 x 10
  # dist     conc   est    se   lcl   ucl    wt method     nboot pboot
  # <chr>   <dbl> <dbl> <dbl> <dbl> <dbl> <dbl> <chr>      <dbl> <dbl>
  #   -   1 average     1  3.90  3.57 0.347  11.2     1 parametric   100  0.86
  #   +   1 average     1  3.90  2.89 0.347  11.2     1 parametric   100  0.86
  testthat::expect_snapshot({
    hp_multi
  })
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
  expect_snapshot_data(hc_err, "hc_err_na")
  hc_err <- ssd_hc(fit, ci = TRUE, nboot = 100, min_pboot = 0.92, multi = FALSE)
  expect_s3_class(hc_err, "tbl")
  expect_snapshot_data(hc_err, "hc_err")
})

test_that("ssd_hc comparable parametric and non-parametric big sample size", {
  skip_on_ci()
  skip_on_cran()
  
  set.seed(99)
  data <- data.frame(Conc = ssd_rlnorm(10000, 2, 1))
  fit <- ssd_fit_dists(data, dists = "lnorm")
  set.seed(10)
  hc_para <- ssd_hc(fit, ci = TRUE, nboot = 10, multi = FALSE)
  expect_snapshot_data(hc_para, "hc_para")
  set.seed(10)
  hc_nonpara <- ssd_hc(fit, ci = TRUE, nboot = 10, parametric = FALSE, multi = FALSE)
  expect_snapshot_data(hc_nonpara, "hc_nonpara")
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
  expect_snapshot_data(hp_err, "hp_err_na")
  hp_err <- ssd_hp(fit, conc = 1, ci = TRUE, nboot = 100, min_pboot = 0.92, multi = FALSE)
  expect_s3_class(hp_err, "tbl")
  expect_snapshot_data(hp_err, "hp_err")
})

test_that("ssd_hp comparable parametric and non-parametric big sample size", {
  skip_on_ci()
  skip_on_cran()
  
  set.seed(99)
  data <- data.frame(Conc = ssd_rlnorm(10000, 2, 1))
  fit <- ssd_fit_dists(data, dists = "lnorm")
  set.seed(10)
  hp_para <- ssd_hp(fit, 1, ci = TRUE, nboot = 10, multi = FALSE)
  expect_snapshot_data(hp_para, "hp_para")
  set.seed(10)
  hp_nonpara <- ssd_hp(fit, 1, ci = TRUE, nboot = 10, parametric = FALSE, multi = FALSE)
  expect_snapshot_data(hp_nonpara, "hp_nonpara")
})

test_that("plot geoms", {
  skip_on_ci()
  skip_on_cran()
  
  gp <- ggplot2::ggplot(boron_pred) +
    geom_ssdpoint(data = ssddata::ccme_boron, ggplot2::aes(x = Conc)) +
    geom_ssdsegment(data = ssddata::ccme_boron, ggplot2::aes(x = Conc, xend = Conc * 2)) +
    geom_hcintersect(xintercept = 100, yintercept = 0.5) +
    geom_xribbon(
      ggplot2::aes(xmin = lcl, xmax = ucl, y = percent / 100),
      alpha = 1 / 3
    )
  expect_snapshot_plot(gp, "geoms_all")
})


test_that("ssd_plot censored data", {
  skip_on_ci()
  skip_on_cran()

  data <- ssddata::ccme_boron
  data$Other <- data$Conc * 2
  expect_snapshot_plot(ssd_plot(data, boron_pred, right = "Other", ribbon = TRUE), "boron_cens_pred_ribbon")
})

test_that("invpareto with extreme data", {
  data <- data.frame(Conc = c(
    2.48892649039671, 2.5258371156749, 2.51281264491458,
    2.49866046657748, 2.56572740160664, 2.49440006912093, 2.4817062813665,
    2.47546618759501, 2.53571697416386, 2.50242492575677, 2.50112253589808,
    2.5287786019635, 2.57780684900776, 2.53608336578284, 2.58101156958599,
    2.47461770234486, 2.49063194551244, 2.5856619890231, 2.48695693688166,
    2.57378026021983, 2.51235308389976, 2.48522032692049, 2.49973051106759,
    2.53625648406357, 2.51192819101941, 2.48564121012588, 2.47989185141965,
    2.47104478254847, 2.53704987914894, 2.48182203478124, 2.51943279158882,
    2.47875248023764, 2.52955571948405, 2.53413505298479, 2.4857126516631,
    2.55015093854307, 2.50566701101757, 2.5134323318284, 2.49793441210188,
    2.49424215906085, 2.48960347486455, 2.55358332496617, 2.55446292958609,
    2.48210193691792, 2.46945069890001, 2.48557684661491, 2.56460608968987,
    2.53708962699444, 2.48214951933889, 2.54412439394134, 2.59518068845417,
    2.55975671870397, 2.493434223589, 2.53455956396635, 2.49737837236316,
    2.54900643026637, 2.50513718347292, 2.54882879624245, 2.51814393193009,
    2.46420777049251, 2.46410824439861, 2.52375449633473, 2.50472480352834,
    2.47468853687034, 2.49903375287477, 2.51052484516152, 2.52440831022558,
    2.48241564711347, 2.57274003332032, 2.48966764017043, 2.5690823103684,
    2.50354051434315, 2.57783696959855, 2.55278129417344, 2.49091327122561,
    2.4858726676362, 2.50704022976757, 2.60120582374815, 2.48030852436464,
    2.58234455069583, 2.54629314447072, 2.52650700793897, 2.4871602238994,
    2.50569757079671, 2.49183442063104, 2.50165889380711, 2.47934668379978,
    2.47510756679179, 2.53369127110563, 2.46868451852079, 2.61321699644183,
    2.52987952199996, 2.58987810707128, 2.46777896999791, 2.51447342615507,
    2.48618482994608, 2.51794970929166, 2.49716394702713, 2.49218587262049
  ))
 
  skip_on_ci()
  skip_on_cran()
  
  fit99 <- ssd_fit_dists(data, dists = "invpareto")
  
  expect_equal(
    estimates(fit99),
    list(invpareto.weight = 1, invpareto.scale = 2.61422138795731, invpareto.shape = 26.0278618888663)
  )
})

