# install.packages("ssdtools")
library(ssdtools)
library(ggplot2)

dists <- ssd_fit_dists(ssddata::ccme_boron)
hc <- ssd_hc(dists)

gp <- autoplot(dists) +
  geom_hcintersect(data = hc, aes(xintercept = est, yintercept = percent/100))

print(gp)

ggsave("paper/dists.png", width = 6, height = 4)
