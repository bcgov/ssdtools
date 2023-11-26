#    Copyright 2023 Australian Government Department of 
#    Climate Change, Energy, the Environment and Water
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

#' @describeIn ssd_p Cumulative Distribution Function for Multiple Distributions
#' @export
#' @examples
#' 
#' # multi 
#' ssd_pmulti(1)
ssd_pmulti <- function(
    q,     
    burrIII3.weight = 0, 
    burrIII3.shape1 = 1, 
    burrIII3.shape2 = 1, 
    burrIII3.scale = 1, 
    gamma.weight = 1/6, 
    gamma.shape = 1, 
    gamma.scale = 1, 
    gompertz.weight = 0, 
    gompertz.location = 1, 
    gompertz.shape = 1, 
    invpareto.weight = 0, 
    invpareto.shape = 3, 
    invpareto.scale = 1, 
    lgumbel.weight = 1/6, 
    lgumbel.locationlog = 0, 
    lgumbel.scalelog = 1, 
    llogis.weight = 1/6, 
    llogis.locationlog = 0, 
    llogis.scalelog = 1, 
    llogis_llogis.weight = 0, 
    llogis_llogis.locationlog1 = 0, 
    llogis_llogis.scalelog1 = 1, 
    llogis_llogis.locationlog2 = 1, 
    llogis_llogis.scalelog2 = 1, 
    llogis_llogis.pmix = 0.5, 
    lnorm.weight = 1/6, 
    lnorm.meanlog = 0, 
    lnorm.sdlog = 1, 
    lnorm_lnorm.weight = 1/6, 
    lnorm_lnorm.meanlog1 = 0, 
    lnorm_lnorm.sdlog1 = 1, 
    lnorm_lnorm.meanlog2 = 1, 
    lnorm_lnorm.sdlog2 = 1, 
    lnorm_lnorm.pmix = 0.5, 
    weibull.weight = 1/6, 
    weibull.shape = 1, 
    weibull.scale = 1,  
    lower.tail = TRUE, log.p = FALSE) {
  pdist("multi",
        q = q,         
        burrIII3.weight = burrIII3.weight,
        burrIII3.shape1 = burrIII3.shape1,
        burrIII3.shape2 = burrIII3.shape2,
        burrIII3.scale = burrIII3.scale,
        gamma.weight = gamma.weight,
        gamma.shape = gamma.shape,
        gamma.scale = gamma.scale,
        gompertz.weight = gompertz.weight,
        gompertz.location = gompertz.location,
        gompertz.shape = gompertz.shape,
        invpareto.weight = invpareto.weight,
        invpareto.shape = invpareto.shape,
        invpareto.scale = invpareto.scale,
        lgumbel.weight = lgumbel.weight,
        lgumbel.locationlog = lgumbel.locationlog,
        lgumbel.scalelog = lgumbel.scalelog,
        llogis.weight = llogis.weight,
        llogis.locationlog = llogis.locationlog,
        llogis.scalelog = llogis.scalelog,
        llogis_llogis.weight = llogis_llogis.weight,
        llogis_llogis.locationlog1 = llogis_llogis.locationlog1,
        llogis_llogis.scalelog1 = llogis_llogis.scalelog1,
        llogis_llogis.locationlog2 = llogis_llogis.locationlog2,
        llogis_llogis.scalelog2 = llogis_llogis.scalelog2,
        llogis_llogis.pmix = llogis_llogis.pmix,
        lnorm.weight = lnorm.weight,
        lnorm.meanlog = lnorm.meanlog,
        lnorm.sdlog = lnorm.sdlog,
        lnorm_lnorm.weight = lnorm_lnorm.weight,
        lnorm_lnorm.meanlog1 = lnorm_lnorm.meanlog1,
        lnorm_lnorm.sdlog1 = lnorm_lnorm.sdlog1,
        lnorm_lnorm.meanlog2 = lnorm_lnorm.meanlog2,
        lnorm_lnorm.sdlog2 = lnorm_lnorm.sdlog2,
        lnorm_lnorm.pmix = lnorm_lnorm.pmix,
        weibull.weight = weibull.weight,
        weibull.shape = weibull.shape,
        weibull.scale = weibull.scale,
        lower.tail = lower.tail, log.p = log.p
  )
}

