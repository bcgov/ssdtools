test_that("ssd_hc_burrlioz gets estimates", {
  fit <- ssd_fit_burrlioz(ssddata::ccme_boron)
  set.seed(47)
  hc_boron <- ssd_hc_burrlioz(fit, nboot = 10, ci = TRUE, min_pboot = 0)
  expect_snapshot_data(hc_boron, "hc_boron")
})
