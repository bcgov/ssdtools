#' @describeIn ssd_plot_cf Deprecated Cullen and Frey Plot
#' @export
ssd_cfplot <- function(data, left = "Conc") {
  deprecate_soft("0.1.0", "ssd_cfplot()", "ssd_plot_cf()")
  ssd_plot_cf(data, left)
}

#' @rdname llogis
#' @export
dllog <- function(x, lshape = 0, lscale = 1, log = FALSE) {
  deprecate_soft("0.1.0", "dllog()", "dllogis()")
  dllogis(x, lshape = lshape, lscale = lscale, log = log)
}

#' @rdname llogis
#' @export
qllog <- function(p, lshape = 0, lscale = 1, lower.tail = TRUE, log.p = FALSE) {
  deprecate_soft("0.1.0", "qllog()", "qllogis()")
  qllogis(p, lshape = lshape, lscale = lscale, lower.tail = lower.tail, log.p = log.p)
}

#' @rdname llogis
#' @export
pllog <- function(q, lshape = 0, lscale = 1, lower.tail = TRUE, log.p = FALSE) {
  deprecate_soft("0.1.0", "pllog()", "pllogis()")
  pllogis(q, lshape = lshape, lscale = lscale, lower.tail = lower.tail, log.p = log.p)
}

#' @rdname llogis
#' @export
rllog <- function(n, lshape = 0, lscale = 1) {
  deprecate_soft("0.1.0", "rllog()", "rllogis()")
  rllogis(q, lshape = lshape, lscale = lscale)
}

#' @rdname llogis
#' @export
sllog <- function(x) {
  deprecate_soft("0.1.0", "sllog()", "sllogis()")
  sllogis(x)
}
