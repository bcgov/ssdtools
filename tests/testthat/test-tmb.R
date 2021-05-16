test_that("tidy.tmbfit", {
  fit <- ssd_fit_dists(ssdtools::boron_data, dists = "lnorm", tmb = TRUE)
  expect_is(fit, "fitdists")
  
  expect_identical(npars(fit), c(lnorm = 2L))
  expect_identical(npars(fit$lnorm), 2L)
  expect_equal(nobs(fit), 28L)
  expect_equal(nobs(fit$lnorm), 28L)
  expect_equal(logLik(fit$lnorm), -117.514216489547)
  expect_equal(logLik(fit), c(lnorm = -117.514216489547))
  expect_equal(logLik(fit$lnorm), -117.514216489547)
  
  hc <- ssd_hc(fit$lnorm)
  expect_is(hc, "tbl_df")
  expect_identical(colnames(hc), c("dist", "percent", "est", "se", "lcl", "ucl"))
  expect_equal(hc$est, 1.681174837758)
  expect_identical(hc$se, NA_real_)
  
  hp <- ssd_hp(fit$lnorm, 1, nboot = 10)
  expect_is(hp, "tbl_df")
  expect_identical(colnames(hp), c("conc", "est", "se", "lcl", "ucl", "dist"))
  expect_identical(hp$conc, 1)
  expect_equal(hp$est, 1.95430302556687) 
  expect_equal(hp$se, NA_real_) 
  expect_equal(hp$lcl, NA_real_) 
  expect_equal(hp$ucl, NA_real_) 
  expect_equal(hp$dist, "lnorm")
  
#  augment <- augment(fit$lnorm) not sure why not working
  
  glance <- glance(fit$lnorm)
  expect_is(glance, "tbl_df")
  expect_identical(colnames(glance), c("dist", "npars", "nobs", "log_lik", "aic", "aicc"))
  expect_identical(glance$dist, "lnorm")
  expect_equal(glance$aicc, 239.508432979094)
  
  glance <- glance(fit)
  expect_is(glance, "tbl_df")
  expect_identical(colnames(glance), c("dist", "npars", "nobs", "log_lik", "aic", "aicc", "delta", "weight"))
  expect_identical(glance$dist, "lnorm")
  expect_equal(glance$delta, 0)
  expect_equal(glance$weight, 1)
  
  tidy <- tidy(fit$lnorm)
  expect_is(tidy, "tbl_df")
  expect_identical(colnames(tidy), c("dist", "term", "est", "se"))
  expect_identical(tidy$dist, rep("lnorm", 2))
  expect_identical(tidy$term, term::as_term(c("meanlog", "sdlog")))
  
  expect_equal(tidy(fit), tidy)
  
  tidy <- tidy(fit$lnorm, all = TRUE)
  expect_is(tidy, "tbl_df")
  expect_identical(colnames(tidy), c("dist", "term", "est", "se"))
  expect_identical(tidy$dist, rep("lnorm", 3))
  expect_identical(tidy$term, term::as_term(c("log_sdlog", "meanlog", "sdlog")))
  
  expect_equal(tidy(fit, all = TRUE), tidy)
})

test_that("combine", {
  fit <- ssd_fit_dists(ssdtools::boron_data, dists = c("lnorm", "llogis"), tmb = TRUE)
  expect_is(fit, "fitdists")
  
  expect_identical(npars(fit), c(llogis = 2L, lnorm = 2L))
  expect_equal(nobs(fit), 28L)
  expect_equal(nobs(fit$lnorm), 28L)
  expect_equal(logLik(fit), c(llogis = -118.507435324581, lnorm = -117.514216489547))
  expect_equal(logLik(fit$lnorm), -117.514216489547)

  # need ssd_hc and ssd_hp for multiple model
  
  glance <- glance(fit)
  expect_is(glance, "tbl_df")
  expect_identical(colnames(glance), c("dist", "npars", "nobs", "log_lik", "aic", "aicc", "delta", "weight"))
  expect_identical(glance$dist, c("llogis", "lnorm"))
  expect_equal(glance$delta, c(1.98643767006848, 0))
  expect_equal(glance$weight, c(0.270276766487089, 0.729723233512911))
  
  tidy <- tidy(fit)
  expect_is(tidy, "tbl_df")
  expect_identical(colnames(tidy), c("dist", "term", "est", "se"))
  expect_identical(tidy$dist, c(rep("llogis", 2), rep("lnorm", 2)))
  expect_identical(tidy$term, term::as_term(c("locationlog", "scalelog", "meanlog", "sdlog")))
  
  tidy <- tidy(fit, all = TRUE)
  expect_is(tidy, "tbl_df")
  expect_identical(colnames(tidy), c("dist", "term", "est", "se"))
  expect_identical(tidy$dist, c(rep("llogis", 3), rep("lnorm", 3)))
  expect_identical(tidy$term, term::as_term(c("locationlog", "log_scalelog", "scalelog", "log_sdlog", "meanlog", "sdlog")))
})
