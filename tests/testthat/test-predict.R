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
  pred <- predict(boron_lnorm, nboot = 10)
  expect_is(pred, "tbl")
  expect_identical(colnames(pred), c("prop", "est", "se", "lcl", "ucl"))
  expect_identical(pred$prop, seq(0.01, 0.99, by = 0.01))
  pred2 <- predict(boron_lnorm, nboot = 10)
  expect_identical(pred$est[1], pred2$est[1])
})

test_that("predict.fitdists", {
  dists <- boron_dists[c("gamma", "gompertz")]
  class(dists) <- "fitdists"
  pred <- predict(dists, nboot = 10L)
  expect_is(pred, "tbl")
  expect_identical(colnames(pred), c("prop", "est", "se", "lcl", "ucl"))
  expect_identical(pred$prop, seq(0.01, 0.99, by = 0.01))

  pred <- predict(dists, nboot = 10L, average = FALSE)
  expect_is(pred, "tbl")
  expect_identical(colnames(pred), c("dist", "prop", "est", "se", "lcl", "ucl", "weight"))
  expect_identical(nrow(pred), 198L)
  expect_output(print(dists))
})

