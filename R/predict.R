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

#' @importFrom stats predict
#' @export
stats::predict

#' @export
predict.fitdists <- function(object, percent = 1:99, ci = FALSE,
                             level = 0.95, nboot = 1000, parallel = NULL, ncpus = 1,
                             average = TRUE, ic = "aicc",
                             ...) {
  chk_unused(...)
  ssd_hc(object,
         percent = percent, ci = ci, level = level,
         nboot = nboot, parallel = parallel, ncpus = ncpus,
         average = average, ic = ic
  )
}
