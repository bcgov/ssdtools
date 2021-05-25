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

qburrIII3 <- function(p, lshape1 = 0, lshape2 = 0, lscale = 0, lower.tail = TRUE, log.p = FALSE) {
  deprecate_soft("0.2.1", "qburrIII3()", id = "xburrIII3",
                 details = "The 'burrIII3' distribution is under review.")
  
  if(!length(q)) return(numeric(0))
  if(log.p) p <- exp(p)
  q <- suppressWarnings(actuar::qburr(1-p, shape1=exp(lshape1), shape2=exp(lshape2), scale=exp(lscale), 
                                      lower.tail=lower.tail))
  1/q
}

pburrIII3 <- function (q, lshape1 = 0, lshape2 = 0, lscale=0, lower.tail=TRUE, log.p=FALSE) {
  deprecate_soft("0.2.1", "pburrIII3()", id = "xburrIII3",
                 details = "The 'burrIII3' distribution is under review.")
  
  if(!length(q)) return(numeric(0))
  actuar::pburr(1/q, shape1=exp(lshape1), shape2=exp(lshape2), scale=exp(lscale), 
                lower.tail=!lower.tail, log.p=log.p)
}

rburrIII3 <- function(n, lshape1 = 0, lshape2 = 0, lscale=0) {
  deprecate_soft("0.2.1", "rburrIII3()", id = "xburrIII3",
                 details = "The 'burrIII3' distribution is under review.")
  
  chk_scalar(lshape1)
  chk_scalar(lshape2)
  chk_scalar(lscale)
  
  r <- suppressWarnings(actuar::rburr(n, shape1=exp(lshape1), shape2=exp(lshape2), scale=exp(lscale)))
  1/r
}

sburrIII3 <- function(x) {
  list(log_scale = 1, log_shape1 = 0, log_shape2 = 0)
}
