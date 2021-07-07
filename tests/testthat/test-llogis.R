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

test_that("llogis", {
  test_dist("llogis")
  expect_equal(pllogis(1), 0.5)
  expect_equal(qllogis(0.75), 3)
  set.seed(42)
  expect_equal(rllogis(2), c(10.7379218085407, 14.8920392236127))
})

test_that("fit llogis", {
  fit <- ssd_fit_dists(ssdtools::boron_data, dists = "llogis", rescale = FALSE)

  expect_equal(
    estimates(fit$llogis),
    list(locationlog = 2.62627762517872, scalelog = 0.740423704979968),
    tolerance = 1e-05)
})
