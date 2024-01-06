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

test_that("gompertz", {
  test_dist("gompertz")
  expect_equal(ssd_pgompertz(1), 0.820625921265983)
  expect_equal(ssd_qgompertz(0.75), 0.869741686191944)
  set.seed(42)
  expect_equal(ssd_rgompertz(2), c(1.24208466660006, 1.32596518320944))
})

test_that("bootstrap gompertz with problem data", {
  set.seed(99)
  data <- data.frame(Conc = ssd_rgompertz(6, location = 0.6, shape = 0.07))
  fit <- ssdtools::ssd_fit_dists(data, dists = "gompertz")
  set.seed(99)
  hc <- ssd_hc(fit, ci = TRUE, nboot = 100, min_pboot = 0.8, multi = FALSE,
               samples = TRUE, weighted = FALSE)
  expect_snapshot_data(hc, "hc_prob")
})
