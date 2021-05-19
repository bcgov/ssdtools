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

#' @rdname lgumbel
smx_llogis_llogis_tmb <- function(x) {
  x <- sort(x)
  n <- length(x)
  n2 <- floor(n / 2)
  x1 <- x[1:n2]
  x2 <- x[(n2+1):n]
  s1 <- sllogis_tmb(x1)
  s2 <- sllogis_tmb(x2)
  names(s1) <- paste0(names(s1), "1")
  names(s2) <- paste0(names(s2), "2")
  logit_pmix <- list(logit_pmix = 0)
  c(s1, s2, logit_pmix)
}