#' @describeIn ssd_q Quantile Function for Multiple Distributions
#' @export
#' @examples
#' 
#' # multi 
#' ssd_qmulti(0.5)
ssd_qmulti <- function(
    p, 
    burrIII3.weight = 0, 
    burrIII3.shape1 = 1, 
    burrIII3.shape2 = 1, 
    burrIII3.scale = 1, 
    gamma.weight = 1/6, 
    gamma.shape = 1, 
    gamma.scale = 1, 
    gompertz.weight = 0, 
    gompertz.location = 1, 
    gompertz.shape = 1, 
    invpareto.weight = 0, 
    invpareto.shape = 3, 
    invpareto.scale = 1, 
    lgumbel.weight = 1/6, 
    lgumbel.locationlog = 0, 
    lgumbel.scalelog = 1, 
    llogis.weight = 1/6, 
    llogis.locationlog = 0, 
    llogis.scalelog = 1, 
    llogis_llogis.weight = 0, 
    llogis_llogis.locationlog1 = 0, 
    llogis_llogis.scalelog1 = 1, 
    llogis_llogis.locationlog2 = 1, 
    llogis_llogis.scalelog2 = 1, 
    llogis_llogis.pmix = 0.5, 
    lnorm.weight = 1/6, 
    lnorm.meanlog = 0, 
    lnorm.sdlog = 1, 
    lnorm_lnorm.weight = 1/6, 
    lnorm_lnorm.meanlog1 = 0, 
    lnorm_lnorm.sdlog1 = 1, 
    lnorm_lnorm.meanlog2 = 1, 
    lnorm_lnorm.sdlog2 = 1, 
    lnorm_lnorm.pmix = 0.5, 
    weibull.weight = 1/6, 
    weibull.shape = 1, 
    weibull.scale = 1, 
    lower.tail = TRUE, log.p = FALSE) {
  qdist("multi",
        p = p,         
        burrIII3.weight = burrIII3.weight,
        burrIII3.shape1 = burrIII3.shape1,
        burrIII3.shape2 = burrIII3.shape2,
        burrIII3.scale = burrIII3.scale,
        gamma.weight = gamma.weight,
        gamma.shape = gamma.shape,
        gamma.scale = gamma.scale,
        gompertz.weight = gompertz.weight,
        gompertz.location = gompertz.location,
        gompertz.shape = gompertz.shape,
        invpareto.weight = invpareto.weight,
        invpareto.shape = invpareto.shape,
        invpareto.scale = invpareto.scale,
        lgumbel.weight = lgumbel.weight,
        lgumbel.locationlog = lgumbel.locationlog,
        lgumbel.scalelog = lgumbel.scalelog,
        llogis.weight = llogis.weight,
        llogis.locationlog = llogis.locationlog,
        llogis.scalelog = llogis.scalelog,
        llogis_llogis.weight = llogis_llogis.weight,
        llogis_llogis.locationlog1 = llogis_llogis.locationlog1,
        llogis_llogis.scalelog1 = llogis_llogis.scalelog1,
        llogis_llogis.locationlog2 = llogis_llogis.locationlog2,
        llogis_llogis.scalelog2 = llogis_llogis.scalelog2,
        llogis_llogis.pmix = llogis_llogis.pmix,
        lnorm.weight = lnorm.weight,
        lnorm.meanlog = lnorm.meanlog,
        lnorm.sdlog = lnorm.sdlog,
        lnorm_lnorm.weight = lnorm_lnorm.weight,
        lnorm_lnorm.meanlog1 = lnorm_lnorm.meanlog1,
        lnorm_lnorm.sdlog1 = lnorm_lnorm.sdlog1,
        lnorm_lnorm.meanlog2 = lnorm_lnorm.meanlog2,
        lnorm_lnorm.sdlog2 = lnorm_lnorm.sdlog2,
        lnorm_lnorm.pmix = lnorm_lnorm.pmix,
        weibull.weight = weibull.weight,
        weibull.shape = weibull.shape,
        weibull.scale = weibull.scale,
        lower.tail = lower.tail, log.p = log.p
  )
}

