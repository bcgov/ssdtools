## ----include = FALSE----------------------------------------------------------
knitr::opts_chunk$set(
  collapse = TRUE,
  comment = "#>",
  fig.width = 6,
  fig.height = 4
)
library(tinytex)

## ----include=FALSE------------------------------------------------------------
# this just loads the package and suppresses the load package message
library(ssdtools)
require(ggplot2)

## ----echo=FALSE,warning=FALSE, message=FALSE,class.output="scroll-100"--------
samp <- c(1.73, 0.57, 0.33, 0.28, 0.3, 0.29, 2.15, 0.8, 0.76, 0.54, 0.42, 0.83, 0.21, 0.18, 0.59)
print(samp)
# knitr::kable(samp,caption="Some toxicity data (concentrations)")

## ----echo=FALSE,fig.cap="Emprirical cdf (black); Model 1(green); and Model 2 (blue)", fig.width=7,fig.height=4.5----
samp <- c(1.73, 0.57, 0.33, 0.28, 0.3, 0.29, 2.15, 0.8, 0.76, 0.54, 0.42, 0.83, 0.21, 0.18, 0.59)
samp <- sort(samp)
plot(ecdf(samp), main = "Empirical and fitted SSDs", xlab = "Concentration", ylab = "Probability")
xx <- seq(0.01, 3, by = 0.01)
lines(xx, plnorm(xx, meanlog = mean(log(samp[1:10])), sd = sd(log(samp[1:10]))), col = "#77d408")
lines(xx, plnorm(xx, meanlog = mean(log(samp[5:15])), sd = sd(log(samp[5:15]))), col = "#08afd4")
# lines(xx,(0.4419*plnorm(xx,meanlog=mean(log(samp[5:15])),sd=sd(log(samp[5:15])))+
#          0.5581*plnorm(xx,meanlog=mean(log(samp[1:10])),sd=sd(log(samp[1:10]))))  ,col="#d40830")

## ----echo=FALSE,fig.cap="Empirical cdf (black); Model 1(green); Model 2 (blue); and averaged Model (red)",fig.width=7,fig.height=4.5----
samp <- c(1.73, 0.57, 0.33, 0.28, 0.3, 0.29, 2.15, 0.8, 0.76, 0.54, 0.42, 0.83, 0.21, 0.18, 0.59)
samp <- sort(samp)
plot(ecdf(samp), main = "Empirical and fitted SSDs", xlab = "Concentration", ylab = "Probability")
xx <- seq(0.01, 3, by = 0.01)
lines(xx, plnorm(xx, meanlog = mean(log(samp[1:10])), sd = sd(log(samp[1:10]))), col = "#77d408")
lines(xx, plnorm(xx, meanlog = mean(log(samp[5:15])), sd = sd(log(samp[5:15]))), col = "#08afd4")
lines(xx, (0.4419 * plnorm(xx, meanlog = mean(log(samp[5:15])), sd = sd(log(samp[5:15]))) +
  0.5581 * plnorm(xx, meanlog = mean(log(samp[1:10])), sd = sd(log(samp[1:10])))), col = "#d40830")

## ----echo=TRUE----------------------------------------------------------------
# Model 1 HC20
cat("Model 1 HC20 =", qlnorm(0.2, -1.067, 0.414))

# Model 2 HC20
cat("Model 2 HC20 =", qlnorm(0.2, -0.387, 0.617))

## ----echo=FALSE,fig.width=7,fig.height=5--------------------------------------
samp <- c(1.73, 0.57, 0.33, 0.28, 0.3, 0.29, 2.15, 0.8, 0.76, 0.54, 0.42, 0.83, 0.21, 0.18, 0.59)
samp <- sort(samp)
xx <- seq(0.01, 3, by = 0.01)


plot(xx, (0.4419 * plnorm(xx, meanlog = mean(log(samp[5:15])), sd = sd(log(samp[5:15]))) +
  0.5581 * plnorm(xx, meanlog = mean(log(samp[1:10])), sd = sd(log(samp[1:10])))),
col = "#d40830", type = "l", xlab = "Concentration", ylab = "Probability"
)
segments(0.33, -1, 0.33, 0.292, col = "blue", lty = 21)
segments(-1, 0.292, 0.33, 0.292, col = "blue", lty = 21)
mtext("0.3", side = 2, at = 0.3, cex = 0.8, col = "blue")
mtext("0.33", side = 1, at = 0.33, cex = 0.8, col = "blue")

