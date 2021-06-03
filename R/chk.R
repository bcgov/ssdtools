
.chk_orders <- function(orders) {
  chk_numeric(orders)
  chk_gte(orders)
  chk_named(orders)
  chk_subset(names(orders), c("left", "right"))
  chk_unique(names(orders))
  invisible(orders)
}
