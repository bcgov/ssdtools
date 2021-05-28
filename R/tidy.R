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

#' @export
generics::tidy

#' Turn a tmbfit object into a tidy tibble
#'
#' Turns a tmbfit object into a tidy tibble.
#' 
#' @param x A tmbfit object to be converted into a tidy tibble::tibble().
#' @param all A flag specifying whether to also return transformed parameters.
#' @param ... Unused.
#'  
#' @export
tidy.tmbfit <- function(x, all = FALSE, ...) {
  chk_flag(all)
  
  dist <- x$dist
  capture.output(x <- sdreport(x$model))
  x <- summary(x)
  term <- rownames(x)
  est <- unname(x[,1])
  se <- unname(x[,2])
  x <- tibble(dist = dist, term = term, est = est, se = se)
  
  if(!all)
    x <- x[!grepl("^log(it){0,1}_", x$term),]
  x <- x[str_order(x$term),]
  x
}

#' Turn a fitdists object into a tidy tibble
#'
#' Turns a fitdists object into a tidy tibble.
#' 
#' @param x A fitdists object to be converted into a tidy tibble::tibble().
#' @param all A flag specifying whether to also return transformed parameters.
#' @param ... Must be unused.
#'  
#' @export
tidy.fitdists <- function(x, all = FALSE, ...) {
 x <- lapply(x, tidy, all = all)
 x <- bind_rows(x)
 x <- x[str_order(x$dist),]
 x
}
