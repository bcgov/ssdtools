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

release_questions <- function() {
  c(
    "Have you run `data-raw/data-raw.R`?",
    "Have you tested using `ssdtests` package?",
    "Have you run `vignettestatic/small-sample-bias.Rmd`?",
    "Have you confirmed all images in .Rmd files have alternative text defined using the `fig.alt` argument?",
    "Have you confirmed updated Apache 2.0 license at the top of all code files?",
    "Have you confirmed update Creative Commons license for all non-code files?"
  )
}
