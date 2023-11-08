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

test_that("lgumbel", {
  test_dist("lgumbel")
  expect_equal(ssd_plgumbel(1), 0.367879441171442)
  expect_equal(ssd_qlgumbel(0.75), 3.47605949678221)
  set.seed(42)
  expect_equal(ssd_rlgumbel(2), c(11.2305025213646, 15.3866236451648))
})
