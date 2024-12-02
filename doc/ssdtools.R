## ----include = FALSE----------------------------------------------------------
knitr::opts_chunk$set(
  collapse = TRUE,
  comment = "#>",
  fig.width = 6,
  fig.height = 4
)

## ----eval = FALSE-------------------------------------------------------------
#  install.packages(c("ssdtools", "tidyverse"))

## ----message = FALSE----------------------------------------------------------
library(ssdtools)
library(ggplot2)

## ----eval = FALSE-------------------------------------------------------------
#  data <- read_csv(file = "path/to/file.csv")

## -----------------------------------------------------------------------------
ssddata::ccme_boron

## -----------------------------------------------------------------------------
ssd_dists_all()

## -----------------------------------------------------------------------------
fits <- ssd_fit_dists(ssddata::ccme_boron, dists = c("llogis", "lnorm", "gamma"))

## -----------------------------------------------------------------------------
tidy(fits)

## ----fig.alt="A plot of the CCME boron dataset with the gamma, log-logistic and log-normal distributions with a simple black and white background color scheme."----
theme_set(theme_bw()) # set plot theme

autoplot(fits) +
  ggtitle("Species Sensitivity Distributions for Boron") +
  scale_colour_ssd()

## -----------------------------------------------------------------------------
ssd_gof(fits)

## ----eval = FALSE-------------------------------------------------------------
#  set.seed(99)
#  boron_pred <- predict(fits, ci = TRUE)

## -----------------------------------------------------------------------------
boron_pred

## ----fig.alt="A plot of the CCME boron dataset species colored by group and the model average species sensitivity distribution with a simple black and white background color scheme."----
ssd_plot(ssddata::ccme_boron, boron_pred,
  color = "Group", label = "Species",
  xlab = "Concentration (mg/L)", ribbon = TRUE
) +
  expand_limits(x = 5000) + # to ensure the species labels fit
  ggtitle("Species Sensitivity for Boron") +
  scale_colour_ssd()

## -----------------------------------------------------------------------------
set.seed(99)
boron_hc5 <- ssd_hc(fits, proportion = 0.05, ci = TRUE)
print(boron_hc5)
boron_pc <- ssd_hp(fits, conc = boron_hc5$est, ci = TRUE)
print(boron_pc)

## -----------------------------------------------------------------------------
boron_censored <- ssddata::ccme_boron |>
  dplyr::mutate(left = Conc, right = Conc)

boron_censored$left[c(3, 6, 8)] <- NA

## -----------------------------------------------------------------------------
dists <- ssd_fit_dists(boron_censored,
  dists = ssd_dists_bcanz(n = 2),
  left = "left", right = "right"
)

## -----------------------------------------------------------------------------
ssd_gof(dists)

## -----------------------------------------------------------------------------
ssd_hc(dists, average = FALSE)
ssd_hc(dists)

## ----fig.alt="A plot of the left censored CCME boron dataset with the model average species sensitivity distribution and arrows indicating the censoring."----
set.seed(99)
pred <- predict(dists, ci = TRUE, parametric = FALSE)

ssd_plot(boron_censored, pred,
  left = "left", right = "right",
  xlab = "Concentration (mg/L)"
)

## ----results = "asis", echo = FALSE-------------------------------------------
cat(ssdtools::ssd_licensing_md())

