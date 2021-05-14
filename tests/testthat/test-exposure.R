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

test_that("exposure fitdist", {
  set.seed(1)
  expect_equal(ssd_exposure(boron_lnorm), 0.0554547384157672)
  set.seed(1)
  expect_equal(ssd_exposure(boron_lnorm, 1), 0.165086129822829)
  set.seed(1)
  expect_equal(ssd_exposure(boron_lnorm, 1, sdlog = 10), 0.433888818786343)
})

test_that("exposure fitdists", {
  set.seed(1)
  expect_equal(ssd_exposure(boron_dists), 0.0645345700344277)
})

test_that("exposure fitdistcens", {
  set.seed(1)
  expect_equal(ssd_exposure(fluazinam_lnorm), 0.041559102462777)
})

test_that("exposure fitdistscens", {
  set.seed(1)
  expect_equal(ssd_exposure(fluazinam_dists), 0.0490197455575992)
})
