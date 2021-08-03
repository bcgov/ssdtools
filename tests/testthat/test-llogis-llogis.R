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

test_that("llogis_llogis", {
  test_dist("llogis_llogis", qroottolerance = 1e-04)
  expect_equal(ssd_pllogis_llogis(1), 0.384470710684998)
  expect_equal(ssd_qllogis_llogis(0.75), 5.2666469409969)
  set.seed(42)
  expect_equal(ssd_rllogis_llogis(2), c(0.400833984692937, 4.89788262355488))
})