#' @describeIn ssd_r Random Generation for Multiple Distributions
#' @export
#' @examples
#' 
#' # multi 
#' set.seed(50)
#' hist(ssd_rmulti(1000), breaks = 100)
ssd_rmulti <- function(
    n,     
    burrIII3.weight = 0, 
    burrIII3.shape1 = 1, 
    burrIII3.shape2 = 1, 
    burrIII3.scale = 1, 
    gamma.weight = 1/6, 
    gamma.shape = 1, 
    gamma.scale = 1, 
    gompertz.weight = 0, 
    gompertz.location = 1, 
    gompertz.shape = 1, 
    invpareto.weight = 0, 
    invpareto.shape = 3, 
    invpareto.scale = 1, 
    lgumbel.weight = 1/6, 
    lgumbel.locationlog = 0, 
    lgumbel.scalelog = 1, 
    llogis.weight = 1/6, 
    llogis.locationlog = 0, 
    llogis.scalelog = 1, 
    llogis_llogis.weight = 0, 
    llogis_llogis.locationlog1 = 0, 
    llogis_llogis.scalelog1 = 1, 
    llogis_llogis.locationlog2 = 1, 
    llogis_llogis.scalelog2 = 1, 
    llogis_llogis.pmix = 0.5, 
    lnorm.weight = 1/6, 
    lnorm.meanlog = 0, 
    lnorm.sdlog = 1, 
    lnorm_lnorm.weight = 1/6, 
    lnorm_lnorm.meanlog1 = 0, 
    lnorm_lnorm.sdlog1 = 1, 
    lnorm_lnorm.meanlog2 = 1, 
    lnorm_lnorm.sdlog2 = 1, 
    lnorm_lnorm.pmix = 0.5, 
    weibull.weight = 1/6, 
    weibull.shape = 1, 
    weibull.scale = 1, 
    chk = TRUE) {
  rdist("multi",
        n = n, 
        burrIII3.weight = burrIII3.weight,
        burrIII3.shape1 = burrIII3.shape1,
        burrIII3.shape2 = burrIII3.shape2,
        burrIII3.scale = burrIII3.scale,
        gamma.weight = gamma.weight,
        gamma.shape = gamma.shape,
        gamma.scale = gamma.scale,
        gompertz.weight = gompertz.weight,
        gompertz.location = gompertz.location,
        gompertz.shape = gompertz.shape,
        invpareto.weight = invpareto.weight,
        invpareto.shape = invpareto.shape,
        invpareto.scale = invpareto.scale,
        lgumbel.weight = lgumbel.weight,
        lgumbel.locationlog = lgumbel.locationlog,
        lgumbel.scalelog = lgumbel.scalelog,
        llogis.weight = llogis.weight,
        llogis.locationlog = llogis.locationlog,
        llogis.scalelog = llogis.scalelog,
        llogis_llogis.weight = llogis_llogis.weight,
        llogis_llogis.locationlog1 = llogis_llogis.locationlog1,
        llogis_llogis.scalelog1 = llogis_llogis.scalelog1,
        llogis_llogis.locationlog2 = llogis_llogis.locationlog2,
        llogis_llogis.scalelog2 = llogis_llogis.scalelog2,
        llogis_llogis.pmix = llogis_llogis.pmix,
        lnorm.weight = lnorm.weight,
        lnorm.meanlog = lnorm.meanlog,
        lnorm.sdlog = lnorm.sdlog,
        lnorm_lnorm.weight = lnorm_lnorm.weight,
        lnorm_lnorm.meanlog1 = lnorm_lnorm.meanlog1,
        lnorm_lnorm.sdlog1 = lnorm_lnorm.sdlog1,
        lnorm_lnorm.meanlog2 = lnorm_lnorm.meanlog2,
        lnorm_lnorm.sdlog2 = lnorm_lnorm.sdlog2,
        lnorm_lnorm.pmix = lnorm_lnorm.pmix,
        weibull.weight = weibull.weight,
        weibull.shape = weibull.shape,
        weibull.scale = weibull.scale,
        chk = chk
  )
}

#' @describeIn ssd_e Default Parameter Values for Multiple Distributions
#' @inheritParams params
#' @export
#' @examples
#'
#' ssd_emulti()
ssd_emulti <- function(dists = ssd_dists(bcanz = TRUE)) {
  chk_character(dists)
  chk_not_any_na(dists)
  chk_subset(dists, ssd_dists())
  check_dim(dists)
  
  emulti <- emulti_ssd(dists)
  as.list(unlist(emulti))
}

.ssd_pmulti_fitdists <- function(q, fitdists, lower.tail = TRUE, log.p = FALSE) {
  args <- estimates(fitdists)
  args$q <- q
  args$lower.tail <- lower.tail
  args$log.p <- log.p
  do.call("ssd_pmulti", args)
}

.ssd_qmulti_fitdists <- function(p, fitdists, lower.tail = TRUE, log.p = FALSE) {
  args <- estimates(fitdists)
  args$p <- p
  args$lower.tail <- lower.tail
  args$log.p <- log.p  
  do.call("ssd_qmulti", args)
}

