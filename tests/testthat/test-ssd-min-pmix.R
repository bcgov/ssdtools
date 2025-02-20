# Copyright 2015-2023 Province of British Columbia
# Copyright 2021 Environment and Climate Change Canada
# Copyright 2023-2024 Australian Government Department of Climate Change,
# Energy, the Environment and Water
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

test_that("ssd_min_pmix", {
  chk::expect_chk_error(ssd_min_pmix(NA_integer_))
  chk::expect_chk_error(ssd_min_pmix(integer(0)))
  chk::expect_chk_error(ssd_min_pmix(1:2))
  chk::expect_chk_error(ssd_min_pmix(10.5))
  expect_identical(ssd_min_pmix(1), 0.5)
  expect_identical(ssd_min_pmix(2L), 0.5)
  expect_identical(ssd_min_pmix(9), 1 / 3)
  expect_identical(ssd_min_pmix(10), 0.3)
  expect_identical(ssd_min_pmix(15), 0.2)
  expect_identical(ssd_min_pmix(20), 0.15)
  expect_identical(ssd_min_pmix(30), 0.1)
  expect_identical(ssd_min_pmix(50), 0.1)
})
