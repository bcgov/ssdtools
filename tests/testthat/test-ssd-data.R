test_that("sdd_data gets original data", {
  expect_identical(ssd_data(boron_lnorm), boron_data)
})

test_that("sdd_data gets tbl data", {
  data <- data.frame(Conc = seq(1,6,by = 1))
  fits <- ssd_fit_dists(data, dists = "lnorm")
  expect_identical(ssd_data(fits), tibble::as_tibble(data))
})
