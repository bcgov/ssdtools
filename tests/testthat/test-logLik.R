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

test_that("logLik", {
  boron_lnorm <- ssd_fit_dists(ssdtools::boron_data, dists = "lnorm")
  
  expect_equal(logLik(boron_lnorm), c(lnorm = -117.514216489547))
  expect_equal(logLik(boron_dists), c(gamma = -116.81515869884, llogis = -118.507435324864, lnorm = -117.514216489547
  ))
})