## ----echo=FALSE, fig.width=8,fig.height=6-------------------------------------
t <- seq(0.01, 0.99, by = 0.001)


F <- 0.4419 * qlnorm(t, -1.067, 0.414) + 0.5581 * qlnorm(t, -0.387, 0.617)

plot(xx, (0.4419 * plnorm(xx, meanlog = mean(log(samp[5:15])), sd = sd(log(samp[5:15]))) +
  0.5581 * plnorm(xx, meanlog = mean(log(samp[1:10])), sd = sd(log(samp[1:10])))),
col = "#d40830", type = "l", xlab = "Concentration", ylab = "Probability"
)

lines(F, t, col = "#51c157", lwd = 1.75)

segments(-1, 0.2, 0.34, 0.2, col = "black", lty = 21, lwd = 2)
segments(0.28, 0.2, 0.28, -1, col = "red", lty = 21, lwd = 2)
segments(0.34, 0.2, 0.34, -1, col = "#51c157", lty = 21, lwd = 2)
segments(1.12, -1, 1.12, 0.9, col = "grey", lty = 21, lwd = 1.7)

text(0.25, 0.6, "Correct MA-SSD", col = "red", cex = 0.75)
text(0.75, 0.4, "Erroneous MA-SSD", col = "#51c157", cex = 0.75)
mtext("1.12", side = 1, at = 1.12, cex = 0.8, col = "grey")

## ----echo=FALSE,warning=FALSE, results="markup",message=FALSE,class.output="scroll-100"----
samp <- c(1.73, 0.57, 0.33, 0.28, 0.3, 0.29, 2.15, 0.8, 0.76, 0.54, 0.42, 0.83, 0.21, 0.18, 0.59)
print(samp)
# knitr::kable(samp,caption="Some toxicity data (concentrations)")

## ----echo=TRUE,results='hide',warning=FALSE,message=FALSE---------------------
dat <- data.frame(Conc = c(1.73, 0.57, 0.33, 0.28, 0.3, 0.29, 2.15, 0.8, 0.76, 0.54, 0.42, 0.83, 0.21, 0.18, 0.59))
library(goftest)
library(EnvStats) # this is required for the Pareto cdf (ppareto)

# Examine the fit for the gamma distribution (NB: parameters estimated from the data)
cvm.test(dat$Conc, null = "pgamma", shape = 2.0591977, scale = 0.3231032, estimated = TRUE)

# Examine the fit for the lognormal distribution (NB: parameters estimated from the data)
cvm.test(dat$Conc, null = "plnorm", meanlog = -0.6695120, sd = 0.7199573, estimated = TRUE)

# Examine the fit for the Pareto distribution (NB: parameters estimated from the data)
cvm.test(dat$Conc, null = "ppareto", location = 0.1800000, shape = 0.9566756, estimated = TRUE)

## ----echo=FALSE,fig.cap="Emprirical cdf (black); lognormal (green); gamma (blue); and Pareeto (red)", fig.width=7,fig.height=4.5----
library(EnvStats)
samp <- c(1.73, 0.57, 0.33, 0.28, 0.3, 0.29, 2.15, 0.8, 0.76, 0.54, 0.42, 0.83, 0.21, 0.18, 0.59)
samp <- sort(samp)
plot(ecdf(samp), main = "Empirical and fitted SSDs", xlab = "Concentration", ylab = "Probability")
xx <- seq(0.01, 3, by = 0.01)
lines(xx, plnorm(xx, meanlog = -0.6695120, sd = 0.7199573), col = "#77d408")
lines(xx, pgamma(xx, shape = 2.0591977, scale = 0.3231032), col = "#08afd4")
lines(xx, ppareto(xx, location = 0.1800000, shape = 0.9566756), col = "red")
# lines(xx,(0.4419*plnorm(xx,meanlog=mean(log(samp[5:15])),sd=sd(log(samp[5:15])))+
#          0.5581*plnorm(xx,meanlog=mean(log(samp[1:10])),sd=sd(log(samp[1:10]))))  ,col="#d40830")

