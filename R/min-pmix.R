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

#' Calculate Minimum Proportion in Mixture Models
#'
#' @inheritParams params
#'
#' @return A number between 0 and 0.5 of the minimum proportion in mixture models.
#' @seealso [ssd_fit_dists()]
#' @export
#'
#' @examples
#' ssd_min_pmix(6)
#' ssd_min_pmix(50)
ssd_min_pmix <- function(n) {
  chk_whole_number(n)
  chk_gt(n)
  max(min(3 / n, 0.5), 0.1)
}
