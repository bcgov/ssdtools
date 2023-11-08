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

test_that("match_moments all", {
  rlang::local_options(lifecycle_verbosity = "quiet")
  set.seed(10)
  pars <- ssd_match_moments(dists = ssd_dists_all())
  expect_snapshot_output(print(pars))
  expect_snapshot_plot(ssd_plot_cdf(pars), "cdf")
})
