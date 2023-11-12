# Copyright 2023 Province of British Columbia
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

# optimized function for tmbfit
.tidy_tmbfit_estimates <- function(x) {
  dist <- x$dist
  suppressWarnings(capture.output(x <- sdreport(x$model)))
  x <- suppressWarnings(summary(x))
  est <- unname(x[, 1])
  names(est) <- rownames(x)
  est <- est[!grepl("^log(it){0,1}_", names(est))]
  est[stringr::str_order(names(est))]
}

#' @export
tidy.tmbfit <- function(x, all = FALSE, ...) {
  chk_flag(all)

  dist <- x$dist
  suppressWarnings(capture.output(x <- sdreport(x$model)))
  x <- suppressWarnings(summary(x))
  term <- rownames(x)
  est <- unname(x[, 1])
  se <- unname(x[, 2])
  x <- tibble(
    dist = dist, term = term, est = est, se = se,
    .name_repair = "minimal"
  )

  if (!all) {
    x <- x[!grepl("^log(it){0,1}_", x$term), ]
  }
  x <- x[stringr::str_order(x$term), ]
  x
}

#' Turn a fitdists Object into a Tibble
#'
#' Turns a fitdists object into a tidy tibble of the
#' estimates (est) and standard errors (se) by the
#' terms (term) and distributions (dist).
#'
#' @inheritParams params
#' @return A tidy tibble of the estimates and standard errors.
#' @family generics
#' @seealso [`coef.fitdists()`]
#' @export
#' @examples
#' fits <- ssd_fit_dists(ssddata::ccme_boron)
#' tidy(fits)
#' tidy(fits, all = TRUE)
tidy.fitdists <- function(x, all = FALSE, ...) {
  x <- lapply(x, tidy, all = all)
  x <- bind_rows(x)
  x
}
