test_that("dists sorted character", {
  dists <- ssd_dists()
  dists <- dists[!dists %in% c("llog", "burrIII2")]
  fit <- ssd_fit_dists(ssdtools::boron_data, dists = dists)
  expect_identical(names(fit), dists)
#  ssd_hc(fit) need qburrII3_sd
})
