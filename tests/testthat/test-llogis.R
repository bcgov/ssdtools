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

test_that("fit llogis", {
  fit <- ssd_fit_dists(ssdtools::boron_data, dists = "llogis")

  expect_equal(
    estimates(fit$llogis),
    list(locationlog = 2.62627762517872, scalelog = 0.740423704979968)
  )
})

test_that("pqllogis", {
  expect_equal(log(qllogis(0.5, 1, 1)), 1)
  expect_equal(pllogis(exp(3), 1, 1), 0.880797077977882)
  expect_equal(pllogis(exp(4), 1, 1), 0.952574126822433)
  expect_identical(pllogis(qllogis(0.5, 3, 1), 3, 1), 0.5)
})

test_that("rllogis", {
  set.seed(99)
  r <- rllogis(100000, 1, 1)
  expect_identical(length(r), 100000L)
  expect_equal(mean(log(r)), 0.99552614238909)
})
