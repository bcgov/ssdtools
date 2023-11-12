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

test_that("gamma", {
  test_dist("gamma")
  expect_equal(ssd_pgamma(1), 0.632120558828558)
  expect_equal(ssd_qgamma(0.75), 1.38629436111989)
  set.seed(42)
  expect_equal(ssd_rgamma(2), c(1.93929578065309, 0.180419099876704))
})
