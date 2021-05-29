test_that("dists sorted character", {
  dists <- ssd_dists()
  expect_type(dists, "character")
  expect_identical(dists, stringr::str_sort(dists))
})
