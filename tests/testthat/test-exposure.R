context("exposure")

test_that("exposure fitdist", {
  set.seed(1)
  expect_equal(ssd_exposure(boron_lnorm), 0.0554388690712784)
  set.seed(1)
  expect_equal(ssd_exposure(boron_lnorm, 1), 0.165064610422855)
  set.seed(1)
  expect_equal(ssd_exposure(boron_lnorm, 1, sdlog = 10), 0.433888512433457)
})

test_that("exposure fitdists", {
  set.seed(1)
  expect_equal(ssd_exposure(boron_dists), 0.0646702629935565)
})

test_that("exposure fitdistcens", {
  set.seed(1)
  expect_equal(ssd_exposure(fluazinam_lnorm), 0.04159029277336)
})

test_that("exposure fitdistscens", {
  set.seed(1)
  expect_equal(ssd_exposure(fluazinam_dists), 0.0504310170098388)
})
