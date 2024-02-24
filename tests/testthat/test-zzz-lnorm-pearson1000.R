#    Copyright 2023 Australian Government Department of 
#    Climate Change, Energy, the Environment and Water
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
#
test_that("lnorm with pearson1000 errors", {
  data <- ssdtools::pearson1000
  expect_warning(expect_error(ssd_fit_dists(data, dists = "lnorm")), "ABNORMAL_TERMINATION_IN_LNSRCH.")
})

test_that("lnorm with pearson1000 mean and sd", {
  conc <- ssdtools::pearson1000$Conc
  expect_equal(mean(log(conc)), 4.93885895685649)
  expect_equal(sd(log(conc)), 0.132482694377829)
})

test_that("pearson1000 fits some dists", {
  data <- ssdtools::pearson1000
  expect_warning(expect_warning(expect_warning(expect_warning(fit <- ssd_fit_dists(data, dists = ssd_dists_all())))))
  expect_snapshot_data(coef(fit), "p1000all")
})

test_that("lnorm with pearson1000 reverse works", {
  data <- ssdtools::pearson1000
  data$Conc <- data$Conc[nrow(data):1]
  fit <- ssd_fit_dists(data, dists = "lnorm")
  expect_snapshot_data(coef(fit), "p1000rev")
})

test_that("lnorm with pearson1000 rereverse fails", {
  data <- ssdtools::pearson1000
  data$Conc <- data$Conc[nrow(data):1]
  data$Conc <- data$Conc[nrow(data):1]
  expect_warning(expect_error(ssd_fit_dists(data, dists = "lnorm")), "ABNORMAL_TERMINATION_IN_LNSRCH.")
})

test_that("lnorm with pearson1000 works if rescale", {
  data <- ssdtools::pearson1000
  fit <- ssd_fit_dists(data, dists = "lnorm", rescale = TRUE)
  expect_snapshot_data(coef(fit), "p1000rescale")
})

test_that("lnorm with pearson1000 works if times by 10", {
  data <- ssdtools::pearson1000
  data$Conc <- data$Conc * 10
  fit <- ssd_fit_dists(data, dists = "lnorm")
  expect_snapshot_data(coef(fit), "p1000_10")
})

test_that("lnorm with pearson1000 works if time by 0.1", {
  data <- ssdtools::pearson1000
  data$Conc <- data$Conc * 0.1
  fit <- ssd_fit_dists(data, dists = "lnorm")
  expect_snapshot_data(coef(fit), "p1000_0.1")
})

test_that("lnorm with pearson1000 works if times by 0.1 and 10!!!", {
  data <- ssdtools::pearson1000
  data$Conc <- data$Conc * 0.1
  data$Conc <- data$Conc * 10
  fit <- ssd_fit_dists(data, dists = "lnorm")
  expect_snapshot_data(coef(fit), "p1000_0.110")
})
