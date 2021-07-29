#    Copyright 2015 Province of British Columbia
#
#    Licensed under the Apache License, Version 2.0 (the "License");
#    you may not use this file except in compliance with the License.
#    You may obtain a copy of the License at
#
#       https://www.apache.org/licenses/LICENSE-2.0
#
#    Unless required by applicable law or agreed to in writing, software
#    distributed under the License is distributed on an "AS IS" BASIS,
#    WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
#    See the License for the specific language governing permissions and
#    limitations under the License.

test_that("ssd_fit_dists gives error with unrecognized dist", {
  chk::expect_chk_error(ssd_fit_dists(ssdtools::boron_data, dists = "lnorm2"))
})

test_that("ssd_fit_dists gives chk error if insufficient data", {
  data <- ssdtools::boron_data[1:5,]
  chk::expect_chk_error(ssd_fit_dists(data))
})

test_that("ssd_fit_dists gives chk error if less than 6 rows of data", {
  data <- ssdtools::boron_data[1:5,]
  chk::expect_chk_error(ssd_fit_dists(data))
})

test_that("ssd_fit_dists gives chk error if less than required rows of data", {
  data <- ssdtools::boron_data
  chk::expect_chk_error(ssd_fit_dists(data, nrow = 29))
})

test_that("ssd_fit_dists gives chk error if missing left column", {
  data <- ssdtools::boron_data
  chk::expect_chk_error(ssd_fit_dists(data, left = "Conc2"))
})

test_that("ssd_fit_dists gives chk error if missing right column", {
  data <- ssdtools::boron_data
  chk::expect_chk_error(ssd_fit_dists(data, right = "Conc2"))
})

test_that("ssd_fit_dists gives chk error if missing weight column", {
  data <- ssdtools::boron_data
  chk::expect_chk_error(ssd_fit_dists(data, weight = "Conc2"))
})

test_that("ssd_fit_dists gives chk error if right call left", {
  data <- ssdtools::boron_data
  data$left <- data$Conc
  chk::expect_chk_error(ssd_fit_dists(data, right = "left"))
})

test_that("ssd_fit_dists gives chk error if left called right", {
  data <- ssdtools::boron_data
  data$right <- data$Conc
  chk::expect_chk_error(ssd_fit_dists(data, left = "right"))
})

test_that("ssd_fit_dists not happy with left as left by default", {
  data <- ssdtools::boron_data
  data$left <- data$Conc
  chk::expect_chk_error(ssd_fit_dists(data, left = "left"))
})

test_that("ssd_fit_dists returns object class fitdists", {
  fit <- ssd_fit_dists(ssdtools::boron_data, dists = c("lnorm", "llogis"),
                       rescale = FALSE)
  expect_s3_class(fit, "fitdists")
})

test_that("ssd_fit_dists happy with left as left but happy if right other", {
  data <- ssdtools::boron_data
  data$left <- data$Conc
  data$right <- data$Conc
  expect_s3_class(ssd_fit_dists(data, left = "left", right = "right"), "fitdists")
})

test_that("ssd_fit_dists not affected if all weight 1", {
  data <- ssdtools::boron_data
  fits <- ssd_fit_dists(data, dists = "lnorm")
  data$Mass <- rep(1, nrow(data))
  fits_right <- ssd_fit_dists(data, weight = "Mass", dists = "lnorm")
  expect_equal(estimates(fits_right), estimates(fits))
})

test_that("ssd_fit_dists not affected if all equal weight ", {
  data <- ssdtools::boron_data
  fits <- ssd_fit_dists(data, dists = "lnorm")
  data$Mass <- rep(0.1, nrow(data))
  fits_right <- ssd_fit_dists(data, weight = "Mass", dists = "lnorm")
  expect_equal(estimates(fits_right), estimates(fits))
})

test_that("ssd_fit_dists gives correct chk error if zero weight", {
  data <- ssdtools::boron_data
  data$Heavy <- rep(1, nrow(data))
  data$Heavy[2] <- 0
  chk::expect_chk_error(ssd_fit_dists(data, weight = "Heavy"),
                        "^`data` has 1 row with zero weight in 'Heavy'\\.$")
})

test_that("ssd_fit_dists gives chk error if negative weights", {
  data <- ssdtools::boron_data
  data$Mass <- rep(1, nrow(data))
  data$Mass[1] <- -1
  chk::expect_chk_error(ssd_fit_dists(data, weight = "Mass"))
})

test_that("ssd_fit_dists gives chk error if missing weight values", {
  data <- ssdtools::boron_data
  data$Mass <- rep(1, nrow(data))
  data$Mass[1] <- NA
  chk::expect_chk_error(ssd_fit_dists(data, weight = "Mass"))
})

test_that("ssd_fit_dists gives chk error if missing left values", {
  data <- ssdtools::boron_data
  data$Conc[1] <- NA
  chk::expect_chk_error(ssd_fit_dists(data),
                        "^`data` has 1 row with effectively missing values in 'Conc'\\.$")
})

