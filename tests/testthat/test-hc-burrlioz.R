test_that("ssd_hc_burrlioz gets estimates with invpareto", {
  fit <- ssd_fit_burrlioz(ssddata::ccme_boron)
  set.seed(47)
  hc_boron <- ssd_hc_burrlioz(fit, nboot = 10, ci = TRUE, min_pboot = 0)
  expect_snapshot_data(hc_boron, "hc_boron")
})

test_that("ssd_hc_burrlioz gets estimates with burrIII3", {
  set.seed(99)
  data <- data.frame(Conc = ssd_rburrIII3(30))
  fit <- ssd_fit_burrlioz(data)
  expect_identical(names(fit), "burrIII3")
  set.seed(49)
  hc_burrIII3 <- ssd_hc_burrlioz(fit, nboot = 10, ci = TRUE, min_pboot = 0)
  expect_snapshot_data(hc_burrIII3, "hc_burrIII3")
})

test_that("ssd_hc_burrlioz gets estimates with burrIII3 parametric", {
  set.seed(99)
  data <- data.frame(Conc = ssd_rburrIII3(30))
  fit <- ssd_fit_burrlioz(data)
  expect_identical(names(fit), "burrIII3")
  set.seed(49)
  hc_burrIII3 <- ssd_hc_burrlioz(fit, nboot = 10, ci = TRUE, min_pboot = 0,
                                 parametric = TRUE)
  expect_snapshot_data(hc_burrIII3, "hc_burrIII3_parametric")
})
