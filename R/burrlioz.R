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

fit_burrlioz <- function(data, dist, min_pmix, range_shape1, range_shape2,
                         control, pars, hessian, ...) {
  burrIII3 <- fit_tmb(data, dist,
    min_pmix = min_pmix, range_shape1 = range_shape1,
    range_shape2 = range_shape2, control = control,
    pars = pars, hessian = hessian
  )

  if (is_at_boundary(burrIII3, data,
    range_shape1 = range_shape1,
    range_shape2 = range_shape2, regex = "shape2$"
  )) {
    dist <- "invpareto"
  } else if (is_at_boundary(burrIII3, data,
    range_shape1 = range_shape1,
    range_shape2 = range_shape2, regex = "shape1$"
  )) {
    dist <- "lgumbel"
  } else {
    return(burrIII3)
  }
  fit_tmb(data, dist,
    min_pmix = min_pmix, range_shape1 = range_shape1,
    range_shape2 = range_shape2, control = control,
    pars = NULL, hessian = hessian
  )
}
