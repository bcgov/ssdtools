# install.packages("ssdtools")
library(ssdtools)
library(ggplot2)
library(ggpubr)

dists <- ssd_fit_dists(ssddata::ccme_boron)
hc <- ssd_hc(dists)


plot_dists <- autoplot(dists) +
  ggtitle(label="A) All distributions") +  theme(legend.title=element_blank()) +
  theme(legend.position = c(0.2, 0.6))

pred <- ssdtools::predict(dists, ci = TRUE, weighted = TRUE, multi_ci = FALSE)
plot_averaged <- ssd_plot(ssddata::ccme_boron, pred, 
                          hc = 0.05, ci = TRUE) +
  ggtitle(label="B) Model averaged")


ggarrange(plot_dists, plot_averaged)
ggsave("paper/dists.png", width = 10, height = 4)


