#' @importFrom generics tidy
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
  capture.output(x <- TMB::sdreport(x$model))
  x <- summary(x)
  term <- rownames(x)
  est <- unname(x[,1])
  se <- unname(x[,2])
  x <- tibble::tibble(dist = dist, term = term, est = est, se = se)
  
  if(!all)
    x <- x[!grepl("^log(it){0,1}_", x$term),]
  dplyr::arrange(x, str_order(.data$term))
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
 x <- purrr::map_df(x, .f = tidy, all = all)
 x <- dplyr::arrange(x, str_order(.data$dist))
 x
}
