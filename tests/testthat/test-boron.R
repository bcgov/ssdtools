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

test_that("boron stable", {
  dists <- ssd_dists("stable")
  fits <- ssd_fit_dists(ssdtools::boron_data, dists = dists)
  
  tidy <- tidy(fits)
  expect_s3_class(tidy, "tbl_df")
  expect_snapshot_data(tidy, "tidy_stable")
  
  glance <- glance(fits)
  expect_s3_class(glance, "tbl")
  expect_snapshot_data(glance, "glance_stable")

  gof <- ssd_gof(fits)
  expect_s3_class(gof, "tbl")
  expect_snapshot_data(gof, "gof_stable")

  estimates <- estimates(fits)
  expect_type(estimates, "list")
  expect_identical(unlist(estimates), setNames(tidy$est, paste(tidy$dist, tidy$term, sep = ".")))
  
  expect_identical(coef(fits), tidy)
  expect_identical(augment(fits), ssdtools::boron_data)
  
  set.seed(102)
  hc <- ssd_hc(fits, ci = TRUE, nboot = 10, average = FALSE)
  expect_s3_class(hc, "tbl")
  expect_snapshot_data(hc, "hc_stable")

  set.seed(102)
  hp <- ssd_hp(fits, conc = 1, ci = TRUE, nboot = 10, average = FALSE)
  expect_s3_class(hp, "tbl")
  expect_snapshot_data(hp, "hp_stable")
})

test_that("boron unstable", {
  dists <- ssd_dists("unstable")
  set.seed(50)
  expect_warning(expect_warning(fits <- ssd_fit_dists(ssdtools::boron_data, dists = dists),
                 "Distribution 'burrIII3' failed to fit"),
                 "Distribution 'invpareto' failed to fit")

  tidy <- tidy(fits)
  expect_s3_class(tidy, "tbl_df")
  expect_snapshot_data(tidy, "tidy_unstable")
  
  glance <- glance(fits)
  expect_s3_class(glance, "tbl")
  expect_snapshot_data(glance, "glance_unstable")
  
  gof <- ssd_gof(fits)
  expect_s3_class(gof, "tbl")
  expect_snapshot_data(gof, "gof_unstable")
  
  estimates <- estimates(fits)
  expect_type(estimates, "list")
  expect_identical(unlist(estimates), setNames(tidy$est, paste(tidy$dist, tidy$term, sep = ".")))
  
  expect_identical(coef(fits), tidy)
  expect_identical(augment(fits), ssdtools::boron_data)
  
  set.seed(102)
  hc <- ssd_hc(fits, ci = TRUE, nboot = 10, average = FALSE)
  expect_s3_class(hc, "tbl")
  expect_snapshot_data(hc, "hc_unstable")
  
  set.seed(102)
  hp <- ssd_hp(fits, conc = 1, ci = TRUE, nboot = 10, average = FALSE)
  expect_s3_class(hp, "tbl")
  expect_snapshot_data(hp, "hp_unstable")
})
