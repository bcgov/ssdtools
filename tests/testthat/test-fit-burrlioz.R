# Copyright 2023 Environment and Climate Change Canada
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

test_that("burrlioz with ccme_boron gives invpareto", {
  fit <- ssd_fit_burrlioz(ssddata::ccme_boron)
  expect_s3_class(fit, "fitdists")
  expect_s3_class(fit, "fitburrlioz")
  expect_identical(names(fit), "invpareto")
})

test_that("burrlioz with eight or less samples gives llogis", {
  fit <- ssd_fit_burrlioz(ssddata::ccme_boron[1:8, ])
  expect_s3_class(fit, "fitdists")
  expect_s3_class(fit, "fitburrlioz")
  expect_identical(names(fit), "llogis")
})

test_that("burrlioz with burrIII3 data gives burrIII3", {
  set.seed(99)
  conc <- ssd_rburrIII3(30)
  data <- data.frame(Conc = conc)
  fit <- ssd_fit_burrlioz(data)
  expect_s3_class(fit, "fitdists")
  expect_s3_class(fit, "fitburrlioz")
  expect_identical(names(fit), "burrIII3")
})

test_that("burrlioz with invpareto data gives invpareto", {
  set.seed(99)
  conc <- ssd_rinvpareto(30)
  data <- data.frame(Conc = conc)
  fit <- ssd_fit_burrlioz(data)
  expect_s3_class(fit, "fitdists")
  expect_s3_class(fit, "fitburrlioz")
  expect_identical(names(fit), "invpareto")
})

test_that("burrlioz with lgumbel data gives lgumbel", {
  set.seed(99)
  conc <- ssd_rlgumbel(25)
  data <- data.frame(Conc = conc)
  fit <- ssd_fit_burrlioz(data)
  expect_s3_class(fit, "fitdists")
  expect_s3_class(fit, "fitburrlioz")
  expect_identical(names(fit), "lgumbel")
})

test_that("burrlioz with ccme_chloride gives burrIII3", {
  fit <- ssd_fit_burrlioz(ssddata::ccme_chloride)
  expect_s3_class(fit, "fitdists")
  expect_s3_class(fit, "fitburrlioz")
  expect_identical(names(fit), "burrIII3")
})

test_that("burrlioz with ccme_cadmium fits", {
  fit <- ssd_fit_burrlioz(ssddata::ccme_cadmium)
  expect_s3_class(fit, "fitdists")
  expect_s3_class(fit, "fitburrlioz")
  expect_identical(names(fit), "burrIII3")
})

test_that("burrlioz with ccme_uranium", {
  fit <- ssd_fit_burrlioz(ssddata::ccme_uranium)
  expect_s3_class(fit, "fitdists")
  expect_s3_class(fit, "fitburrlioz")
  expect_identical(names(fit), "burrIII3")
})

test_that("burrlioz with anon_a", {
  fit <- ssd_fit_burrlioz(ssddata::anon_a)
  expect_s3_class(fit, "fitdists")
  expect_s3_class(fit, "fitburrlioz")
  expect_identical(names(fit), "invpareto")
})

test_that("burrlioz with anon_e", {
  fit <- ssd_fit_burrlioz(ssddata::anon_e)
  expect_s3_class(fit, "fitdists")
  expect_s3_class(fit, "fitburrlioz")
  expect_identical(names(fit), "lgumbel")
})
