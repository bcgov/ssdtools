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

context("predict")

test_that("predict.fitdist", {
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
  expect_equal(pred3$est[1], pred2$est[1] / 1000)
})

test_that("predict.fitdist parallel", {
  boron_lnorm <- ssdtools:::ssd_fit_dist(ssdtools::boron_data)

  pred <- predict(boron_lnorm, nboot = 10L, parallel = "multicore", ncpus = 2)
  expect_is(pred, "tbl")
  expect_identical(colnames(pred), c("percent", "est", "se", "lcl", "ucl", "dist"))
  expect_equal(pred$percent, 1:99)
})

test_that("predict.fitdists", {
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
  boron_lnorm <- ssd_fit_dists(ssdtools::boron_data, dists = c("gamma", "gompertz"))

  pred <- predict(boron_lnorm, nboot = 10L, parallel = "multicore", ncpus = 2)
  expect_is(pred, "tbl")
  expect_identical(colnames(pred), c("percent", "est", "se", "lcl", "ucl", "dist"))
  expect_equal(pred$percent, 1:99)
})

test_that("predict.fitdistscens", {
  expect_equal(as.data.frame(predict(ssdtools::fluazinam_dists, percent = c(1,99))), 
               structure(list(percent = c(1, 99), est = c(0.165191855589344, 
74931.0016372917), se = c(NA_real_, NA_real_), lcl = c(NA_real_, 
NA_real_), ucl = c(NA_real_, NA_real_), dist = c("average", "average"
)), class = "data.frame", row.names = c(NA, -2L)))
})

test_that("predict.fitdistscens cis", {
  set.seed(77)
  expect_equal(as.data.frame(predict(ssdtools::fluazinam_dists, percent = c(1,99),
                                     ci = TRUE, average = FALSE, nboot = 10)), 
               structure(list(percent = c(1, 99, 1, 99, 1, 99), est = c(0.0556070303830483, 
93128.5004982232, 0.00297074136543809, 6884.80066910368, 0.279206726612854, 
75330.7588691179), se = c(1.07296504986295, 1272681.81740671, 
0.872766260156123, 6345.89256418346, 3.45777933776596, 85956.7343517397
), lcl = c(0.00124359669989287, 19577.9878196641, 0.000259260753867323, 
2709.72803943194, 0.0485617987224599, 15976.8461419439), ucl = c(2.83621750264073, 
3440879.02972863, 2.21539429115628, 20960.9973187754, 9.29978158602369, 
252695.315652253), dist = c("burrIII2", "burrIII2", "gamma", 
"gamma", "lnorm", "lnorm")), row.names = c(NA, -6L), class = "data.frame"))
})

