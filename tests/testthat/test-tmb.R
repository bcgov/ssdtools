test_that("tidy.tmbfit", {
  fit <- ssd_fit_dists(ssdtools::boron_data, dists = "lnorm", tmb = TRUE)
  expect_is(fit, "fitdists")
  
  expect_identical(npars(fit), c(lnorm = 2L))
  
  tidy <- tidy(fit$lnorm)
  expect_is(tidy, "tbl_df")
  expect_identical(colnames(tidy), c("dist", "term", "estimate", "se"))
  expect_identical(tidy$dist, rep("lnorm", 2))
  expect_identical(tidy$term, term::as_term(c("meanlog", "sdlog")))
  
  tidy <- tidy(fit$lnorm, all = TRUE)
  expect_is(tidy, "tbl_df")
  expect_identical(colnames(tidy), c("dist", "term", "estimate", "se"))
  expect_identical(tidy$dist, rep("lnorm", 3))
  expect_identical(tidy$term, term::as_term(c("log_sdlog", "meanlog", "sdlog")))
})

test_that("combine", {
  fit <- ssd_fit_dists(ssdtools::boron_data, dists = c("lnorm", "llogis"), tmb = TRUE)
  expect_is(fit, "fitdists")
  
  expect_identical(npars(fit), c(llogis = 2L, lnorm = 2L))
  
  tidy <- tidy(fit)
  expect_is(tidy, "tbl_df")
  expect_identical(colnames(tidy), c("dist", "term", "estimate", "se"))
  expect_identical(tidy$dist, c(rep("llogis", 2), rep("lnorm", 2)))
  expect_identical(tidy$term, term::as_term(c("locationlog", "scalelog", "meanlog", "sdlog")))
  
  tidy <- tidy(fit, all = TRUE)
  expect_is(tidy, "tbl_df")
  expect_identical(colnames(tidy), c("dist", "term", "estimate", "se"))
  expect_identical(tidy$dist, c(rep("llogis", 3), rep("lnorm", 3)))
  expect_identical(tidy$term, term::as_term(c("locationlog", "log_scalelog", "scalelog", "log_sdlog", "meanlog", "sdlog")))
})
