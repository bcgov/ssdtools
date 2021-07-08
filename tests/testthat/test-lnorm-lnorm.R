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

test_that("lnorm_lnorm", {
  test_dist("lnorm_lnorm")
  expect_equal(plnorm_lnorm(1), 0.329327626965729)
  expect_equal(qlnorm_lnorm(0.75), 3.53332231582824)
  set.seed(42)
  expect_equal(rlnorm_lnorm(2), c(0.568531719998709, 1.43782047983794))
})
