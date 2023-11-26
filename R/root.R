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

.ssd_hcp_multi <- function(value, estimates, ci, level, nboot, min_pboot,
                           data, rescale, weighted, censoring, min_pmix,
                           range_shape1, range_shape2, parametric, control, hc) {
  
  args <- list()
  if(hc) {
    args$p <- value
    what <- paste0("qmulti_list")
  } else {
    args$q <- value / rescale
    what <- paste0("pmulti_list")
  }
  args$list <- estimates
  est <- do.call(what, args)
  
  if (!ci) {
    return(no_ci_hcp(value = value, dist = "average", est = est, rescale = rescale, hc = hc))
  }

  .NotYetImplemented()
}
