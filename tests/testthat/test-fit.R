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

test_that("ssd_fit_dists gives same result as previously with boron_data and lnorm", {
  data <- ssdtools::boron_data
  fits <- ssd_fit_dists(data, dists = "lnorm")
  skip_if_not(capabilities("long.double"))
  expect_equal(estimates(fits), estimates(boron_lnorm))
})

test_that("ssd_fit_dists gives error with unrecognized dist", {
  chk::expect_chk_error(ssd_fit_dists(ssdtools::boron_data, dists = "lnorm2"))
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

test_that("ssd_fit_dists all distributions fail to fit if Inf weight", {
  data <- ssdtools::boron_data
  data$Mass <- rep(1, nrow(data))
  data$Mass[1] <- Inf
  expect_error(expect_warning(ssd_fit_dists(data, weight = "Mass"), "^All distributions failed to fit\\."))
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
                        "^`data` has 1 row with missing values in 'Conc'\\.$")
})

test_that("ssd_fit_dists gives correct chk error if missing values in censored data", {
  data <- ssdtools::boron_data
  data$Other <- data$Conc
  data$Other[1] <- data$Conc[1] + 0.1 # to make censored
  data$Conc[2:3] <- NA
  data$Other[2:3] <- NA
  chk::expect_chk_error(ssd_fit_dists(data, right = "Other"),
                        "^`data` has 2 rows with missing values in 'Conc' and 'Other'\\.$")
})

test_that("ssd_fit_dists gives chk error if zero left ", {
  data <- ssdtools::boron_data
  data$Conc[1] <- 0
  chk::expect_chk_error(expect_warning(ssd_fit_dists(data)))
})

test_that("ssd_fit_dists gives chk error if negative left ", {
  data <- ssdtools::boron_data
  data$Conc[1] <- -1
  chk::expect_chk_error(ssd_fit_dists(data))
})

test_that("ssd_fit_dists all distributions fail to fit if Inf left", {
  data <- ssdtools::boron_data
  data$Conc[1] <- Inf
  expect_error(expect_warning(ssd_fit_dists(data), "^All distributions failed to fit\\."))
})

test_that("ssd_fit_dists gives correct chk error any right < left", {
  data <- ssdtools::boron_data
  data$Other <- data$Conc
  data$Other[2] <- data$Conc[1] / 2
  chk::expect_chk_error(ssd_fit_dists(data, right = "Other"),
                        "^`data\\$Other` must have values greater than or equal to `data\\$Conc`\\.$")
})

# test_that("ssd_fit_dists gives chk error if missing weight column", {
#   data <- ssdtools::boron_data
#   chk::expect_chk_error(ssd_fit_dists(data, weight = "Conc2"))
# })


test_that("fit_dist tiny llogis", {
  data <- ssdtools::boron_data
  fit <- ssd_fit_dists(data, dists = "llogis")
  expect_equal(
    estimates(fit$llogis),
    list(locationlog = 2.62627762517872, scalelog = 0.740423704979968),
    tolerance = 1e-05
  )
  
  data$Conc <- data$Conc / 100
  fit <- ssd_fit_dists(data, dists = "llogis")
  expect_equal(
    estimates(fit$llogis),
    list(locationlog = -1.97889256080937, scalelog = 0.740423704979968),
    tolerance = 1e-05
    )
})

test_that("fit_dists", {
  rlang::scoped_options(lifecycle_verbosity = "quiet")
  dist_names <- c(
    "gamma", "lgumbel",
    "llogis", "lnorm", "weibull"
  )
  expect_error(expect_warning(ssd_fit_dists(boron_data[1:5, ], dists = dist_names)), "^`nrow[(]`data`[)]` must be between 6 and Inf, not 5\\.$")
  dists <- ssd_fit_dists(boron_data[1:6, ], dists = dist_names)
  expect_true(is.fitdists(dists))
  expect_identical(names(dists), c("gamma", "lgumbel", "llogis", "lnorm", "weibull"))
  coef <- estimates(dists)
  expect_identical(names(coef), c("gamma", "lgumbel", "llogis", "lnorm", "weibull"))
})

test_that("fit_dist", {
  skip_if_not(capabilities("long.double"))

  dists <- ssd_fit_dists(boron_data, dists = "lnorm")
  expect_equal(estimates(dists), estimates(boron_lnorm))

  boron_data2 <- boron_data[rev(order(boron_data$Conc)), ]
  boron_data2$Weight <- 1:nrow(boron_data2)

  dists <- ssd_fit_dists(boron_data2, weight = "Weight", dists = "lnorm")
  expect_equal(estimates(dists$lnorm), list(meanlog = 1.87970902859779, sdlog = 1.12770658163393),
               tolerance = 1e-06)
})

test_that("fluazinam", {
  # data(fluazinam, package = "fitdistrplus")
  # dist <- ssd_fit_dist(fluazinam, left = "left")
  # expect_true(is.tmbfit(dist))
  # expect_false(is.fitdistcens(dist))
  # expect_equal(coef(dist), c(meanlog = 4.66057985615203, sdlog = 2.19746964708252))
  # 
  # dist <- ssd_fit_dist(fluazinam, left = "left", right = "right")
  # expect_false(is.tmbfit(dist))
  # expect_true(is.fitdistcens(dist))
  # expect_equal(coef(dist), c(meanlog = 4.97758390559042, sdlog = 2.68757112403832))
  # 
  # fluazinam2 <- fluazinam[rev(order(fluazinam$left)), ]
  # fluazinam2$Weight <- 1:nrow(fluazinam2)
  # 
  # expect_warning(dist <- ssd_fit_dists(fluazinam2,
  #                                      weight = "Weight", left = "left", right = "right",
  #                                      dist = "lnorm"
  # ), "weights are not taken into account in the default initial values")
  # expect_identical(class(dist), c("fitdistscens", "fitdists"))
  # dist <- dist[[1]]
  # expect_false(is.tmbfit(dist))
  # expect_true(is.fitdistcens(dist))
  # expect_equal(coef(dist), c(meanlog = 3.56609317317434, sdlog = 2.18316425603543))
})


test_that("ssd_dists() errors with missing values in both left and right", {
  data <- data.frame(left = c(1:7), right = c(2:8))
  dists <- ssd_dists()
  expect_warning(fits <- ssd_fit_dists(ssdtools::boron_data, dists = dists))
  dists <- dists[!dists %in% "burrIII3"]
  expect_identical(names(fits), dists)
  
  fits <- subset(fits, dists[!dists %in% c("gompertz")])
  
  set.seed(101) # for gompertz
  expect_equal(
    estimates(fits),
    list(gamma = list(scale = 25.1268319779061, shape = 0.950179460431249), 
         lgumbel = list(locationlog = 1.92263082409711, scalelog = 1.23223883525026), 
         llogis = list(locationlog = 2.62627625930417, scalelog = 0.740426376456358), 
         lnorm = list(meanlog = 2.56164496371788, sdlog = 1.24154032419128), 
         mx_llogis_llogis = list(locationlog1 = 0.896785336771335, 
                                 locationlog2 = 3.14917770255953, pmix = 0.255223497712533, 
                                 scalelog1 = 0.317650881482978, scalelog2 = 0.496708998267848), 
         weibull = list(scale = 23.5139783002509, shape = 0.966099901938021)))
})

test_that("fit_dists computable", {
  data <- data.frame(Conc = c(
    0.1, 0.12, 0.24, 0.42, 0.67,
    0.78, 120, 2030, 9033, 15000,
    15779, 20000, 31000, 40000, 105650
  ))
  
  skip_if_not(capabilities("long.double"))
  
  # expect_warning(fit <- ssd_fit_dists(data, dists = "gamma", computable = FALSE, silent = TRUE)[[1]],
  #                "diag[(][.][)] had 0 or NA entries; non-finite result is doubtful")
  # expect_equal(fit$sd["shape"], c(shape = 0.0414094229126189))
  # expect_equal(fit$estimate, c(scale = 96927.0337948105, shape = 0.164168623820564))
  # 
  # data$Conc <- data$Conc / 100
  # fit <- ssd_fit_dists(data, dists = "gamma")[[1]]
  # expect_equal(fit$sd["scale"], c(scale = 673.801371511101))
  # expect_equal(fit$sd["shape"], c(shape = 0.0454275860604086))
  # expect_equal(fit$estimate, c(scale = 969.283015870555, shape = 0.16422716021172))
})

# test_that("fit_dists fail to converge when identical data", {
#   data <- data.frame(Conc = rep(6, 6))
#   expect_output(expect_error(expect_warning(fit <- ssd_fit_dists(data), "All distributions failed to fit.")))
# })
