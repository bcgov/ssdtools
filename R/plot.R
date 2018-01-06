plot_fitdist <- function(x, breaks = "default", ...) {
  par(oma=c(0,0,2,0))
  plot(x, breaks = breaks, ...)
  title(paste("Distribution:", x$distname), outer = TRUE)
}

#' @export
plot.fitdists <- function(x, breaks = "default", ...) {
  walk(x, plot_fitdist, breaks = breaks, ...)
  invisible()
}

#' #' Plot Species Sensitivity Data and Prediction
#' #'
#' #' @export
#' ssd_plot <- function(data, prediction) {
#'   check_data(data)
#'   check_data(prediction, values = list(
#'     prob = c(0,1),
#'     est = c(0, Inf),
#'     lcl = c(0, Inf),
#'     ucl = c(0, Inf)))
#' }
