# Copyright 2023 Province of British Columbia
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
  expect_equal(ssd_ecd(1:10), seq(0.05, 0.95, by = 0.1))
})

test_that("ssd_ecd_data", {
  expect_snapshot_output(ssd_ecd_data(ssddata::ccme_boron))
})

test_that("comma_signif", {
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
