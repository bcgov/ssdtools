#    Copyright 2015 Province of British Columbia
#
#    Licensed under the Apache License, Version 2.0 (the "License");
#    you may not use this file except in compliance with the License.
#    You may obtain a copy of the License at
#
#       http://www.apache.org/licenses/LICENSE-2.0
#
#    Unless required by applicable law or agreed to in writing, software
#    distributed under the License is distributed on an "AS IS" BASIS,
#    WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
#    See the License for the specific language governing permissions and
#    limitations under the License.

#' @rdname llogis
#' @export
dllog <- function(x, locationlog = 0, scalelog = 1, log = FALSE) {
  deprecate_soft("0.1.0", "dllog()", "dllogis()", id = "xllog", 
                 details = "The 'llog' distribution has been deprecated for the identical 'llogis' distribution.")
  dllogis(x, locationlog = locationlog, scalelog = scalelog, log = log)
}

#' @rdname llogis
#' @export
qllog <- function(p, locationlog = 0, scalelog = 1, lower.tail = TRUE, log.p = FALSE) {
  deprecate_soft("0.1.0", "qllog()", "qllogis()", id = "xllog", 
                 details = "The 'llog' distribution has been deprecated for the identical 'llogis' distribution.", )
  qllogis(p, locationlog = locationlog, scalelog = scalelog, lower.tail = lower.tail, log.p = log.p)
}

#' @rdname llogis
#' @export
pllog <- function(q, locationlog = 0, scalelog = 1, lower.tail = TRUE, log.p = FALSE) {
  deprecate_soft("0.1.0", "pllog()", "pllogis()", id = "xllog", 
                 details = "The 'llog' distribution has been deprecated for the identical 'llogis' distribution.", )
  pllogis(q, locationlog = locationlog, scalelog = scalelog, lower.tail = lower.tail, log.p = log.p)
}

#' @rdname llogis
#' @export
rllog <- function(n, locationlog = 0, scalelog = 1) {
  deprecate_soft("0.1.0", "rllog()", "rllogis()", id = "xllog", 
                 details = "The 'llog' distribution has been deprecated for the identical 'llogis' distribution.", )
  rllogis(n, locationlog = locationlog, scalelog = scalelog)
}

#' @rdname llogis
#' @export
sllog <- function(x) {
  deprecate_soft("0.1.0", "sllog()", "sllogis()", id = "xllog",
                 details = "The 'llog' distribution has been deprecated for the identical 'llogis' distribution.", )
  sllogis(x)
}
