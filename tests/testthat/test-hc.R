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

context("hc")

test_that("ssd_hc fitdist", {
  expect_equal(as.data.frame(ssd_hc(boron_lnorm)),
               structure(list(percent = 5, est = 1.68117483775796, se = NA_real_, 
    lcl = NA_real_, ucl = NA_real_), class = "data.frame", row.names = c(NA, 
-1L)))
})

test_that("ssd_hc fitdistcens", {
  expect_equal(as.data.frame(ssd_hc(fluazinam_lnorm)),
  structure(list(percent = 5, est = 1.74352219048516, se = NA_real_, 
    lcl = NA_real_, ucl = NA_real_), class = "data.frame", row.names = c(NA, 
-1L)))
})

test_that("ssd_hc fitdists", {
  expect_equal(as.data.frame(ssd_hc(boron_dists)),
               structure(list(percent = 5, est = 1.30474651622516, se = NA_real_, 
    lcl = NA_real_, ucl = NA_real_), class = "data.frame", row.names = c(NA, 
-1L)))
})

test_that("ssd_hc fitdistscens", {
  expect_equal(as.data.frame(ssd_hc(fluazinam_dists)),
               structure(list(percent = 5, est = 1.35230977078523, se = NA_real_, 
    lcl = NA_real_, ucl = NA_real_), class = "data.frame", row.names = c(NA, 
-1L)))
})
