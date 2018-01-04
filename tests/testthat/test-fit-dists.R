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
  dist_names <- c("burr", "lnorm", "llog", "gompertz", "lgumbel", "pareto", "gamma", "weibull")
  dists <- ssd_fit_dists(ccme_data$Conc[ccme_data$Chemical == "Boron"], dist_names)

  expect_identical(names(dists), dist_names)
  aic <- AIC(dists)
  expect_identical(rownames(aic), dist_names)
  expect_identical(aic$df, c(3L,2L,2L,2L,2L,1L,2L,2L))
  expect_equal(aic$AIC[2], 239.0284, tolerance = 0.000001)
  dist1 <- dists[c("burr", "lnorm", "llog", "gompertz")]
  dist2 <- dists[c("lgumbel", "pareto", "gamma", "weibull")]
  class(dist1) <- "fitdists"
  class(dist2) <- "fitdists"
  expect_identical(AIC(dist1, dist2), aic)
  bic <- BIC(dist1, dist2)
  expect_identical(rownames(bic), dist_names)
  expect_identical(colnames(bic), c("df", "BIC"))
  aicc <- AICc(dist1, dist2)
  expect_identical(rownames(aicc), dist_names)
  expect_identical(colnames(aicc), c("df", "AICc"))
})
