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

test_that("hc root lnorm", {
  skip_on_os("linux") # FIXME
  fits <- ssd_fit_dists(ssddata::ccme_boron, dists = "lnorm")
  set.seed(102)
  hc_dist <- ssd_hc(fits, average = FALSE)
  hc_average <- ssd_hc(fits, average = TRUE)
  hc_root <- ssd_hc(fits, average = TRUE, root = TRUE)
  expect_identical(hc_average$est, hc_dist$est)
  expect_identical(hc_average$est, hc_dist$est)
  expect_identical(hc_root, hc_average, tolerance = 1e-10)
  expect_equal(hc_root$est, 1.68117483988121, tolerance = 1e-6)
  
  testthat::expect_snapshot({
    hc_root
  })
})

test_that("hc root all", {
  skip_on_os("linux") 
  fits <- ssd_fit_dists(ssddata::ccme_boron)
  set.seed(102)
  hc_average <- ssd_hc(fits, average = TRUE)
  hc_root <- ssd_hc(fits, average = TRUE, root = TRUE)
  expect_equal(hc_root, hc_average, tolerance = 1e-1)
  expect_identical(hc_average$est, 1.24151700389853, tolerance = 1e-10)
  expect_equal(hc_root$est, 1.25678623624403, tolerance = 1e-10)
  testthat::expect_snapshot({
    hc_root
  })
})