.ssd_rmulti_fitdists <- function(n, fitdists, chk = TRUE) {
  args <- estimates(fitdists)
  args$n <- n
  args$chk <- chk
  do.call("ssd_rmulti", args)
}

emulti_ssd <- function(dists = ssd_dists_all()) {
  edists <- paste0("ssd_e", dists, ("()"))
  es <- purrr::map(edists, function(x) eval(parse(text = x)))
  names(es) <- dists
  wt <- 1/length(dists)
  purrr::map(es, function(x, wt) c(list(weight = wt), x), wt = wt)
}

value_args <- function(x) {
  x$weight <- NULL
  value_args <- purrr::imap_chr(x, function(x, y) paste(y, "=", x))
  paste0(value_args, collapse = ", ")
}

pmulti_dist <- function(x, dist) {
  fun <- paste0(x$weight, " * p", dist, "_ssd(q, ")
  value_args <- value_args(x)
  paste0(fun, value_args, ")")
}

pmulti_fun <- function(list) {
  funs <- purrr::imap_chr(list, pmulti_dist)
  fun <- paste0(funs, collapse = " + ")
  func <- paste0("function(q, p = 0) {(", fun, ") - p}")
  eval(parse(text = func))
}

normalize_weights <- function(list) {
  dlist <- purrr::keep(list, function(x) !is.na(x$weight) && x$weight > 0)
  if(!length(dlist)) {
    err("At least one distribution must have a positive weight.")
  }
  weights <- purrr::map_dbl(dlist, function(x) x$weight)
  wts <- weights / sum(weights)
  wlist <- purrr::map2(dlist, wts, function(x, wt) { x$weight <- wt; x})
  wlist
}

pmulti_list <- function(q, list) {
  nlist <- normalize_weights(list)
  fun <- pmulti_fun(nlist)
  fun(q)
}

qmulti_est <- function(x, dist, p) {
  fun <- paste0("q", dist, "_ssd(p, ")
  value_args <- value_args(x)
  func <- paste0(fun, value_args, ")")
  eval(parse(text = func))
}

qmulti_ranges <- function(p, list) {
  elist <- purrr::imap(list, qmulti_est, p = p)
  tlist <- purrr::transpose(elist)
  tlist <- purrr::map(tlist, unlist)
  min <- purrr::map_dbl(tlist, min)
  max <- purrr::map_dbl(tlist, max)
  list(lower = min, upper = max)
}

qmulti_list <- function(p, list) {
  nlist <- normalize_weights(list)
  
  ranges <- qmulti_ranges(p, nlist)
  lower <- ranges$lower
  upper <- ranges$upper

  f <- pmulti_fun(nlist)
  q <- rep(NA_real_, length(p))
  for(i in seq_along(p)) {
    if(is.na(lower[i]) || lower[i] == upper[i]) {
      q[i] <- lower[i]
    } else {
      q[i] <- uniroot(f = f, p = p[i], lower = lower[i], upper = upper[i])$root
    }
  }
  q
}

