# Copyright 2025 Australian Government Department of Climate Change,
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

test_that("test computable fits2.3", {
  fits <- ssdtools:::fits2.3
  expect_identical(ssd_computable(fits),
                   c(gamma = NA, lgumbel = NA, llogis = NA, lnorm = NA, 
                     lnorm_lnorm = NA, weibull = NA))
  expect_identical(ssd_computable(fits$lnorm), NA)
  expect_identical(ssd_computable(fits$lnorm_lnorm), NA)
})

test_that("test computable fits", {
  fits <- ssdtools:::fits
  expect_identical(ssd_computable(fits),
                   c(gamma = TRUE, lgumbel = TRUE, llogis = TRUE, lnorm = TRUE, 
                     lnorm_lnorm = TRUE, weibull = TRUE))
  expect_true(ssd_computable(fits$lnorm))
  expect_true(ssd_computable(fits$lnorm_lnorm))
})

