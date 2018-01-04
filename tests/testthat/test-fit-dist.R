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

context("fit-dist")

test_that("fit_dist", {
  dist <- ssd_fit_dist(ccme_data$Conc[ccme_data$Chemical == "Boron"], "lnorm")

  expect_is(dist, "fitdist")

  expect_equal(AIC(dist), 239.0284, tolerance = 0.000001)
  expect_equal(AICc(dist), 239.5084, tolerance = 0.000001)
  expect_equal(BIC(dist), 241.6928, tolerance = 0.000001)

  dist3 <- dist
  aic <-  AIC(dist, dist2 = dist3)
  expect_is(aic, "data.frame")
  expect_equal(aic$AIC, c(239.0284, 239.0284), tolerance = 0.000001)
  expect_identical(aic$df, c(2L, 2L))
  expect_identical(colnames(aic), c("df", "AIC"))
  expect_identical(rownames(aic), c("dist", "dist2"))

  aic <-  AIC(dist, dist3)
  expect_identical(rownames(aic), c("dist", "dist3"))
  aic <-  AIC(object = dist, dist3)
  expect_identical(rownames(aic), c("dist", "dist3"))

  pred <- predict(dist)
  expect_is(pred, "tbl")
  expect_identical(colnames(pred), c("prob", "est", "se", "lcl", "ucl"))
  expect_identical(pred$prob, seq(0.01, 0.99, by = 0.02))
})
