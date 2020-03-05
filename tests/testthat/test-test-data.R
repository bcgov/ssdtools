#    Copyright 2015 Province of British Columbia
#
#    Licensed under the Apache License, Version 2.0 (the "License");
#    you may not use this file except in compliance with the License.
#    You may obtain a copy of the License at
#
#       http://www.apache.org/licenses/LICENSE-2.0
#
#    Unless required by applicable law or agreed to in writing, software
#    distributed under the License is distributed on an "AS IS" BASIS,
#    WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
#    See the License for the specific language governing permissions and
#    limitations under the License.

test_that("test_data", {
  expect_null(chk::check_data(
    test_data,
    values = list(
      Chemical = "",
      Conc = c(0.04, 76500)
    ),
    exclusive = TRUE,
    order = TRUE,
    nrow = 141L
  ))
  expect_is(test_data, "tbl")
})

test_that("test_data Quinoline", {
  quin <- test_data[test_data$Chemical == "Quinoline",]
  
  expect_warning(dists <- ssd_fit_dists(quin, dist = c("gamma", "lnorm")),
                 "^Distribution gamma failed to compute standard errors [(]try rescaling the data or increasing the sample size[)]")
  expect_identical(names(dists), "lnorm")
})