test_that("ssd_fit_dists gives chk error if 0 left values", {
  data <- ssdtools::boron_data
  data$Conc[1] <- 0
  chk::expect_chk_error(ssd_fit_dists(data),
                        "^`data` has 1 row with effectively missing values in 'Conc'\\.$")
})

test_that("ssd_fit_dists all distributions fail to fit if Inf weight", {
  data <- ssdtools::boron_data
  data$Mass <- rep(1, nrow(data))
  data$Mass[1] <- Inf
  expect_error(
    expect_warning(
      ssd_fit_dists(data, weight = "Mass", dists = "lnorm"), 
      "^Distribution 'lnorm' failed to fit"), 
    "^All distributions failed to fit\\.")
})

test_that("ssd_fit_dists not affected if right values identical to left but in different column", {
  data <- ssdtools::boron_data
  fits <- ssd_fit_dists(data, dists = "lnorm")
  data$Other <- data$Conc
  fits_right <- ssd_fit_dists(data, right = "Other", dists = "lnorm")
  expect_equal(estimates(fits_right), estimates(fits))
})

test_that("ssd_fit_dists gives correct chk error if missing values in non-censored data", {
  data <- ssdtools::boron_data
  data$Conc[2] <- NA 
  chk::expect_chk_error(ssd_fit_dists(data),
                        "^`data` has 1 row with effectively missing values in 'Conc'\\.$")
})

test_that("ssd_fit_dists gives correct chk error if missing values in censored data", {
  data <- ssdtools::boron_data
  data$Other <- data$Conc
  data$Other[1] <- data$Conc[1] + 0.1 # to make censored
  data$Conc[2:3] <- NA
  data$Other[2:3] <- NA
  chk::expect_chk_error(ssd_fit_dists(data, right = "Other"),
                        "^`data` has 2 rows with effectively missing values in 'Conc' and 'Other'\\.$")
})

test_that("ssd_fit_dists gives chk error if negative left ", {
  data <- ssdtools::boron_data
  data$Conc[1] <- -1
  chk::expect_chk_error(ssd_fit_dists(data))
})

test_that("ssd_fit_dists all distributions fail to fit if Inf left", {
  data <- ssdtools::boron_data
  data$Conc[1] <- Inf
  expect_error(
      ssd_fit_dists(data, dists = "lnorm"), 
    "^`data` has 1 row with effectively missing values in 'Conc'\\.")
})

test_that("ssd_fit_dists gives correct chk error any right < left", {
  data <- ssdtools::boron_data
  data$Other <- data$Conc
  data$Other[2] <- data$Conc[1] / 2
  chk::expect_chk_error(ssd_fit_dists(data, right = "Other"),
                        "^`data\\$Other` must have values greater than or equal to `data\\$Conc`\\.$")
})

test_that("ssd_fit_dists warns to rescale data", {
  data <- data.frame(Conc = rep(2, 6))
  expect_error(
    expect_warning(ssd_fit_dists(data, dist = "lnorm", , rescale = FALSE),
                   "^Distribution 'lnorm' failed to fit \\(try rescaling data\\):")
  )
})

test_that("ssd_fit_dists doesn't warns to rescale data if already rescaled", {
  data <- data.frame(Conc = rep(2, 6))
  expect_error(expect_warning(ssd_fit_dists(data, rescale = TRUE, dist = "lnorm"), 
                              regexp = "^Distribution 'lnorm' failed to fit:"))
})

test_that("ssd_fit_dists warns of optimizer convergence code error", {
  data <- ssdtools::boron_data
  expect_error(
    expect_warning(ssd_fit_dists(data, control = list(maxit = 1) , dist = "lnorm"), 
                   regexp = "^Distribution 'lnorm' failed to converge \\(try rescaling data\\): Iteration limit maxit reach \\(try increasing the maximum number of iterations in control\\)\\.$")
  )
})

test_that("ssd_fit_dists estimates for ssdtools::boron_data on stable dists", {
  fits <- ssd_fit_dists(ssdtools::boron_data, dists = ssd_dists(), rescale = TRUE)
  
  tidy <- tidy(fits)
  expect_s3_class(tidy, "tbl")
  expect_snapshot_data(tidy, "tidy_stable_rescale")
})

test_that("ssd_fit_dists not reorder", {
  fit <- ssd_fit_dists(ssdtools::boron_data, dists = c("lnorm", "llogis"),
                       rescale = FALSE)

  expect_identical(npars(fit), c(lnorm = 2L, llogis = 2L))
  expect_equal(logLik(fit), c(lnorm = -117.514216489547, llogis = -118.507435324581))
})

test_that("ssd_fit_dists equal weights no effect", {
  boron_dists <- ssd_fit_dists(ssdtools::boron_data)
  data <- ssdtools::boron_data
  data$weight <- rep(2, nrow(data))
  fits <- ssd_fit_dists(ssdtools::boron_data, dists = names(boron_dists))
  
  expect_equal(estimates(fits), estimates(boron_dists))
})

