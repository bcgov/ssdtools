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

context("fit-dists")

test_that("fit_dists", {
  dist_names <- ssd_dists(all = TRUE)
  dists <- ssd_fit_dists(ccme_data$Concentration[ccme_data$Chemical == "Boron"], dist_names)

  expect_true(is_fitdists(dists))

  expect_identical(names(dists), dist_names)
  aic <- AIC(dists)
  expect_identical(rownames(aic), dist_names)
  expect_identical(aic$df, c(3L,2L,2L,2L,2L,2L,1L,2L))
  expect_equal(aic["lnorm", "AIC"], 239.0284, tolerance = 0.000001)
  dist1 <- dists[ssd_dists()]
  dist2 <- dists[setdiff(ssd_dists(all = TRUE), ssd_dists())]
  class(dist1) <- "fitdists"
  class(dist2) <- "fitdists"
  aic2 <- AIC(dist1, dist2)
  expect_identical(aic2[order(rownames(aic2)),], aic)
  bic <- BIC(dist1, dist2)
  expect_identical(rownames(bic), rownames(aic2))
  expect_identical(colnames(bic), c("df", "BIC"))
  aicc <- AICc(dist1, dist2)
  expect_identical(rownames(aicc), rownames(aic2))
  expect_identical(colnames(aicc), c("df", "AICc"))

  dist3 <- dists[c("gamma", "gompertz")]
  class(dist3) <- "fitdists"
  pred <- predict(dist3, nboot = 10L)
  expect_is(pred, "tbl")
  expect_identical(colnames(pred), c("prob", "est", "se", "lcl", "ucl"))
  expect_identical(pred$prob, seq(0.01, 0.99, by = 0.02))

  pred <- predict(dist3, nboot = 10L, average = FALSE)
  expect_is(pred, "tbl")
  expect_identical(colnames(pred), c("dist", "prob", "est", "se", "lcl", "ucl", "weight"))
  expect_identical(nrow(pred), 100L)
  expect_output(print(dists))
})