pmulti_ssd <- function(
    q,
    burrIII3.weight, 
    burrIII3.shape1,
    burrIII3.shape2,
    burrIII3.scale,
    gamma.weight,
    gamma.shape,
    gamma.scale,
    gompertz.weight,
    gompertz.location,
    gompertz.shape,
    invpareto.weight,
    invpareto.shape,
    invpareto.scale,
    lgumbel.weight,
    lgumbel.locationlog,
    lgumbel.scalelog,
    llogis.weight,
    llogis.locationlog,
    llogis.scalelog,
    llogis_llogis.weight,
    llogis_llogis.locationlog1,
    llogis_llogis.scalelog1,
    llogis_llogis.locationlog2,
    llogis_llogis.scalelog2,
    llogis_llogis.pmix,
    lnorm.weight,
    lnorm.meanlog,
    lnorm.sdlog,
    lnorm_lnorm.weight,
    lnorm_lnorm.meanlog1,
    lnorm_lnorm.sdlog1,
    lnorm_lnorm.meanlog2,
    lnorm_lnorm.sdlog2,
    lnorm_lnorm.pmix,
    weibull.weight,
    weibull.shape,
    weibull.scale) {
  list <- .relist_estimates(
    list(burrIII3.weight = burrIII3.weight,
         burrIII3.shape1 = burrIII3.shape1,
         burrIII3.shape2 = burrIII3.shape2,
         burrIII3.scale = burrIII3.scale,
         gamma.weight = gamma.weight,
         gamma.shape = gamma.shape,
         gamma.scale = gamma.scale,
         gompertz.weight = gompertz.weight,
         gompertz.location = gompertz.location,
         gompertz.shape = gompertz.shape,
         invpareto.weight = invpareto.weight,
         invpareto.shape = invpareto.shape,
         invpareto.scale = invpareto.scale,
         lgumbel.weight = lgumbel.weight,
         lgumbel.locationlog = lgumbel.locationlog,
         lgumbel.scalelog = lgumbel.scalelog,
         llogis.weight = llogis.weight,
         llogis.locationlog = llogis.locationlog,
         llogis.scalelog = llogis.scalelog,
         llogis_llogis.weight = llogis_llogis.weight,
         llogis_llogis.locationlog1 = llogis_llogis.locationlog1,
         llogis_llogis.scalelog1 = llogis_llogis.scalelog1,
         llogis_llogis.locationlog2 = llogis_llogis.locationlog2,
         llogis_llogis.scalelog2 = llogis_llogis.scalelog2,
         llogis_llogis.pmix = llogis_llogis.pmix,
         lnorm.weight = lnorm.weight,
         lnorm.meanlog = lnorm.meanlog,
         lnorm.sdlog = lnorm.sdlog,
         lnorm_lnorm.weight = lnorm_lnorm.weight,
         lnorm_lnorm.meanlog1 = lnorm_lnorm.meanlog1,
         lnorm_lnorm.sdlog1 = lnorm_lnorm.sdlog1,
         lnorm_lnorm.meanlog2 = lnorm_lnorm.meanlog2,
         lnorm_lnorm.sdlog2 = lnorm_lnorm.sdlog2,
         lnorm_lnorm.pmix = lnorm_lnorm.pmix,
         weibull.weight = weibull.weight,
         weibull.shape = weibull.shape,
         weibull.scale = weibull.scale))
  
  pmulti_list(q, list)
}

qmulti_ssd <- function(
    q,
    burrIII3.weight, 
    burrIII3.shape1,
    burrIII3.shape2,
    burrIII3.scale,
    gamma.weight,
    gamma.shape,
    gamma.scale,
    gompertz.weight,
    gompertz.location,
    gompertz.shape,
    invpareto.weight,
    invpareto.shape,
    invpareto.scale,
    lgumbel.weight,
    lgumbel.locationlog,
    lgumbel.scalelog,
    llogis.weight,
    llogis.locationlog,
    llogis.scalelog,
    llogis_llogis.weight,
    llogis_llogis.locationlog1,
    llogis_llogis.scalelog1,
    llogis_llogis.locationlog2,
    llogis_llogis.scalelog2,
    llogis_llogis.pmix,
    lnorm.weight,
    lnorm.meanlog,
    lnorm.sdlog,
    lnorm_lnorm.weight,
    lnorm_lnorm.meanlog1,
    lnorm_lnorm.sdlog1,
    lnorm_lnorm.meanlog2,
    lnorm_lnorm.sdlog2,
    lnorm_lnorm.pmix,
    weibull.weight,
    weibull.shape,
    weibull.scale) {
  
  list <- .relist_estimates(
    list(burrIII3.weight = burrIII3.weight,
         burrIII3.shape1 = burrIII3.shape1,
         burrIII3.shape2 = burrIII3.shape2,
         burrIII3.scale = burrIII3.scale,
         gamma.weight = gamma.weight,
         gamma.shape = gamma.shape,
         gamma.scale = gamma.scale,
         gompertz.weight = gompertz.weight,
         gompertz.location = gompertz.location,
         gompertz.shape = gompertz.shape,
         invpareto.weight = invpareto.weight,
         invpareto.shape = invpareto.shape,
         invpareto.scale = invpareto.scale,
         lgumbel.weight = lgumbel.weight,
         lgumbel.locationlog = lgumbel.locationlog,
         lgumbel.scalelog = lgumbel.scalelog,
         llogis.weight = llogis.weight,
         llogis.locationlog = llogis.locationlog,
         llogis.scalelog = llogis.scalelog,
         llogis_llogis.weight = llogis_llogis.weight,
         llogis_llogis.locationlog1 = llogis_llogis.locationlog1,
         llogis_llogis.scalelog1 = llogis_llogis.scalelog1,
         llogis_llogis.locationlog2 = llogis_llogis.locationlog2,
         llogis_llogis.scalelog2 = llogis_llogis.scalelog2,
         llogis_llogis.pmix = llogis_llogis.pmix,
         lnorm.weight = lnorm.weight,
         lnorm.meanlog = lnorm.meanlog,
         lnorm.sdlog = lnorm.sdlog,
         lnorm_lnorm.weight = lnorm_lnorm.weight,
         lnorm_lnorm.meanlog1 = lnorm_lnorm.meanlog1,
         lnorm_lnorm.sdlog1 = lnorm_lnorm.sdlog1,
         lnorm_lnorm.meanlog2 = lnorm_lnorm.meanlog2,
         lnorm_lnorm.sdlog2 = lnorm_lnorm.sdlog2,
         lnorm_lnorm.pmix = lnorm_lnorm.pmix,
         weibull.weight = weibull.weight,
         weibull.shape = weibull.shape,
         weibull.scale = weibull.scale))
  
  qmulti_list(q, list)
}