test_that("ssd_fit_dists doubling data little effect on estimates stable dists", {
  data <- ssdtools::boron_data
  fits <- ssd_fit_dists(data, dists = ssd_dists("stable"))
  data2 <- rbind(data, data)
  fits2 <- ssd_fit_dists(data2, dists = ssd_dists("stable"))
  expect_equal(estimates(fits2), estimates(fits), tolerance = 1e-04)
})

test_that("ssd_fit_dists weighting data equivalent to replicating on stable dists", {
  data <- ssdtools::boron_data
  data$Times <- rep(1, nrow(data)) 
  data$Times[1] <- 10
  fits <- ssd_fit_dists(data, weight = "Times", dists = ssd_dists())
  data <- data[rep(1:nrow(data), data$Times),]
  fits_times <- ssd_fit_dists(data, dists = ssd_dists())
  skip_on_ci() # not sure why gamma shape not working on windows and linux on github actions
  expect_equal(estimates(fits_times), estimates(fits), tolerance = 1e-05)
})

test_that("ssd_fit_dists computable = TRUE allows for fits without standard errors", {
  data <- ssdtools::boron_data
  data$Other <- data$Conc
  data$Conc <- data$Conc / max(data$Conc)
  
  expect_warning(
    ssd_fit_dists(data, right = "Other", dists = ssd_dists(), rescale = FALSE),
    "^Distribution 'lgumbel' failed to compute standard errors \\(try rescaling data\\)\\.$")
  
  skip_on_os("windows") # not sure why gamma shape is 908 on GitHub actions windows
  skip_on_os("linux") # not sure why gamma shape is 841 on GitHub actions ubuntu
  fits <- ssd_fit_dists(data, right = "Other", dists = ssd_dists(), rescale = FALSE, computable = FALSE)
  
  tidy <- tidy(fits)
  expect_s3_class(tidy, "tbl")
  expect_snapshot_data(tidy, "tidy_stable_computable")
})

test_that("ssd_fit_dists works with slightly censored data", {
  data <- ssdtools::boron_data
  
  data$right <- data$Conc * 2
  data$Conc <- data$Conc * 0.5
  
  fits <- ssd_fit_dists(data, dists = "lnorm", right = "right", rescale = FALSE)
  
  tidy <- tidy(fits)
  
  expect_equal(tidy$est, c(2.56052524750529, 1.17234562953404))
  expect_equal(tidy$se, c(0.234063281091344, 0.175423555900586))
})

test_that("ssd_fit_dists accepts 0 for left censored data", {
  data <- ssdtools::boron_data
  
  data$right <- data$Conc
  data$Conc[1] <- 0
  
  fits <- ssd_fit_dists(data, dists = "lnorm", right = "right", rescale = FALSE)
  
  tidy <- tidy(fits)
  
  expect_equal(tidy$est, c(2.54093502870563, 1.27968456496323))
  expect_equal(tidy$se, c(0.242558677928804, 0.175719927258761))
})

test_that("ssd_fit_dists gives same values with zero and missing left values", {
  data <- ssdtools::boron_data
  
  data$right <- data$Conc
  data$Conc[1] <- 0
  
  fits0 <- ssd_fit_dists(data, dists = "lnorm", right = "right")
  
  data$Conc[1] <- NA
  
  fitsna <- ssd_fit_dists(data, dists = "lnorm", right = "right")
  
  expect_equal(tidy(fits0), tidy(fitsna))
})

test_that("ssd_fit_dists works with right censored data", {
  data <- ssdtools::boron_data
  
  data$right <- data$Conc
  data$right[1] <- Inf
  
  expect_error(fits <- ssd_fit_dists(data, dists = "lnorm", right = "right"),
               "^Distributions cannot currently be fitted to right censored data\\.$")
  
  # 
  # tidy <- tidy(fits)
  # 
  # expect_equal(tidy$est, c(2.54093502870563, 1.27968456496323))
  # expect_equal(tidy$se, c(0.242558677928804, 0.175719927258761))
})

test_that("ssd_fit_dists gives same answer for missing versus Inf right", {
  data <- ssdtools::boron_data
  
  data$right <- data$Conc
  data$right[1] <- Inf
  
  expect_error(fits <- ssd_fit_dists(data, dists = "lnorm", right = "right"),
               "^Distributions cannot currently be fitted to right censored data\\.$")
  
  data$right[1] <- NA
  
  expect_error(fits <- ssd_fit_dists(data, dists = "lnorm", right = "right"),
               "^Distributions cannot currently be fitted to right censored data\\.$")
  
  # fits0 <- ssd_fit_dists(data, dists = "lnorm", right = "right")
  # 
  # data$right[1] <- NA
  # 
  # fitsna <- ssd_fit_dists(data, dists = "lnorm", right = "right")
  # 
  # expect_equal(tidy(fits0), tidy(fitsna))
})
