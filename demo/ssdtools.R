#' ---
#' title: "Species Sensitivity Distribution Analysis Demonstration"
#' author: "Joe Thorley"
#' date: "February 14th, 2018"
#' output: html_document
#' ---

#' ## Introduction

#' This script demonstrates the use of the `ssdtools` package to perform
#' a species sensitivity distribution analysis consistent with the
#' associated shiny app with confidence intervals.
#'
#' To get more information on a function type `?` followed by the name of the
#' function.
#'
#' ## Demonstration
#'
#' ### ssdtools
#' First, install and then load the `ssdtools` R package.
#' ```
#' install.packages("ssdtools")
#' ```
library(ssdtools)

#' ### Data

#' Next, load the data set.
file <- system.file("extdata", "boron_data.csv", package = "ssdtools")
data <- read.csv(file)
head(data)

#' ### Fit

#' Then fit one or more distributions to the data. Don't forget to specify
#' the column with the concentration values.
fits <- ssd_fit_dists(data,
  left = "Conc",
  dists = c("burrIII2", "lnorm", "gamma")
)

#' The `autoplot()` function can be used to plot the fits (for more information type `?autoplot.fitdists`)
ggplot2::autoplot(fits)

#' And `ssd_gof()` can be used to generate the goodness of fit statistics.
ssd_gof(fits)

#' ### Hazard Concentration

#' The `ssd_hc()` function returns the hazard concentration.
#' If `ci = TRUE` confidence intervals are estimated by parameteric bootstrapping.
ssd_hc(fits, ci = TRUE)

#' ### Predict
#'
#' By default the generic `predict()` function predicts the species affected.
pred <- predict(fits, ci = TRUE)

ssd_plot(data, pred,
  left = "Conc", label = "Species", color = "Group",
  xlab = "Concentration (mg/L)", hc = 5
) +
  expand_limits(x = 3000)
