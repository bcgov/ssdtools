# commented out as weight argument currently defunct

# test_that("weighted errors", {
#   data <- ssddata::ccme_boron
#   
#   data$Weight <- 1
#   data$Weight[rank(data$Conc) > 6] <- 0
#   
#   lifecycle::expect_defunct(expect_error(ssd_fit_dists(data, dists="lnorm", weight = "Weight"),
#                "^`data` has 22 rows with zero weight in 'Weight'\\.$"))
# # 
# #   data$Weight[rank(data$Conc) > 6] <- -1
# #   
# #   expect_error(ssd_fit_dists(data, dists="lnorm", weight = "Weight"),
# #                "^`data\\$Weight` must have values between 0 and Inf\\.$")
# #   
# #   data$Weight[rank(data$Conc) > 6] <- Inf
# #   
# #   expect_warning(expect_error(ssd_fit_dists(data, dists="lnorm", weight = "Weight"),
# #                "^All distributions failed to fit\\.$"))
#   
# })
#   
# test_that("weighted works", {
#   data <- ssddata::ccme_boron
#   
#   data$Weight <- 1
#   data$Weight[rank(data$Conc) > 6] <- 1/10
#   
#   fitall <- ssd_fit_dists(data, dists="lnorm")
#   hcall <- ssd_hc(fitall)
#   expect_snapshot_data(hcall, "hcall")
#   
#   fit1 <- ssd_fit_dists(subset(data, Weight == 1), dists="lnorm")
#   hc1 <- ssd_hc(fit1)
#   expect_snapshot_data(hc1, "hc1")
#   
#   lifecycle::expect_defunct(fit1w <- ssd_fit_dists(subset(data, Weight == 1), dists="lnorm", weight = "Weight"))
#   # hc1w <- ssd_hc(fit1w)
#   # expect_snapshot_data(hc1w, "hc1w")
#   # 
#   # fitallw10 <- ssd_fit_dists(data, dists="lnorm", weight = "Weight")
#   # hcallw10 <- ssd_hc(fitallw10)
#   # expect_snapshot_data(hcallw10, "hcallw10")
#   # 
#   # data$Weight[rank(data$Conc) > 6] <- 1/100
#   # 
#   # fitallw100 <- ssd_fit_dists(data, dists="lnorm", weight = "Weight")
#   # hcallw100 <- ssd_hc(fitallw100)
#   # expect_snapshot_data(hcallw100, "hcallw100")
#   # 
#   # data$Weight[rank(data$Conc) > 6] <- 1/1000
#   # 
#   # fitallw1000 <- ssd_fit_dists(data, dists="lnorm", weight = "Weight")
#   # hcallw1000 <- ssd_hc(fitallw1000)
#   # expect_snapshot_data(hcallw1000, "hcallw1000")
# })
# 
# test_that("weighted2", {
#   data <- ssddata::ccme_boron
#   
#   data$Weight <- 2
# 
#   lifecycle::expect_defunct(fit2 <- ssd_fit_dists(data, dists="lnorm", weight = "Weight"))
#   # hc2 <- ssd_hc(fit2)
#   # expect_snapshot_data(hc2, "hc2")
# })
# 
# 
# test_that("glance weights rescale log_lik", {
#   data <- ssddata::ccme_boron
#   data$weight <- rep(1, nrow(data))
#   lifecycle::expect_defunct(fit <- ssd_fit_dists(data, weight = "weight"))
#   # data$weight <- rep(2, nrow(data))
#   # fit_weight <- ssd_fit_dists(data, weight = "weight")
#   # 
#   # glance <- glance(fit)
#   # glance_weight <- glance(fit_weight)
#   # expect_equal(glance_weight$log_lik / 2, glance$log_lik)
# })
# 
# test_that("glance reweight same log_lik", {
#   data <- ssddata::ccme_boron
#   data$weight <- rep(1, nrow(data))
#   lifecycle::expect_defunct(fit <- ssd_fit_dists(data, weight = "weight"))
#   # data$weight <- rep(2, nrow(data))
#   # fit_weight <- ssd_fit_dists(data, weight = "weight", reweight = TRUE)
#   # 
#   # glance <- glance(fit)
#   # glance_weight <- glance(fit_weight)
#   # expect_equal(glance_weight$log_lik, glance$log_lik)
# })
# 
# test_that("ssd_hc same with equally weighted data", {
#   
#   data <- ssddata::ccme_boron
#   data$Weight <- rep(1, nrow(data))
#   lifecycle::expect_defunct(fits <- ssd_fit_dists(data, weight = "Weight", dists = "lnorm"))
#   # set.seed(10)
#   # hc <- ssd_hc(fits, ci = TRUE, nboot = 10)
#   # 
#   # data$Weight <- rep(2, nrow(data))
#   # fits2 <- ssd_fit_dists(data, weight = "Weight", dists = "lnorm")
#   # set.seed(10)
#   # hc2 <- ssd_hc(fits2, ci = TRUE, nboot = 10)
#   # expect_equal(hc2, hc)
# })
# 
# test_that("ssd_hc calculates cis with equally weighted data", {
#   data <- ssddata::ccme_boron
#   data$Weight <- rep(2, nrow(data))
#   lifecycle::expect_defunct(fits <- ssd_fit_dists(data, weight = "Weight", dists = "lnorm"))
#   # set.seed(10)
#   # hc <- ssd_hc(fits, ci = TRUE, nboot = 10, multi_ci = FALSE, samples = TRUE, weighted = FALSE)
#   # expect_snapshot_data(hc, "hcici")
# })
# 
# test_that("ssd_hp same with equally weighted data", {
#   
#   data <- ssddata::ccme_boron
#   data$Weight <- rep(1, nrow(data))
#   lifecycle::expect_defunct(fits <- ssd_fit_dists(data, weight = "Weight", dists = "lnorm"))
#   # set.seed(10)
#   # hp <- ssd_hp(fits, 1, ci = TRUE, nboot = 10)
#   # 
#   # data$Weight <- rep(2, nrow(data))
#   # fits2 <- ssd_fit_dists(data, weight = "Weight", dists = "lnorm")
#   # set.seed(10)
#   # hp2 <- ssd_hp(fits2, 1, ci = TRUE, nboot = 10)
#   # expect_equal(hp2, hp)
# })
# 
# test_that("ssd_hp calculates cis with equally weighted data", {
#   data <- ssddata::ccme_boron
#   data$Weight <- rep(2, nrow(data))
#   lifecycle::expect_defunct(fits <- ssd_fit_dists(data, weight = "Weight", dists = "lnorm"))
#   # set.seed(10)
#   # hp <- ssd_hp(fits, 1, ci = TRUE, nboot = 10, multi_ci = FALSE, weighted = FALSE)
#   # expect_equal(hp$se, 1.45515712342784)
# })
# 
# test_that("summary fitdists with left censored, rescaled, weighted data", {
#   data <- ssddata::ccme_boron
#   data$Mass <- seq_len(nrow(data))
#   data$Other <- data$Conc
#   data$Conc[2] <- NA
#   lifecycle::expect_defunct(fits <- ssd_fit_dists(data, right = "Other", weight = "Mass", rescale = TRUE, dists = "lnorm"))
#   #  expect_snapshot_output(print(fits))
# })
# 
# 
# test_that("summary fitdists with censored, rescaled, unequally weighted data", {
#   data <- ssddata::ccme_boron
#   data$Mass <- seq_len(nrow(data))
#   data$Other <- data$Conc
#   data$Conc[2] <- NA
#   lifecycle::expect_defunct(fits <- ssd_fit_dists(data, right = "Other", weight = "Mass", rescale = TRUE, dists = "lnorm"))
#   # summary <- summary(fits)
#   # expect_s3_class(summary, "summary_fitdists")
#   # expect_identical(names(summary), c("fits", "censoring", "nrow", "rescaled", "weighted", "unequal", "min_pmix"))
#   # expect_equal(summary$censoring, c(2.4, Inf))
#   # expect_identical(summary$nrow, 28L)
#   # expect_equal(summary$rescaled, 8.40832920383116)
#   # expect_identical(summary$weighted, 28)
#   # expect_identical(summary$unequal, TRUE)
# })
# 
# test_that("summary weighted if equal weights but not 1", {
#   data <- ssddata::ccme_boron
#   data$Mass <- 2
#   lifecycle::expect_defunct(fits <- ssd_fit_dists(data, weight = "Mass", dists = "lnorm"))
#   # summary <- summary(fits)
#   # expect_s3_class(summary, "summary_fitdists")
#   # expect_identical(summary$weighted, 2)
#   # expect_identical(summary$unequal, FALSE)
# })
# 
# test_that("summary not weighted if equal weights but not 1 and reweighted", {
#   data <- ssddata::ccme_boron
#   data$Mass <- 2
#   lifecycle::expect_defunct(fits <- ssd_fit_dists(data, weight = "Mass", reweight = TRUE, dists = "lnorm"))
#   # summary <- summary(fits)
#   # expect_s3_class(summary, "summary_fitdists")
#   # expect_identical(summary$weighted, 1)
#   # expect_identical(summary$unequal, FALSE)
# })
# 
# test_that("ssd_hp doesn't calculate cis with unequally weighted data", {
#   
#   data <- ssddata::ccme_boron
#   data$Weight <- rep(1, nrow(data))
#   data$Weight[1] <- 2
#   lifecycle::expect_defunct(fits <- ssd_fit_dists(data, weight = "Weight", dists = "lnorm"))
#   # expect_warning(
#   #   hp <- ssd_hp(fits, 1, ci = TRUE, nboot = 10),
#   #   "^Parametric CIs cannot be calculated for unequally weighted data[.]$"
#   # )
#   # expect_identical(hp$se, NA_real_)
# })
# 
# test_that("ssd_hp no effect with higher weight one distribution", {
#   
#   data <- ssddata::ccme_boron
#   data$Weight <- rep(1, nrow(data))
#   lifecycle::expect_defunct(fits <- ssd_fit_dists(data, weight = "Weight", dists = "lnorm"))
#   # data$Weight <- rep(10, nrow(data))
#   # fits_10 <- ssd_fit_dists(data, weight = "Weight", dists = "lnorm")
#   # set.seed(10)
#   # hp <- ssd_hp(fits, 3, ci = TRUE, nboot = 10)
#   # set.seed(10)
#   # hp_10 <- ssd_hp(fits_10, 3, ci = TRUE, nboot = 10)
#   # expect_equal(hp_10, hp)
# })
# 
# test_that("ssd_hp effect with higher weight two distributions", {
#   data <- ssddata::ccme_boron
#   data$Weight <- rep(1, nrow(data))
#   lifecycle::expect_defunct(fits <- ssd_fit_dists(data, weight = "Weight", dists = c("lnorm", "llogis")))
#   # data$Weight <- rep(10, nrow(data))
#   # fits_10 <- ssd_fit_dists(data, weight = "Weight", dists = c("lnorm", "llogis"))
#   # set.seed(10)
#   # hp <- ssd_hp(fits, 3, ci = TRUE, nboot = 10, multi_ci = FALSE, weighted = FALSE)
#   # set.seed(10)
#   # hp_10 <- ssd_hp(fits_10, 3, ci = TRUE, nboot = 10, multi_ci = FALSE, weighted = FALSE)
#   # expect_equal(hp$est, 11.7535819824013)
#   # expect_equal(hp_10$est, 11.9318338996079)
#   # expect_equal(hp$se, 4.56372685665889)
#   # expect_equal(hp_10$se, 4.83426663939758)
# })
# 
# test_that("ssd_hc save_to lnorm 1", {
#   dir <- withr::local_tempdir()
#   
#   fits <- ssd_fit_dists(ssddata::ccme_boron, dists = "lnorm")
#   set.seed(102)
#   hc <- ssd_hc(fits, nboot = 1, ci = TRUE, save_to = dir, samples = TRUE)
#   expect_snapshot_data(hc, "hc_save_to11")
#   expect_identical(list.files(dir), c("data_000000000_multi.csv", "data_000000001_multi.csv", "estimates_000000000_multi.rds", 
#                                       "estimates_000000001_multi.rds"))
#   boot1 <- read.csv(file.path(dir, "data_000000001_multi.csv"))
#   lifecycle::expect_defunct(fit1 <- ssd_fit_dists(boot1, dists = "lnorm", left = "left", right = "right", weight = "weight"))
#   # est <- ssd_hc(fit1)$est
#   # expect_identical(hc$lcl, est)
#   # expect_identical(hc$lcl, hc$ucl)
# })
# 
# test_that("ssd_hc doesn't calculate cis with unequally weighted data", {
#   
#   data <- ssddata::ccme_boron
#   data$Weight <- rep(1, nrow(data))
#   data$Weight[1] <- 2
#   lifecycle::expect_defunct(fits <- ssd_fit_dists(data, weight = "Weight", dists = "lnorm"))
#   # expect_warning(
#   #   hc <- ssd_hc(fits, ci = TRUE, nboot = 10),
#   #   "^Parametric CIs cannot be calculated for unequally weighted data[.]$"
#   # )
#   # expect_identical(hc$se, NA_real_)
# })
# 
# test_that("ssd_hc no effect with higher weight one distribution", {
#   
#   data <- ssddata::ccme_boron
#   data$Weight <- rep(1, nrow(data))
#   lifecycle::expect_defunct(fits <- ssd_fit_dists(data, weight = "Weight", dists = "lnorm"))
#   # data$Weight <- rep(10, nrow(data))
#   # fits_10 <- ssd_fit_dists(data, weight = "Weight", dists = "lnorm")
#   # set.seed(10)
#   # hc <- ssd_hc(fits, ci = TRUE, nboot = 10)
#   # set.seed(10)
#   # hc_10 <- ssd_hc(fits_10, ci = TRUE, nboot = 10)
#   # expect_equal(hc_10, hc)
# })
# 
# test_that("ssd_hc effect with higher weight two distributions", {
#   data <- ssddata::ccme_boron
#   data$Weight <- rep(1, nrow(data))
#   lifecycle::expect_defunct(fits <- ssd_fit_dists(data, weight = "Weight", dists = c("lnorm", "llogis")))
#   # data$Weight <- rep(10, nrow(data))
#   # fits_10 <- ssd_fit_dists(data, weight = "Weight", dists = c("lnorm", "llogis"))
#   # set.seed(10)
#   # hc <- ssd_hc(fits, ci = TRUE, nboot = 10, multi_ci = FALSE, multi_est = FALSE, weighted = FALSE)
#   # set.seed(10)
#   # hc_10 <- ssd_hc(fits_10, ci = TRUE, nboot = 10, multi_ci = FALSE, multi_est = FALSE, weighted = FALSE)
#   # expect_equal(hc$est, 1.64903597051184)
#   # expect_equal(hc_10$est, 1.6811748398812)
#   # expect_equal(hc$se, 0.511475169043532)
#   # expect_equal(hc_10$se, 0.455819097122445)
# })
# 
# test_that("ssd_fit_dists all distributions fail to fit if Inf weight", {
#   data <- ssddata::ccme_boron
#   data$Mass <- rep(1, nrow(data))
#   data$Mass[1] <- Inf
#   lifecycle::expect_defunct(expect_error(
#     expect_warning(
#       ssd_fit_dists(data, weight = "Mass", dists = "lnorm"),
#       "^Distribution 'lnorm' failed to fit"
#     ),
#     "^All distributions failed to fit\\."
#   ))
# })
# 
# test_that("ssd_fit_dists not affected if all weight 1", {
#   data <- ssddata::ccme_boron
#   fits <- ssd_fit_dists(data, dists = "lnorm")
#   data$Mass <- rep(1, nrow(data))
#   lifecycle::expect_defunct(fits_right <- ssd_fit_dists(data, weight = "Mass", dists = "lnorm"))
#   #expect_equal(estimates(fits_right), estimates(fits))
# })
# 
# test_that("ssd_fit_dists not affected if all equal weight ", {
#   data <- ssddata::ccme_boron
#   fits <- ssd_fit_dists(data, dists = "lnorm")
#   data$Mass <- rep(0.1, nrow(data))
#   lifecycle::expect_defunct(fits_right <- ssd_fit_dists(data, weight = "Mass", dists = "lnorm"))
#   #  expect_equal(estimates(fits_right), estimates(fits))
# })
# 
# test_that("ssd_fit_dists gives correct chk error if zero weight", {
#   data <- ssddata::ccme_boron
#   data$Heavy <- rep(1, nrow(data))
#   data$Heavy[2] <- 0
#   lifecycle::expect_defunct(chk::expect_chk_error(
#     ssd_fit_dists(data, weight = "Heavy"),
#     "^`data` has 1 row with zero weight in 'Heavy'\\.$"
#   ))
# })
# 
# test_that("ssd_fit_dists gives chk error if negative weights", {
#   data <- ssddata::ccme_boron
#   data$Mass <- rep(1, nrow(data))
#   data$Mass[1] <- -1
#   lifecycle::expect_defunct(chk::expect_chk_error(ssd_fit_dists(data, weight = "Mass")))
# })
# 
# test_that("ssd_fit_dists gives chk error if missing weight values", {
#   data <- ssddata::ccme_boron
#   data$Mass <- rep(1, nrow(data))
#   data$Mass[1] <- NA
#   lifecycle::expect_defunct(chk::expect_chk_error(ssd_fit_dists(data, weight = "Mass")))
# })
# 
# test_that("ssd_fit_dists gives chk error if missing weight column", {
#   data <- ssddata::ccme_boron
#   lifecycle::expect_defunct(chk::expect_chk_error(ssd_fit_dists(data, weight = "Conc2")))
# })
