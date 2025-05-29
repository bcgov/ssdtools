test_that("left, right and interval censoring works ", {
  data <- ssddata::ccme_boron
  data$right <- data$Conc
  data$right[1] <- Inf
  data$Conc[2] <- 0
  data$right[3] <- data$Conc[3] * 2
  fit <- ssd_fit_dists(data, right = "right")
  
  withr::with_seed(42, {
    hcnonparametric <- ssd_hc(fit, ci = TRUE, average = FALSE, parametric = FALSE, nboot = 10, min_pboot = 0.1)
    expect_warning(hcparametric <- ssd_hc(fit, ci = TRUE, average = FALSE, parametric =TRUE), "^Parametric CIs cannot be calculated for censored data\\.$")
    expect_warning(hcaverage <- ssd_hc(fit, ci = FALSE, average = TRUE, parametric = TRUE), "^Model averaged estimates cannot be calculated for censored data when the distributions have different numbers of parameters\\.$")
  })
  expect_snapshot_data(hcnonparametric, "hcnonparametric", digits = 3)
  
  expect_snapshot_data(hcparametric, "hcparametric")
  
  expect_snapshot_data(hcaverage, "hcaverage")
  
  withr::with_seed(42, {
    # FIXME - should return tibble with 1 row even if NAs
    expect_error(expect_warning(hcaveragenonparametric <- ssd_hc(fit, ci = TRUE, average = TRUE, parametric = FALSE, nboot = 10, min_pboot = 0.5), "^Model averaged estimates cannot be calculated for censored data when the distributions have different numbers of parameters\\.$"))
  })
})

test_that("left, right and interval censoring works same number of parameter ", {
  data <- ssddata::ccme_boron
  data$right <- data$Conc
  data$right[1] <- Inf
  data$Conc[2] <- 0
  data$right[3] <- data$Conc[3] * 2
  fit <- ssd_fit_dists(data, right = "right",dists = ssdtools::ssd_dists_bcanz(npars = 2L))
  
  withr::with_seed(42, {
    hcnonparametric <- ssd_hc(fit, ci = TRUE, average = FALSE, parametric = FALSE, nboot = 10)
    expect_warning(hcparametric <- ssd_hc(fit, ci = TRUE, average = FALSE, parametric =TRUE), "^Parametric CIs cannot be calculated for censored data\\.$")
    hcaverage <- ssd_hc(fit, ci = FALSE, average = TRUE, parametric = TRUE)
  })
  expect_snapshot_data(hcnonparametric, "hcnonparametric2")
  
  expect_snapshot_data(hcparametric, "hcparametric2")
  
  expect_snapshot_data(hcaverage, "hcaverage2")
  withr::with_seed(42, {
    hcaveragenonparametric <- ssd_hc(fit, ci = TRUE, average = TRUE, parametric = FALSE, nboot = 10)
  })
  expect_snapshot_data(hcaveragenonparametric, "hcaveragenonparametric2")
})

test_that("stability of bccanz dists with heavy censoring", {
  withr::with_seed(10, {
    data <- data.frame(Conc = rlnorm(30, 1))
    data$right <- data$Conc + rlnorm(30, sdlog = 2)
    data$right[runif(15, 1, nrow(data))] <- Inf  
    
    fit <- ssd_fit_dists(data = data, right = "right")
    
    hcheavy <- ssd_hc(fit, average = FALSE)
  })
  expect_snapshot_data(hcheavy, "hcheavy")
})

