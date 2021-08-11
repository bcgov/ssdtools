#    Copyright 2015 Province of British Columbia
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

test_that("invpareto", {
  test_dist("invpareto", upadj = 1e-02)
  expect_equal(ssd_pinvpareto(0.5), 0.125)
  expect_equal(ssd_qinvpareto(0.125), 0.5)
  set.seed(42)
  expect_equal(ssd_rinvpareto(2), c(0.970755086941947, 0.978569136804486))
})

test_that("invpareto fits with anon_a", {
  fit <- ssd_fit_dists(ssddata::anon_a, dists = "invpareto")
  expect_s3_class(fit, "fitdists")
  tidy <- tidy(fit)
  expect_snapshot_data(tidy, "anon_a")
})

test_that("invpareto gives cis with ccme_boron", {
  fit <- ssd_fit_dists(ssddata::ccme_boron, dists = "invpareto")
  expect_s3_class(fit, "fitdists")
  set.seed(99)
  hc <- ssd_hc(fit, nboot = 100, ci = TRUE)
  expect_snapshot_data(hc, "hc_boron")
})
