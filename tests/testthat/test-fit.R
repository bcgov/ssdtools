#    Copyright 2015 Province of British Columbia
#
#    Licensed under the Apache License, Version 2.0 (the "License");
#    you may not use this file except in compliance with the License.
#    You may obtain a copy of the License at
#
#       http://www.apache.org/licenses/LICENSE-2.0
#
#    Unless required by applicable law or agreed to in writing, software
#    distributed under the License is distributed on an "AS IS" BASIS,
#    WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
#    See the License for the specific language governing permissions and
#    limitations under the License.


test_that("fit_dist", {
  dist <- ssd_fit_dist(ssdtools::boron_data)
  expect_true(is.fitdist(dist))
  expect_equal(dist, boron_lnorm)
})

test_that("fit_dist tiny llogis", {
  data <- ssdtools::boron_data
  fit <- ssdtools:::ssd_fit_dist(data, dist = "llogis")
  expect_equal(
    fit$estimate,
    c(locationlog = 2.6261248978507, scalelog = 0.740309228071107)
  )

  data$Conc <- data$Conc / 100
  fit <- ssdtools:::ssd_fit_dist(data, dist = "llogis")
  expect_equal(
    fit$estimate,
    c(locationlog = -1.97890271677598, scalelog = 0.740452665894763
    )
  )
})

test_that("fit_dists", {
  rlang::scoped_options(lifecycle_verbosity = "quiet")
  dist_names <- c(
    "gamma", "gompertz", "lgumbel",
    "llogis", "lnorm", "pareto", "weibull"
  )
  expect_error(expect_warning(ssd_fit_dists(boron_data[1:5, ], dists = dist_names)), "^All distributions failed to fit[.]$")
  dists <- ssd_fit_dists(boron_data[1:6, ], dists = dist_names)
  expect_true(is.fitdists(dists))
  expect_identical(names(dists), dist_names)
  coef <- coef(dists)
  expect_identical(names(coef), dist_names)
})

test_that("burrIII2", {
  rlang::scoped_options(lifecycle_verbosity = "quiet")
  dists <- ssd_fit_dists(boron_data[1:6, ], dists = c("burrIII2", "gamma", "lnorm"))
  expect_identical(names(dists), c("burrIII2", "gamma", "lnorm"))
  expect_equal(coef(dists$burrIII2), c(locationlog = 1.8357959974758, scalelog = 0.547213918037133
  ))
})

test_that("fit_dist", {
  expect_error(ssd_fit_dist(boron_data[1:5, ]), "^`nrow[(]data[)]` must be greater than or equal to 6, not 5[.]$", c("chk_error", "rlang_error", "error", "condition"))
  dist <- ssd_fit_dist(boron_data)
  expect_true(is.fitdist(dist))
  expect_equal(dist, boron_lnorm)
  expect_equal(coef(dist), c(meanlog = 2.56164375310683, sdlog = 1.24172540661694))

  boron_data2 <- boron_data[rev(order(boron_data$Conc)), ]
  boron_data2$Weight <- 1:nrow(boron_data2)

  expect_warning(dist <- ssd_fit_dist(boron_data2, weight = "Weight"), "weights are not taken into account in the default initial values")
  expect_true(is.fitdist(dist))
  expect_equal(coef(dist), c(meanlog = 1.87960101694348, sdlog = 1.12780324755743))
})

test_that("fluazinam", {
  data(fluazinam, package = "fitdistrplus")
  dist <- ssdtools:::ssd_fit_dist(fluazinam, left = "left")
  expect_true(is.fitdist(dist))
  expect_false(is.fitdistcens(dist))
  expect_equal(coef(dist), c(meanlog = 4.66057985615203, sdlog = 2.19746964708252))

  dist <- ssdtools:::ssd_fit_dist(fluazinam, left = "left", right = "right")
  expect_false(is.fitdist(dist))
  expect_true(is.fitdistcens(dist))
  expect_equal(coef(dist), c(meanlog = 4.97758390559042, sdlog = 2.68757112403832))

  fluazinam2 <- fluazinam[rev(order(fluazinam$left)), ]
  fluazinam2$Weight <- 1:nrow(fluazinam2)

  expect_warning(dist <- ssd_fit_dists(fluazinam2,
    weight = "Weight", left = "left", right = "right",
    dist = "lnorm"
  ), "weights are not taken into account in the default initial values")
  expect_identical(class(dist), c("fitdistscens", "fitdists"))
  dist <- dist[[1]]
  expect_false(is.fitdist(dist))
  expect_true(is.fitdistcens(dist))
  expect_equal(coef(dist), c(meanlog = 3.56609317317434, sdlog = 2.18316425603543))
})


test_that("fit_dists computable", {
  data <- data.frame(Conc = c(
    0.1, 0.12, 0.24, 0.42, 0.67,
    0.78, 120, 2030, 9033, 15000,
    15779, 20000, 31000, 40000, 105650
  ))

  # gamma converging on noLD systems!
  #  expect_error(
  #    ssd_fit_dists(data, dists = "gamma"),
  #    "^All distributions failed to fit[.]$"
  #  )

  expect_warning(fit <- ssd_fit_dists(data, dists = "gamma", computable = FALSE, silent = TRUE)[[1]],
                 "diag[(][.][)] had 0 or NA entries; non-finite result is doubtful")
  #  expect_equal(fit$sd["scale"], c(scale = NaN)) fitting on noLD!
  expect_equal(fit$sd["shape"], c(shape = 0.0414094229126189), tolerance = 0.0003) # for noLD
  expect_equal(fit$estimate, c(scale = 96927.0337948105, shape = 0.164168623820564))

  data$Conc <- data$Conc / 100
  fit <- ssd_fit_dists(data, dists = "gamma")[[1]]
  expect_equal(fit$sd["scale"], c(scale = 673.801371511101), tolerance = 3e-01) # for noLD
  expect_equal(fit$sd["shape"], c(shape = 0.0454275860604086), tolerance = 3e-06) # for noLD
  expect_equal(fit$estimate, c(scale = 969.283015870555, shape = 0.16422716021172))
})

test_that("fit_dists fail to converge when identical data", {
  data <- data.frame(Conc = rep(6, 6))
  expect_output(expect_error(expect_warning(fit <- ssd_fit_dists(data), "All distributions failed to fit.")))
})
