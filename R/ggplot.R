plot_coord_scale <- function(data, xlab, ylab) {
  check_string(xlab)
  check_string(ylab)

  list(
    coord_trans(x = "log10"),
    scale_x_continuous(xlab, breaks = scales::trans_breaks("log10", function(x) 10^x),
                       labels = comma_signif),
    scale_y_continuous(ylab, labels = percent, limits = c(0, 1),
                       breaks = seq(0,1,by = 0.25), expand = c(0,0))
  )
}
