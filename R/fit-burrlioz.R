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

#' Fit Burrlioz Distributions
#' 
#' Fits 'burrIII3' distribution. 
#' If shape1 parameter is at boundary returns 'lgumbel' (which is equivalent to inverse Weibull).
#' Else if shape2 parameter is at a boundary returns 'invpareto'.
#' Otherwise returns 'burrIII3'
#'
#' @inheritParams params
#' @return An object of class fitdists.
#' @seealso [`ssd_fit_dists()`]
#'
#' @export
#' @examples
#' ssd_fit_burrlioz(ssddata::ccme_boron)
ssd_fit_burrlioz <- function(data, left = "Conc", rescale = FALSE, 
                             silent = FALSE) {
  
  if(nrow(data) <= 8) {
    return(ssd_fit_dists(data, left = left, dists = "llogis",
                         computable = FALSE, nrow = 5L,
                         rescale = rescale, silent = silent))
  }
  
  range_shape1 <- c(0.001, 100)
  range_shape2 <- c(0.001, 80)
  
  fit <- ssd_fit_dists(data, left = left, dists = "burrIII3",
                       rescale = rescale, computable = FALSE,
                       at_boundary_ok = TRUE, silent = TRUE,
                       nrow = 9L,
                       range_shape1 = range_shape1,
                       range_shape2 = range_shape2)
  
  dist <- "burrIII3"
  if(is_at_boundary(fit$burrIII3, data, range_shape1 = range_shape1, 
                    range_shape2 = range_shape2, regex = "shape2$")) {
    dist <- "invpareto"
  } else if(is_at_boundary(fit$burrIII3, data, range_shape1 = range_shape1, 
                           range_shape2 = range_shape2, regex = "shape1$")) {
    dist <- "lgumbel"
  }
  ssd_fit_dists(data, left = left, dists = dist, 
                rescale = rescale, computable = FALSE,
                silent = silent,
                nrow = 9L,
                range_shape1 = range_shape1,
                range_shape2 = range_shape2)
}
