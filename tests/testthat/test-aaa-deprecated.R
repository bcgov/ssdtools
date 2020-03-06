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

test_that("deprecated llog", {
  dist <- ssdtools:::ssd_fit_dist(ssdtools::boron_data, dist = "llog")

  expect_true(is.fitdist(dist))
  expect_equal(
    coef(dist),
    c(lscale = 2.6261249, lshape = 0.7403092)
  )
  set.seed(101)
  pred <- predict(dist, percent = 1, ci = TRUE, nboot = 10L)
  expect_equal(as.data.frame(pred), structure(list(percent = 1, est = 0.460388430679064, se = 0.305015200817155, 
    lcl = 0.124204402582017, ucl = 1.04527103315379, dist = "llog"), row.names = c(NA, 
-1L), class = "data.frame"))
})

test_that("deprecated llog", {
  expect_error(ssd_fit_dists(ssdtools::boron_data, dist = c("llog", "llogis")), "Distributions 'llog', 'burrIII2' and 'llogis' are identical. Please just use 'llogis'.")
})

test_that("deprecated burrIII2", {
  expect_error(ssd_fit_dists(ssdtools::boron_data, dist = c("llog", "burrIII2")), "Distributions 'llog', 'burrIII2' and 'llogis' are identical. Please just use 'llogis'.")
})

test_that("deprecated burrIII2", {
  expect_error(ssd_fit_dists(ssdtools::boron_data, dist = c("llogis", "burrIII2")), "Distributions 'llog', 'burrIII2' and 'llogis' are identical. Please just use 'llogis'.")
})
