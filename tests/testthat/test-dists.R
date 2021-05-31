test_that("dists sorted character", {
  dists <- ssd_dists()
  expect_type(dists, "character")
  expect_identical(dists, stringr::str_sort(dists))
})

test_that("dists all = stable + unstable", {
  stable <- ssd_dists(type = "stable")
  unstable <- ssd_dists(type = "unstable")
  dists <- c(stable, unstable)
  dists <- stringr::str_sort(dists)
  expect_identical(dists, ssd_dists("all"))
})
