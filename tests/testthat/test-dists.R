test_that("multiplication works", {
  dists <- ssd_dists()
  expect_type(dists, "character")
  expect_identical(dists, stringr::str_sort(dists))
})
