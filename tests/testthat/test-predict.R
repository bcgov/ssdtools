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

test_that("predict.fitdist", {
  rlang::scoped_options(lifecycle_verbosity = "quiet")

  boron_lnorm <- ssdtools:::ssd_fit_dist(ssdtools::boron_data[1:6, ])
  pred <- predict(boron_lnorm, nboot = 10L)

  expect_is(pred, "tbl")
  expect_identical(colnames(pred), c("percent", "est", "se", "lcl", "ucl", "dist"))
  expect_equal(pred$percent, 1:99)
  pred2 <- predict(boron_lnorm, ci = TRUE, nboot = 10)
  expect_identical(pred$est[1], pred2$est[1])

  boron_data$Conc <- boron_data$Conc / 1000
  boron_lnorm3 <- ssdtools:::ssd_fit_dist(boron_data[1:6, ])
  pred3 <- predict(boron_lnorm3, nboot = 10)
  expect_equal(pred3$est[1], pred2$est[1] / 1000, tolerance = 1e-07)
})

test_that("predict.fitdist parallel", {
  rlang::scoped_options(lifecycle_verbosity = "quiet")
  boron_lnorm <- ssdtools:::ssd_fit_dist(ssdtools::boron_data)

  pred <- predict(boron_lnorm, nboot = 10L, parallel = "multicore", ncpus = 2)
  expect_is(pred, "tbl")
  expect_identical(colnames(pred), c("percent", "est", "se", "lcl", "ucl", "dist"))
  expect_equal(pred$percent, 1:99)
})

test_that("predict.fitdists", {
  rlang::scoped_options(lifecycle_verbosity = "quiet")
  dists <- ssd_fit_dists(boron_data[1:6, ], dists = c("gamma", "gompertz"))
  pred <- predict(dists, nboot = 10L)

  expect_is(pred, "tbl")
  expect_identical(colnames(pred), c("percent", "est", "se", "lcl", "ucl", "dist"))
  expect_equal(pred$percent, 1:99)

  pred <- predict(dists, average = FALSE)
  expect_is(pred, "tbl")
  expect_identical(colnames(pred), c("percent", "est", "se", "lcl", "ucl", "dist"))
  expect_identical(nrow(pred), 198L)
  expect_output(print(dists))
})

test_that("predict.fitdists parallel", {
  rlang::scoped_options(lifecycle_verbosity = "quiet")
  boron_lnorm <- ssd_fit_dists(ssdtools::boron_data, dists = c("gamma", "gompertz"))

  pred <- predict(boron_lnorm, nboot = 10L, parallel = "multicore", ncpus = 2)
  expect_is(pred, "tbl")
  expect_identical(colnames(pred), c("percent", "est", "se", "lcl", "ucl", "dist"))
  expect_equal(pred$percent, 1:99)
})

test_that("predict.fitdistscens", {
  rlang::scoped_options(lifecycle_verbosity = "quiet")
  pred <- predict(ssdtools::fluazinam_dists, percent = c(1, 99))
  expect_equal(
    as.data.frame(pred),
    structure(list(percent = c(1, 99), est = c(0.17492159186823, 
                                               126047.20928158), se = c(NA_real_, NA_real_), lcl = c(NA_real_, 
                                                                                                     NA_real_), ucl = c(NA_real_, NA_real_), dist = c("average", "average"
                                                                                                     )), row.names = c(NA, -2L), class = "data.frame")
  )
})

test_that("predict.fitdistscens cis", {
  set.seed(77)
  pred <- predict(ssdtools::fluazinam_dists,
    percent = c(1, 99),
    ci = TRUE, average = FALSE, nboot = 10
  )
  expect_identical(colnames(pred), c("percent", "est", "se", "lcl", "ucl", "dist"))
  expect_identical(pred$percent, c(1, 99, 1, 99, 1, 99))
  expect_equal(
    pred$est,
    c(0.0947064911703993, 212423.73904855, 0.00297074136543809, 6884.80066910368, 
      0.279531171923962, 75343.2242506558)
  )
  expect_identical(pred$dist, c(
    "llogis", "llogis", "gamma",
    "gamma", "lnorm", "lnorm"
  ))
})
