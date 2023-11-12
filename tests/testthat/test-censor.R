# Copyright 2023 Province of British Columbia
#
#    Licensed under the Apache License, Version 2.0 (the "License");
#    you may not use this file except in compliance with the License.
#    You may obtain a copy of the License at
#
#       https://www.apache.org/licenses/LICENSE-2.0
#
#    Unless required by applicable law or agreed to in writing, software
#    distributed under the License is distributed on an "AS IS" BASIS,
#    WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
#    See the License for the specific language governing permissions and
#    limitations under the License.

test_that("censor", {
  rlang::local_options(lifecycle_verbosity = "quiet")

  fits <- ssd_fit_dists(ssddata::ccme_boron, dists = "lnorm")

  expect_false(is_censored(fits))

  # need to have example censored data
  data <- ssddata::ccme_boron
  data$Right <- data$Conc
  data$Conc <- 0
  fits <- ssd_fit_dists(data, right = "Right", dists = c("gamma", "llogis", "lnorm"))
  expect_true(is_censored(fits))
})
