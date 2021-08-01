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

test_that("burrlioz with boron_data gives lgumbel", {
  fit <- ssd_fit_burrlioz(ssdtools::boron_data)
  expect_s3_class(fit, "fitdists")
  expect_identical(names(fit), "lgumbel")
})

test_that("burrlioz with burrIII3 data gives burrIII3", {
  set.seed(99)
  conc <- ssd_rburrIII3(30)
  data <- data.frame(Conc = conc)
  fit <- ssd_fit_burrlioz(data)
  expect_s3_class(fit, "fitdists")
  expect_identical(names(fit), "burrIII3")
})

test_that("burrlioz with invpareto data gives invpareto", {
  set.seed(99)
  conc <- ssd_rinvpareto(20)
  data <- data.frame(Conc = conc)
  fit <- ssd_fit_burrlioz(data)
  expect_s3_class(fit, "fitdists")
  expect_identical(names(fit), "invpareto")
})

test_that("burrlioz with lgumbel data doesn't give lgumbel!", {
  set.seed(99)
  conc <- ssd_rlgumbel(20)
  data <- data.frame(Conc = conc)
  fit <- ssd_fit_burrlioz(data)
  expect_s3_class(fit, "fitdists")
  expect_identical(names(fit), "lgumbel")
})
