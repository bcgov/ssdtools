test_that("left, right and interval censoring works ", {
  data <- ssddata::ccme_boron
  data$right <- data$Conc
  data$right[1] <- Inf
  data$Conc[2] <- 0
  data$right[3] <- data$Conc[3] * 2
  fit <- ssd_fit_dists(data, right = "right")
  
  set.seed(42)
  hcnonparametric <- ssd_hc(fit, ci = TRUE, average = FALSE, parametric = FALSE, nboot = 10, min_pboot = 0.1)
  expect_snapshot_data(hcnonparametric, "hcnonparametric")
  
  expect_warning(hcparametric <- ssd_hc(fit, ci = TRUE, average = FALSE, parametric =TRUE), "^Parametric CIs cannot be calculated for censored data\\.$")
  expect_snapshot_data(hcparametric, "hcparametric")
  
  expect_warning(hcaverage <- ssd_hc(fit, average = TRUE), "^Model averaged estimates cannot be calculated for censored data when the distributions have different numbers of parameters\\.$")
  expect_snapshot_data(hcaverage, "hcaverage")

  set.seed(42)
  # warning(hcaveragenonparametric <- ssd_hc(fit, ci = TRUE, average = TRUE, parametric = FALSE, nboot = 10, min_pboot = 0.5), "^Model averaged estimates cannot be calculated for censored data when the distributions have different numbers of parameters\\.$")
})

test_that("left, right and interval censoring works same number of parameter ", {
  data <- ssddata::ccme_boron
  data$right <- data$Conc
  data$right[1] <- Inf
  data$Conc[2] <- 0
  data$right[3] <- data$Conc[3] * 2
  fit <- ssd_fit_dists(data, right = "right",dists = ssdtools::ssd_dists_bcanz(npars = 2L))
  
  set.seed(42)
  hcnonparametric <- ssd_hc(fit, ci = TRUE, average = FALSE, parametric = FALSE, nboot = 10)
  expect_snapshot_data(hcnonparametric, "hcnonparametric2")
  
  expect_warning(hcparametric <- ssd_hc(fit, ci = TRUE, average = FALSE, parametric =TRUE), "^Parametric CIs cannot be calculated for censored data\\.$")
  expect_snapshot_data(hcparametric, "hcparametric2")
  
  hcaverage <- ssd_hc(fit, average = TRUE)
  expect_snapshot_data(hcaverage, "hcaverage2")
  set.seed(42)
  hcaveragenonparametric <- ssd_hc(fit, ci = TRUE, average = TRUE, parametric = FALSE, nboot = 10)
  expect_snapshot_data(hcaveragenonparametric, "hcaveragenonparametric2")
})
