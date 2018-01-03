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
  dist_names <- c("lnorm", "llog", "gompertz", "lgumbel", "gamma", "weibull")
  dists <- ssd_fit_dists(ccme_data$Conc[ccme_data$Chemical == "Boron"], dist_names)

  expect_identical(names(dists), dist_names)
})
