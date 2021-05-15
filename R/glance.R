#' @importFrom generics glance
#' @export
generics::glance

#' Construct a single row tibble::tibble() "glance" of a tmbfit model.
#' 
#' @param x A tmbfit object to be converted into a single row tibble::tibble.
#' @param ... Unused.
#'  
#' @export
glance.tmbfit <- function(x, ...) {
  dist <- .dist_tmbfit(x)
  nobs <- nobs(x)
  npars <- npars(x)
  log_lik <- logLik(x)
  aic <- 2 * npars - 2 * log_lik
  aicc <- aic + 2 * npars * (npars + 1) / (nobs - npars - 1)

  tibble::tibble(
    dist = dist,
    npars = npars,
    nobs = nobs,
    log_lik = log_lik,
    aic = aic,
    aicc = aicc
  )
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
  tbl <- x %>% 
    purrr::map_df(.f = glance) %>%
    dplyr::mutate(delta = .data$aicc - min(.data$aicc))
  if(is.na(tbl$delta[1]) && all(tbl$npars == tbl$npars[1])) {
    tbl %<>% dplyr::mutate(delta = .data$aicc - min(.data$aicc))
  }
  tbl %<>% dplyr::mutate(
    weight = exp(-.data$delta / 2) / sum(exp(-.data$delta / 2))) %>%
    dplyr::arrange(stringr::str_order(.data$dist))
  tbl
}
