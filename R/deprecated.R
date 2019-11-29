#' @describeIn ssd_plot_cf Deprecated Cullen and Frey Plot
#' @export
ssd_cfplot <- function(data, left = "Conc") {
  lifecycle::deprecate_soft("0.1.0", "ssd_cfplot()", "ssd_plot_cf()")
  ssd_plot_cf(data, left)
}
