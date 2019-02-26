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
  boron_data <- ssdtools::boron_data
  boron_lnorm <- ssd_fit_dist(boron_data[1:6,])
  pred <- predict(boron_lnorm, nboot = 10L)
  expect_is(pred, "tbl")
  expect_identical(colnames(pred), c("percent", "est", "se", "lcl", "ucl"))
  expect_identical(pred$percent, 1:99)
  pred2 <- predict(boron_lnorm, nboot = 10)
  expect_identical(pred$est[1], pred2$est[1])
  
  boron_data$Conc <- boron_data$Conc / 1000
  boron_lnorm3 <- ssd_fit_dist(boron_data[1:6,])
  pred3 <- predict(boron_lnorm3, nboot = 10)
  expect_equal(pred3$est[1], pred2$est[1]/1000)
})

test_that("predict.fitdists", {
  dists <- ssd_fit_dists(boron_data[1:6,], dists = c("gamma", "gompertz"))
  pred <- predict(dists, nboot = 10L)
  expect_is(pred, "tbl")
  expect_identical(colnames(pred), c("percent", "est", "se", "lcl", "ucl"))
  expect_identical(pred$percent, 1:99)

  pred <- predict(dists, nboot = 10L, average = FALSE)
  expect_is(pred, "tbl")
  expect_identical(colnames(pred), c("dist", "percent", "est", "se", "lcl", "ucl", "weight"))
  expect_identical(nrow(pred), 198L)
  expect_output(print(dists))
})
