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
#' install.packages("devtools")
#' devtools::install_github("bcgov/ssdtools")
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
  dists = c("lnorm", "llogis", "gompertz", "lgumbel", "gamma", "weibull")
)

#' The `autoplot()` function can be used to plot the fits (for more information type `?autoplot.fitdists`)
ggplot2::autoplot(fits)

#' And `ssd_gof()` can be used to generate the goodness of fit statistics.
ssd_gof(fits)

#' ### Predict

#' The following code block does not use confidence intervals therefore we can use
#' just 10 bootstrap samples when generating the predictions -
#' unlike the upper and lower confidence limits, the precision of the
#' estimates is not affected by the number of bootstrap samples.
#' For more information type `?predict.fitdists`
pred <- predict(fits, nboot = 10L)

ssd_plot(data, pred,
  left = "Conc", label = "Species", color = "Group",
  xlab = "Concentration (mg/L)", ci = FALSE, hc = 5L, shift = 2
)

#' ### Hazard Concentration

#' To get precise confidence limits on the hazard concentration use at least 10,000 bootstrap samples.
#' Here for demonstrative purposes just 100 samples are used.
ssd_hc(fits, nboot = 100L)

#' ### Confidence Intervals
#'
#' To generate and plot precise confidence intervals run the following code.
#' It will take around 1 hour to complete
#' ```
#'  pred <- predict(fits, nboot = 10000L)
#'  ssd_plot(data, pred, left = "Conc", label = "Species", color = "Group",
#'           xlab = "Concentration (mg/L)", hc = 5)
#' ```
