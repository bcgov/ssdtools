## ----setup, include = FALSE----------------------------------------------
knitr::opts_chunk$set(
  collapse = TRUE,
  comment = "#>",
  fig.width = 3,
  fig.height = 3
)
library(ssdtools)

## ---- fig.width = 5, fig.height = 5--------------------------------------
ssd_cfplot(boron_data)

## ------------------------------------------------------------------------
library(ssdtools)
boron_data
boron_dists2 <- ssd_fit_dists(boron_data, dists = c("lnorm", "weibull"))
boron_dists2

## ------------------------------------------------------------------------
lapply(boron_dists2, coef)

## ---- fig.width=6, fig.height=6, fig.show='hold'-------------------------
plot(boron_dists2)

## ------------------------------------------------------------------------
boron_dists <- ssd_fit_dists(boron_data)
ssd_gof(boron_dists)

## ---- fig.width = 5------------------------------------------------------
autoplot(boron_dists)

## ---- fig.width = 5------------------------------------------------------
autoplot(boron_dists) + theme_bw() + ggtitle("Species Sensitivity Distributions for Boron")

## ------------------------------------------------------------------------
ssd_hc(boron_dists)

## ------------------------------------------------------------------------
ssd_hc(boron_dists, average = FALSE)

## ------------------------------------------------------------------------
ssd_hc(boron_dists, hc = 5L)

## ---- eval = FALSE-------------------------------------------------------
#  boron_pred <- predict(boron_dists)

## ------------------------------------------------------------------------
boron_pred

## ---- fig.width = 6, fig.height = 4--------------------------------------
theme_set(theme_bw()) # change the theme
ssd_plot(boron_data, boron_pred, shape = "Group", color = "Group", label = "Species",
         ylab = "Concentration (mg/L)") + 
  expand_limits(x = 5000) + # to ensure the species labels fit
  scale_color_manual(values = c("Amphibian" = "Black", "Fish" = "Blue", 
                                "Invertebrate" = "Red", "Plant" = "Brown")) +
  ggtitle("Species Sensitivity for Boron")

## ---- error = TRUE-------------------------------------------------------
boron_data$Weight <- as.integer(boron_data$Group)
fit <- ssd_fit_dists(boron_data, weight = "Weight", dists = c("lnorm", "weibull"))
fit
plot(fit)

## ------------------------------------------------------------------------
data(fluazinam, package = "fitdistrplus")
head(fluazinam)

## ------------------------------------------------------------------------
fluazinam_dists <- ssd_fit_dists(fluazinam, left = "left", right = "right")
ssd_gof(fluazinam_dists)

## ---- eval = FALSE-------------------------------------------------------
#  fluazinam_pred <- predict(fluazinam_dists)

## ---- fig.width=5--------------------------------------------------------
ssd_plot(fluazinam, fluazinam_pred, 
         left = "left", right = "right", 
         ylab = "Concentration (mg/L)")

## ---- fig.width = 5, fig.height = 4--------------------------------------
gp <- ggplot(boron_pred, aes_string(x = "est")) + 
  geom_xribbon(aes_string(xmin = "lcl", xmax = "ucl", y = "percent/100"), alpha = 0.2) +
  geom_line(aes_string(y = "percent/100")) +
  geom_hcintersect(xintercept = boron_pred$est[boron_pred$percent == 5], yintercept = 5/100) +
  geom_ssd(data = boron_data, aes_string(x = "Conc"))
print(gp)

## ---- fig.width = 5, fig.height = 4--------------------------------------
gp <- gp + coord_trans(x = "log10") +
  scale_x_continuous(breaks = scales::trans_breaks("log10", function(x) 10^x),
                     labels = comma_signif)
print(gp)

