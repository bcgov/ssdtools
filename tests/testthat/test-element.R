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

test_that("ssd_element_text_hc inherits from element_text", {
  element <- ssd_element_text_hc()
  expect_s3_class(element, "element_text_hc")
  expect_s3_class(element, "element_text")
})

test_that("ssd_element_text_hc bolds multi-line labels only", {
  grob <- ggplot2::element_grob(
    ssd_element_text_hc(),
    label = c("1", "\n1.26", "10"),
    hjust = 0.5,
    vjust = 1
  )
  expect_identical(unname(grob$children[[1]]$gp$font), c(1L, 2L, 1L))
})

test_that("ssd_element_text_hc is used by ssd_plot", {
  gp <- ssd_plot(ssddata::ccme_boron, ssdtools::boron_pred)
  expect_s3_class(gp@theme$axis.text.x, "element_text_hc")
})
