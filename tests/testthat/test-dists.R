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

test_that("dists sorted character", {
  dists <- ssd_dists()
  expect_type(dists, "character")
  expect_identical(dists, stringr::str_sort(dists))
})

test_that("dists all = stable + unstable", {
  stable <- ssd_dists(type = "stable")
  unstable <- ssd_dists(type = "unstable")
  dists <- c(stable, unstable)
  dists <- stringr::str_sort(dists)
  expect_identical(dists, ssd_dists("all"))
})