## ----echo=TRUE----------------------------------------------------------------
sum(log(dgamma(dat$Conc, shape = 2.0591977, scale = 0.3231032)))
sum(log(dlnorm(dat$Conc, meanlog = -0.6695120, sdlog = 0.7199573)))
sum(log(EnvStats::dpareto(dat$Conc, location = 0.1800000, shape = 0.9566756)))

## ----echo=FALSE,results='markup'----------------------------------------------
dat <- c(1.73, 0.57, 0.33, 0.28, 0.3, 0.29, 2.15, 0.8, 0.76, 0.54, 0.42, 0.83, 0.21, 0.18, 0.59)
k <- 2 # number of parameters for each of the distributions
# Gamma distribution
aic1 <- 2 * k - 2 * sum(log(dgamma(dat, shape = 2.0591977, scale = 0.3231032)))
cat("AIC for gamma distribution =", aic1, "\n")

# lognormal distribution
aic2 <- 2 * k - 2 * sum(log(dlnorm(dat, meanlog = -0.6695120, sdlog = 0.7199573)))
cat("AIC for lognormal distribution =", aic2, "\n")

# Pareto distribution
aic3 <- 2 * k - 2 * sum(log(EnvStats::dpareto(dat, location = 0.1800000, shape = 0.9566756)))
cat("AIC for Pareto distribution =", aic3, "\n")

## ----echo=TRUE,results='hide'-------------------------------------------------
dat <- c(1.73, 0.57, 0.33, 0.28, 0.3, 0.29, 2.15, 0.8, 0.76, 0.54, 0.42, 0.83, 0.21, 0.18, 0.59)
aic <- NULL
k <- 2 # number of parameters for each of the distributions


aic[1] <- 2 * k - 2 * sum(log(dgamma(dat, shape = 2.0591977, scale = 0.3231032))) # Gamma distribution

aic[2] <- 2 * k - 2 * sum(log(dlnorm(dat, meanlog = -0.6695120, sdlog = 0.7199573))) # lognormal distribution

aic[3] <- 2 * k - 2 * sum(log(EnvStats::dpareto(dat, location = 0.1800000, shape = 0.9566756))) # Pareto distribution

delta <- aic - min(aic) #  compute the delta values

aic.w <- exp(-0.5 * delta)
aic.w <- round(aic.w / sum(aic.w), 4)

cat(
  " AIC weight for gamma distribution =", aic.w[1], "\n",
  "AIC weight for lognormal distribution =", aic.w[2], "\n",
  "AIC weight for pareto distribution =", aic.w[3], "\n"
)

## ----echo=FALSE,fig.cap="Empirical cdf (black) and model-averaged fit (magenta)",fig.width=8,fig.height=5----
samp <- c(1.73, 0.57, 0.33, 0.28, 0.3, 0.29, 2.15, 0.8, 0.76, 0.54, 0.42, 0.83, 0.21, 0.18, 0.59)
samp <- sort(samp)
plot(ecdf(samp), main = "Empirical and fitted SSDs", xlab = "Concentration", ylab = "Probability")
xx <- seq(0.01, 3, by = 0.005)

lines(xx, plnorm(xx, meanlog = -0.6695120, sd = 0.7199573), col = "#959495", lty = 2)
lines(xx, pgamma(xx, shape = 2.0591977, scale = 0.3231032), col = "#959495", lty = 3)
lines(xx, ppareto(xx, location = 0.1800000, shape = 0.9566756), col = "#959495", lty = 4)
lines(xx, 0.1191 * pgamma(xx, shape = 2.0591977, scale = 0.3231032) +
  0.3985 * plnorm(xx, meanlog = -0.6695120, sd = 0.7199573) +
  0.4824 * ppareto(xx, location = 0.1800000, shape = 0.9566756), col = "#FF33D5", lwd = 1.5)

## ----results = "asis", echo = FALSE-------------------------------------------
cat(ssdtools::ssd_licensing_md())

