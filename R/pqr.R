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

#' Cumulative Distribution Function
#' @inheritParams params
#' @seealso [`ssd_q`] and [`ssd_r`]
#' @name ssd_p
NULL

#' Quantile Function
#' @inheritParams params
#' @seealso [`ssd_p`] and [`ssd_r`]
#' @name ssd_q
NULL

#' Random Number Generation
#' @inheritParams params
#' @seealso [`ssd_p`] and [`ssd_q`]
#' @name ssd_r
NULL

.pd <- function(q, ..., fun) {
  args <- c(q, list(...))

  if (any(vapply(args, length, 1L) != 1L)) stop()
  if (is.nan(q)) {
    return(NaN)
  }
  if (any(is.na(unlist(args)))) {
    return(NA_real_)
  }

  do.call(fun, args = args)
}

.pdist <- function(dist, q, ..., lower.tail, log.p) {
  inf <- !is.na(q) & is.infinite(q)
  pos <- is.na(q) | q > 0
  q[inf] <- NA_real_
  fun <- paste0("p", dist, "_ssd")
  p <- mapply(.pd, q, ..., MoreArgs = list(fun = fun))
  p[inf & pos] <- 1
  p[inf & !pos] <- 0
  if (!lower.tail) p <- 1 - p
  if (log.p) p <- log(p)
  p
}

pdist <- function(dist, q, ..., lower.tail = TRUE, log.p = FALSE, .lgt = FALSE) {
  if (!length(q)) {
    return(numeric(0))
  }

  if (!.lgt) {
    return(.pdist(dist, q = q, ..., lower.tail = lower.tail, log.p = log.p))
  }

  lte <- !is.na(q) & q <= 0
  q[lte] <- NA_real_
  p <- .pdist(dist, q = log(q), ..., lower.tail = TRUE, log.p = FALSE)
  p[lte] <- 0
  if (!lower.tail) p <- 1 - p
  if (log.p) p <- log(p)
  p
}

.qd <- function(p, ..., fun, .lgt) {
  args <- c(p, list(...))

  if (any(vapply(args, length, 1L) != 1L)) stop()
  if (is.nan(p)) {
    return(NaN)
  }
  if (any(is.na(unlist(args)))) {
    return(NA_real_)
  }

  if (p == 0) {
    if (!.lgt) {
      return(0)
    }
    return(-Inf)
  }
  if (p == 1) {
    return(Inf)
  }
  do.call(fun, args = args)
}

.qdist <- function(dist, p, ..., .lgt) {
  fun <- paste0("q", dist, "_ssd")
  q <- mapply(.qd, p, ..., MoreArgs = list(fun = fun, .lgt = .lgt))
  q
}

qdist <- function(dist, p, ..., lower.tail = TRUE, log.p = FALSE, .lgt = FALSE) {
  if (!length(p)) {
    return(numeric(0))
  }

  if (log.p) p <- exp(p)
  if (!lower.tail) p <- 1 - p

  nvld <- !is.na(p) & !(p >= 0 & p <= 1)
  p[nvld] <- NA_real_
  q <- .qdist(dist, p = p, ..., .lgt = .lgt)
  q[nvld] <- NaN
  if (.lgt) q <- exp(q)
  q
}

.rdist <- function(dist, n, ...) {
  fun <- paste0("r", dist, "_ssd")
  args <- list(...)

  if (exists(fun, mode = "function")) {
    args$n <- n
    return(do.call(fun, args))
  }
  qfun <- paste0("q", dist, "_ssd")
  q <- do.call(qfun, c(p = 0.5, args))
  if (is.nan(q)) {
    return(rep(NaN, n))
  }
  p <- runif(n)
  do.call(qfun, c(p = list(p), args))
}

rdist <- function(dist, n, ..., .lgt = FALSE, chk) {
  if (chk) {
    if (!length(n)) {
      return(numeric(0))
    }

    if (length(n) > 1) {
      n <- length(n)
    }
    chk_not_any_na(n)
    n <- floor(n)
    chk_gte(n)

    if (n == 0L) {
      return(numeric(0))
    }

    chk_all(list(...), check_dim, values = 1L, x_name = "...")
    if (any_missing(...)) {
      return(rep(NA_real_, n))
    }
  }
  r <- .rdist(dist, n = n, ...)
  if (.lgt) r <- exp(r)
  r
}

sdist <- function(dist, data, pars) {
  fun <- paste0("s", dist)
  do.call(fun, list(data = data, pars = pars))
}

bdist <- function(dist, data, min_pmix, range_shape1, range_shape2) {
  fun <- paste0("b", dist)
  if (!exists(fun, mode = "function")) {
    return(list(lower = -Inf, upper = Inf))
  }
  do.call(fun, list(
    data = data, min_pmix = min_pmix,
    range_shape1 = range_shape1, range_shape2 = range_shape2
  ))
}

mdist <- function(dist) {
  fun <- paste0("m", dist)
  if (!exists(fun, mode = "function")) {
    return(list())
  }
  do.call(fun, args = list())
}

tdist <- function(dist, data, pars, pvalue, test = "ks", y = "y") {
  x <- mean_weighted_values(data, weight = FALSE)
  fun <- paste0("ssd_p", dist)
  fun <- eval(parse(text = fun))
  args <- list(x, fun)
  names(args) <- c("x", y)
  args <- c(args, pars)
  test <- paste0(test, ".test")
  suppressWarnings(test <- do.call(test, args))
  if (pvalue) {
    return(test$p.value)
  }
  unname(test$statistic)
}
