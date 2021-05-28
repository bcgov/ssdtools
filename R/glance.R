#' @importFrom generics glance
#' @export
generics::glance

.glance <- function(x, dist) {
  nobs <- nobs(x)
  npars <- npars(x)
  log_lik <- logLik(x)
  aic <- 2 * npars - 2 * log_lik
  aicc <- aic + 2 * npars * (npars + 1) / (nobs - npars - 1)
  
  tibble(
    dist = dist,
    npars = npars,
    nobs = nobs,
    log_lik = log_lik,
    aic = aic,
    aicc = aicc
  )
}

#' Construct a single row tibble::tibble() "glance" of a tmbfit model.
#' 
#' @param x A tmbfit object to be converted into a single row tibble::tibble.
#' @param ... Unused.
#'  
#' @export
glance.tmbfit <- function(x, ...) {
  dist <- .dist_tmbfit(x)
  .glance(x, dist)
}

#' Construct a tibble::tibble() with a single row "glance" for each tmbfit model.
#'
#' Turns a fitdists object into a glance tibble.
#' 
#' @param x A fitdists object to be converted into a tidy tibble::tibble().
#' @param ... Must be unused.
#'  
#' @export
glance.fitdists <- function(x, ...) {
  tbl <- lapply(x, glance)
  tbl <- bind_rows(tbl)
  tbl$delta <- tbl$aicc - min(tbl$aicc)
  if(is.na(tbl$delta[1]) && all(tbl$npars == tbl$npars[1])) {
    tbl$delta <- tbl$aicc - min(tbl$aicc)
  }
  tbl$weight <- exp(-tbl$delta / 2) / sum(exp(-tbl$delta / 2))
  tbl
}
