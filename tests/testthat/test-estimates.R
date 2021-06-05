test_that("estimates gives named list 1 dist", {
  estimates <- estimates(boron_lnorm)
  expect_identical(names(estimates), "lnorm")
  expect_equal(names(estimates$lnorm), c("meanlog", "sdlog"))
  expect_equal(estimates$lnorm$meanlog, 2.56164496371788)
  expect_equal(estimates$lnorm$sdlog, 1.24154032419128)
})

test_that("estimates gives named list dists", {
  estimates <- estimates(boron_dists)
  expect_identical(names(estimates), c("gamma", "llogis", "lnorm"))
  expect_equal(names(estimates$lnorm), c("meanlog", "sdlog"))
  expect_equal(estimates$lnorm$meanlog, 2.56164496371788)
  expect_equal(estimates$lnorm$sdlog, 1.24154032419128)
})

test_that("estimates same as tidy (this is very important)", {
  estimates <- unlist(estimates(boron_dists))
  tidy <- tidy(boron_dists)
  tidy <- setNames(tidy$est, paste(tidy$dist, tidy$term, sep = "."))
  
  expect_equal(estimates, tidy)
})
