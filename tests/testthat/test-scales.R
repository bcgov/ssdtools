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

test_that("ssd_label_comma formats with significant digits and big mark", {
  expect_identical(
    ssd_label_comma()(c(0.123456, 1234.5678)),
    c("0.123", "1,230")
  )
  expect_identical(
    ssd_label_comma(digits = 2, big.mark = " ", decimal.mark = ",")(
      c(0.123456, 1234.5678)
    ),
    c("0,12", "1 200")
  )
})

test_that("ssd_label_comma_hc makes the hc label a plotmath expression", {
  labels <- ssd_label_comma_hc(1.26)(c(1, 1.26, 10))
  expect_identical(labels[[1]], "1")
  expect_identical(labels[[3]], "10")
  expect_identical(labels[[2]], bquote(atop(phantom(0), bold("1.26"))))
})

test_that("ssd_label_comma_hc leaves non-hc labels as ssd_label_comma", {
  x <- c(1, 10, NA)
  expect_identical(
    unlist(ssd_label_comma_hc(1.26)(x)),
    ssd_label_comma()(x)
  )
})

test_that("ssd_label_comma_hc marks hc with big.mark and decimal.mark", {
  labels <- ssd_label_comma_hc(1260)(c(1, 1260))
  expect_identical(labels[[2]], bquote(atop(phantom(0), bold("1,260"))))

  labels <- ssd_label_comma_hc(1.26, decimal.mark = "-")(c(1, 1.26))
  expect_identical(labels[[2]], bquote(atop(phantom(0), bold("1-26"))))
})
