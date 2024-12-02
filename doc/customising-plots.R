## ----include = FALSE----------------------------------------------------------
knitr::opts_chunk$set(
  collapse = TRUE,
  comment = "#>",
  fig.width = 6,
  fig.height = 4
)

## ----warning=FALSE, message=FALSE, fig.alt="A plot of the CCME boron data with the six default distributions."----
library(ssdtools)
library(ggplot2)

fits <- ssd_fit_dists(ssddata::ccme_boron)
ssd_plot_cdf(fits)

## ----fig.alt="A plot of the CCME boron data with the model average distribution and the six default distributions."----
ssd_plot_cdf(fits, average = NA, big.mark = " ") + 
  scale_color_manual(name = "Distribution", breaks = c("average", names(fits)), values = 1:7) +
  theme_bw()

## ----fig.alt = "A plot of the CCME boron data."-------------------------------
ggplot(ssddata::ccme_boron) +
  geom_ssdpoint(aes(x = Conc)) +
  ylab("Probability density") +
  xlab("Concentration")

## ----fig.alt = "A plot of CCME boron data with the ranges of the censored data indicated by horizontal lines."----
ggplot(ssddata::ccme_boron) +
  geom_ssdsegment(aes(x = Conc, xend = Conc * 4)) +
  ylab("Probability density") +
  xlab("Concenration")

## ----fig.alt="A plot of the confidence intervals for the CCME boron data."----
ggplot(boron_pred) +
  geom_xribbon(aes(xmin = lcl, xmax = ucl, y = proportion)) +
  ylab("Probability density") +
  xlab("Concenration")

## ----fig.alt="A plot of hazard concentrations as dotted lines."---------------
ggplot() +
  geom_hcintersect(xintercept = c(1, 2, 3), yintercept = c(0.05, 0.1, 0.2)) +
  ylab("Probability density") +
  xlab("Concenration")

## ----fig.alt="A plot of censored CCME boron data with confidence intervals"----
gp <- ggplot(boron_pred, aes(x = est)) +
  geom_xribbon(aes(xmin = lcl, xmax = ucl, y = proportion), alpha = 0.2) +
  geom_line(aes(y = proportion)) +
  geom_ssdsegment(data = ssddata::ccme_boron, aes(x = Conc / 2, xend = Conc * 2)) +
  geom_ssdpoint(data = ssddata::ccme_boron, aes(x = Conc / 2)) +
  geom_ssdpoint(data = ssddata::ccme_boron, aes(x = Conc * 2)) +
  scale_y_continuous("Species Affected (%)", labels = scales::percent) +
  xlab("Concentration (mg/L)") +
  expand_limits(y = c(0, 1))

gp

## ----fig.alt="A plot of censored CCME boron data on log scale with confidence intervals, mathematical and the 5% hazard concentration."----
gp + 
  scale_x_log10(
    latex2exp::TeX("Boron $(\\mu g$/L)$")
  ) +
  geom_hcintersect(xintercept = ssd_hc(fits)$est, yintercept = 0.05)

## ----eval = FALSE-------------------------------------------------------------
#  ggsave("file_name.png", dpi = 300)

## ----results = "asis", echo = FALSE-------------------------------------------
cat(ssdtools::ssd_licensing_md())

