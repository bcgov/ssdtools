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

test_that("ssd_ecd", {
  expect_equal(ssd_ecd(numeric()), numeric())
  expect_equal(ssd_ecd(NA_real_), 0.5)
  expect_equal(ssd_ecd(1), 0.5)
  expect_equal(ssd_ecd(1:2), c(0.277777777777778, 0.722222222222222))
  expect_equal(ssd_ecd(c(1, NA_real_)), c(NA_real_, NA_real_))
  expect_equal(ssd_ecd(1:10), c(0.0609756097560976, 0.158536585365854, 0.25609756097561, 0.353658536585366, 
                                0.451219512195122, 0.548780487804878, 0.646341463414634, 0.74390243902439, 
                                0.841463414634146, 0.939024390243902))
  expect_equal(ssd_ecd(1:100), seq(0.005, 0.995, by = 0.01))
})

test_that("ssd_ecd ties.method argument deprecated", {
  lifecycle::expect_deprecated(expect_equal(ssd_ecd(1, ties.method = "first"), 0.5))
})

test_that("ssd_ecd_data", {
  expect_snapshot_output(ssd_ecd_data(ssddata::ccme_boron))
})

test_that("comma_signif", {
  withr::local_options(lifecycle_verbosity = "quiet")

  expect_identical(
    comma_signif(c(0.0191, 1, NA, 177, 1111)),
    c("0.0191", "1", NA, "177", "1,110")
  )
  expect_identical(
    comma_signif(c(0.0191, 1, NA, 177, 1111), digits = 1),
    c("0.02", "1", NA, "200", "1,000")
  )
  expect_identical(
    comma_signif(c(0.1, 1)),
    c("0.1", "1")
  )
  expect_identical(
    comma_signif(c(0.1, 1, 10)),
    c("0.1", "1", "10")
  )
  expect_identical(
    comma_signif(c(0.1, 1, 10, 1000)),
    c("0.1", "1", "10", "1,000")
  )
  expect_identical(
    comma_signif(c(0.55555, 55555)),
    c("0.556", "55,600")
  )
})

test_that("ssd_sort_data works conc", {
  expect_identical(ssd_sort_data(ssddata::ccme_boron), ssddata::ccme_boron[order(ssddata::ccme_boron$Conc), ])
})

test_that("ssd_sort_data works no rows", {
  data <- ssddata::ccme_boron[FALSE, ]
  expect_identical(ssd_sort_data(data), data[order(data$Conc), ])
})

test_that("ssd_sort_data works censored data", {
  data <- ssddata::ccme_boron
  data$Other <- data$Conc * 2
  data$Conc[1] <- NA
  data$ID <- seq_len(nrow(data))
  expect_identical(
    ssd_sort_data(data, right = "Other")$ID[1:5],
    c(1L, 19L, 20L, 21L, 2L)
  )
})

test_that("ssd_sort_data errors missing data", {
  data <- ssddata::ccme_boron
  data$Conc[1] <- NA
  chk::expect_chk_error(
    ssd_sort_data(data),
    "`data` has 1 row with effectively missing values in 'Conc'."
  )
})
