#' @describeIn ssd_plot_cf Deprecated Cullen and Frey Plot
#' @export
ssd_cfplot <- function(data, left = "Conc") {
  deprecate_soft("0.1.0", "ssd_cfplot()", "ssd_plot_cf()")
  ssd_plot_cf(data, left)
}

#' @rdname llogis
#' @export
dllog <- function(x, shapelog = 0, scalelog = 1, log = FALSE) {
  deprecate_soft("0.1.0", "dllog()", "dllogis()")
  dllogis(x, shapelog = shapelog, scalelog = scalelog, log = log)
}

#' @rdname llogis
#' @export
qllog <- function(p, shapelog = 0, scalelog = 1, lower.tail = TRUE, log.p = FALSE) {
  deprecate_soft("0.1.0", "qllog()", "qllogis()")
  qllogis(p, shapelog = shapelog, scalelog = scalelog, lower.tail = lower.tail, log.p = log.p)
}

#' @rdname llogis
#' @export
pllog <- function(q, shapelog = 0, scalelog = 1, lower.tail = TRUE, log.p = FALSE) {
  deprecate_soft("0.1.0", "pllog()", "pllogis()")
  pllogis(q, shapelog = shapelog, scalelog = scalelog, lower.tail = lower.tail, log.p = log.p)
}

#' @rdname llogis
#' @export
rllog <- function(n, shapelog = 0, scalelog = 1) {
  deprecate_soft("0.1.0", "rllog()", "rllogis()")
  rllogis(q, shapelog = shapelog, scalelog = scalelog)
}

#' @rdname llogis
#' @export
sllog <- function(x) {
  deprecate_soft("0.1.0", "sllog()", "sllogis()")
  sllogis(x)
}
