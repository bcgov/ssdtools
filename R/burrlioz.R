# Copyright 2023 Environment and Climate Change Canada
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

fit_burrlioz <- function(dist, data, min_pmix, range_shape1, range_shape2,
                         control, pars, hessian) {
  burrIII3 <- fit_tmb(dist, data,
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
  fit_tmb(dist, data,
    min_pmix = min_pmix, range_shape1 = range_shape1,
    range_shape2 = range_shape2, control = control,
    pars = NULL, hessian = hessian
  )
}

ssd_qburrlioz <- function(p, scale = NA_real_, shape = NA_real_, shape1 = NA_real_,
                          shape2 = NA_real_, locationlog = NA_real_, scalelog = NA_real_,
                          lower.tail = TRUE, log.p = FALSE) {
  burrIII3 <- ssd_qburrIII3(p,
    scale = scale, shape1 = shape1, shape2 = shape2,
    lower.tail = lower.tail, log.p = log.p
  )

  invpareto <- ssd_qinvpareto(p,
    scale = scale, shape = shape,
    lower.tail = lower.tail, log.p = log.p
  )

  lgumbel <- ssd_qlgumbel(p,
    locationlog = locationlog, scalelog = scalelog,
    lower.tail = lower.tail, log.p = log.p
  )

  burrIII3[is.na(burrIII3)] <- invpareto[is.na(burrIII3)]
  burrIII3[is.na(burrIII3)] <- lgumbel[is.na(burrIII3)]
  burrIII3
}
