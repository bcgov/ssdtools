.censoring_fitdists <- function(fits) {
  attr(fits, "censoring", exact = TRUE)
}

.cols_fitdists <- function(fits) {
  attr(fits, "cols", exact = TRUE)
}

.control_fitdists <- function(fits) {
  attr(fits, "control", exact = TRUE)
}

.data_fitdists <- function(fits) {
  attr(fits, "data", exact = TRUE)
}

.org_data_fitdists <- function(fits) {
  attr(fits, "org_data", exact = TRUE)
}

.rescale_fitdists <- function(fits) {
  attr(fits, "rescale", exact = TRUE)
}

.weighted_fitdists <- function(fits) {
  attr(fits, "weighted", exact = TRUE)
}

`.censoring_fitdists<-` <- function(fits, value) {
  attr(fits, "censoring") <- value
  fits
}

`.cols_fitdists<-` <- function(fits, value) {
  attr(fits, "cols") <- value
  fits
}

`.control_fitdists<-` <- function(fits, value) {
  attr(fits, "control") <- value
  fits
}

`.data_fitdists<-` <- function(fits, value) {
  attr(fits, "data") <- value
  fits
}

`.org_data_fitdists<-` <- function(fits, value) {
  attr(fits, "org_data") <- value
  fits
}

`.rescale_fitdists<-` <- function(fits, value) {
  attr(fits, "rescale") <- value
  fits
}

`.weighted_fitdists<-` <- function(fits, value) {
  attr(fits, "weighted") <- value
  fits
}

.attrs_fitdists <- function(fits) {
  attrs <- attributes(fits)
  attrs[c("censoring", "cols", "control", "data", "org_data", "rescale", "weighted")]
}

`.attrs_fitdists<-` <- function(fits, value) {
  .censoring_fitdists(fits) <- value$censoring
  .control_fitdists(fits) <- value$control
  .cols_fitdists(fits) <- value$cols
  .data_fitdists(fits) <- value$data
  .org_data_fitdists(fits) <- value$org_data
  .rescale_fitdists(fits) <- value$rescale
  .weighted_fitdists(fits) <- value$weighted
  fits
}
