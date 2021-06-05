test_that("tidy doesn't reorder dists (but does reorder pars)", {
  fit <- ssd_fit_dists(ssdtools::boron_data, dists = c("lnorm", "llogis"))
  tidy <- tidy(fit)
  expect_s3_class(tidy, "tbl_df")
  expect_identical(colnames(tidy), c("dist", "term", "est", "se"))
  expect_identical(tidy$dist, c(rep("lnorm", 2), rep("llogis", 2)))
  expect_identical(tidy$term, c("meanlog", "sdlog", "locationlog", "scalelog"))
})

test_that("tidy fit all with also doesn't reorder dists (but does reorder pars)", {
  fit <- ssd_fit_dists(ssdtools::boron_data, dists = c("lnorm", "llogis"))
  
  tidy <- tidy(fit, all = TRUE)
  expect_identical(colnames(tidy), c("dist", "term", "est", "se"))
  expect_identical(tidy$dist, c(rep("lnorm", 3), rep("llogis", 3)))
  expect_identical(tidy$term, c("log_sdlog", "meanlog", "sdlog", "locationlog", "log_scalelog", "scalelog"))
})
