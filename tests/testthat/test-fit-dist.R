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
  dist <- ssd_fit_dist(ccme_data$Concentration[ccme_data$Chemical == "Boron"], "lnorm")

  expect_is(dist, "fitdist")

  pred <- predict(dist, nboot = 10)
  expect_is(pred, "tbl")
  expect_identical(colnames(pred), c("prob", "est", "se", "lcl", "ucl"))
  expect_identical(pred$prob, seq(0.01, 0.99, by = 0.01))
  pred2 <- predict(dist, nboot = 10)
  expect_identical(pred$est[1], pred2$est[1])
})
