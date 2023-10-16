#    Copyright 2021 Province of British Columbia
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
#' @rawNamespace useDynLib(ssdtools, .registration=TRUE); useDynLib(ssdtools_TMBExports)
#' @keywords internal
"_PACKAGE"

utils::globalVariables("where")

## usethis namespace: start
#' @import chk ggplot2
#' @importFrom abind abind
#' @importFrom furrr future_map furrr_options
#' @importFrom generics augment glance tidy
#' @importFrom ggplot2 autoplot sym
#' @importFrom goftest ad.test cvm.test
#' @importFrom graphics par plot title
#' @importFrom grid gList gpar grobName gTree polygonGrob segmentsGrob
#' @importFrom lifecycle expect_deprecated deprecate_soft deprecate_stop deprecate_warn
#' @importFrom parallel nextRNGStream nextRNGSubStream
#' @importFrom plyr summarise
#' @importFrom purrr transpose
#' @importFrom Rcpp sourceCpp
#' @importFrom scales comma manual_pal percent trans_breaks
#' @importFrom ssddata gm_mean
#' @importFrom stats coef complete.cases ks.test logLik nobs optim plogis predict qlogis runif sd setNames weighted.mean
#' @importFrom stringr str_order
#' @importFrom tibble as_tibble tibble
#' @importFrom TMB MakeADFun sdreport
#' @importFrom universals estimates npars
#' @importFrom utils capture.output
#' @importFrom VGAM gompertz vglm
## usethis namespace: end
NULL
