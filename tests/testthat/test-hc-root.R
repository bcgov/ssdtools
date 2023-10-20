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

#    Copyright 2021 Province of British Columbia
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
  expect_error(hc <- ssd_hc(fits, average = TRUE, root = TRUE))
})


test_that("hc root lnorm llogis", {
  skip_on_os("linux") # FIXME
  fits <- ssd_fit_dists(ssddata::ccme_boron, dists = c("lnorm", "llogis"))
  set.seed(102)
  expect_error(hc <- ssd_hc(fits, average = TRUE, root = TRUE))
})