rmulti_ssd <- function(
    n, 
    burrIII3.weight, 
    burrIII3.shape1,
    burrIII3.shape2,
    burrIII3.scale,
    gamma.weight,
    gamma.shape,
    gamma.scale,
    gompertz.weight,
    gompertz.location,
    gompertz.shape,
    invpareto.weight,
    invpareto.shape,
    invpareto.scale,
    lgumbel.weight,
    lgumbel.locationlog,
    lgumbel.scalelog,
    llogis.weight,
    llogis.locationlog,
    llogis.scalelog,
    llogis_llogis.weight,
    llogis_llogis.locationlog1,
    llogis_llogis.scalelog1,
    llogis_llogis.locationlog2,
    llogis_llogis.scalelog2,
    llogis_llogis.pmix,
    lnorm.weight,
    lnorm.meanlog,
    lnorm.sdlog,
    lnorm_lnorm.weight,
    lnorm_lnorm.meanlog1,
    lnorm_lnorm.sdlog1,
    lnorm_lnorm.meanlog2,
    lnorm_lnorm.sdlog2,
    lnorm_lnorm.pmix,
    weibull.weight,
    weibull.shape,
    weibull.scale) {
  p <- runif(n)
  
  list <- .relist_estimates(
    list(burrIII3.weight = burrIII3.weight,
         burrIII3.shape1 = burrIII3.shape1,
         burrIII3.shape2 = burrIII3.shape2,
         burrIII3.scale = burrIII3.scale,
         gamma.weight = gamma.weight,
         gamma.shape = gamma.shape,
         gamma.scale = gamma.scale,
         gompertz.weight = gompertz.weight,
         gompertz.location = gompertz.location,
         gompertz.shape = gompertz.shape,
         invpareto.weight = invpareto.weight,
         invpareto.shape = invpareto.shape,
         invpareto.scale = invpareto.scale,
         lgumbel.weight = lgumbel.weight,
         lgumbel.locationlog = lgumbel.locationlog,
         lgumbel.scalelog = lgumbel.scalelog,
         llogis.weight = llogis.weight,
         llogis.locationlog = llogis.locationlog,
         llogis.scalelog = llogis.scalelog,
         llogis_llogis.weight = llogis_llogis.weight,
         llogis_llogis.locationlog1 = llogis_llogis.locationlog1,
         llogis_llogis.scalelog1 = llogis_llogis.scalelog1,
         llogis_llogis.locationlog2 = llogis_llogis.locationlog2,
         llogis_llogis.scalelog2 = llogis_llogis.scalelog2,
         llogis_llogis.pmix = llogis_llogis.pmix,
         lnorm.weight = lnorm.weight,
         lnorm.meanlog = lnorm.meanlog,
         lnorm.sdlog = lnorm.sdlog,
         lnorm_lnorm.weight = lnorm_lnorm.weight,
         lnorm_lnorm.meanlog1 = lnorm_lnorm.meanlog1,
         lnorm_lnorm.sdlog1 = lnorm_lnorm.sdlog1,
         lnorm_lnorm.meanlog2 = lnorm_lnorm.meanlog2,
         lnorm_lnorm.sdlog2 = lnorm_lnorm.sdlog2,
         lnorm_lnorm.pmix = lnorm_lnorm.pmix,
         weibull.weight = weibull.weight,
         weibull.shape = weibull.shape,
         weibull.scale = weibull.scale))
  qmulti_list(p, list)
}
