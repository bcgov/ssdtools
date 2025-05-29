library(ssdtools)

withr::with_seed(42, {
  fits <- ssd_fit_dists(ssddata::ccme_boron)
  ssd_gof(fits)
  ssd_hc(fits, ci = TRUE)
  autoplot(fits)
  
  ggplot2::ggsave("paper/autoplot.png", device = "png", width = 6, height = 4)
  
  predictions <- ssdtools::predict(fits, ci = TRUE)
})
ssd_plot(ssddata::ccme_boron, predictions, 
         hc = 0.1, xlimits = c(NA, 3000),
         shape = "Group", color = "Group", label = "Species",
         xlab = "Concentration (mg/L)"
) +
  scale_color_ssd()

ggplot2::ggsave("paper/ssd_plot.png", device = "png", width = 7, height = 4)
