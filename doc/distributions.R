## ----include = FALSE----------------------------------------------------------
knitr::opts_chunk$set(
  collapse = TRUE,
  comment = "#>",
  fig.width = 6,
  fig.height = 4
)

## ----echo=FALSE,fig.align='center',fig.width=9,fig.height=5, fig.cap="Sample Burr probability density (A) and cumulative probability (B) functions."----
par(mfrow = c(1, 2))

f <- function(x, b, c, k) {
  z1 <- (b / x)^(c - 1)
  z2 <- (b / x)^c
  y <- (b * c * k / x^2) * z1 / (1 + z2)^(k + 1)
  return(y)
}

conc <- seq(0, 10, by = 0.005)
plot(conc, f(conc, 1, 3, 5), type = "l", ylab = "Probability density", xlab = "Concentration", col = "#FF5733")
lines(conc, f(conc, 1, 1, 2), col = "#F2A61C")
lines(conc, f(conc, 1, 2, 2), col = "#1CADF2")
lines(conc, f(conc, 1, 2, 5), col = "#1F1CF2")
legend("topleft", "(A)", bty = "n")

F <- function(x, b, c, k) {
  z2 <- (b / x)^c
  y <- 1 / (1 + z2)^k
  return(y)
}
conc <- seq(0, 10, by = 0.005)
plot(conc, F(conc, 1, 3, 5), type = "l", ylab = "Cumulative probability", xlab = "Concentration", col = "#FF5733")
lines(conc, F(conc, 1, 1, 2), col = "#F2A61C")
lines(conc, F(conc, 1, 2, 2), col = "#1CADF2")
lines(conc, F(conc, 1, 2, 5), col = "#1F1CF2")
legend("topleft", "(B)", bty = "n")

## ----echo=FALSE,fig.align='center',fig.width=9,fig.height=5, fig.cap="Sample lognormal lognormal mixture probability density (A) and cumulative probability (B) functions."----
par(mfrow = c(1, 2))

f <- function(x, m1, s1, m2, s2, p) {
  y <- p * dlnorm(x, m1, s1) + (1 - p) * dlnorm(x, m2, s2)
  return(y)
}

conc <- seq(0, 5, by = 0.0025)
m1 <- 1
s1 <- .2
m2 <- 1.8
s2 <- 1.5
p <- 0.25
plot(conc, f(conc, m1, s1, m2, s2, p), type = "l", ylab = "Probability density", xlab = "Concentration", col = "#FF5733", ylim = c(0, 1))
lines(conc, f(conc, 0.09, 0.5, 1, 0.08, 0.9), col = "#F2A61C")
lines(conc, f(conc, 0.5, 0.5, 1, 0.08, 0.9), col = "#1CADF2")
lines(conc, f(conc, 0.7, 1.5, 0.5, 0.1, .7), col = "#1F1CF2")
legend("topleft", "(A)", bty = "n")

F <- function(x, m1, s1, m2, s2, p) {
  y <- p * plnorm(x, m1, s1) + (1 - p) * plnorm(x, m2, s2)
  return(y)
}

conc <- seq(0, 10, by = 0.0025)
m1 <- 1
s1 <- .2
m2 <- 1.8
s2 <- 1.5
p <- 0.25
plot(conc, F(conc, m1, s1, m2, s2, p), type = "l", ylab = "Cumulative probability", xlab = "Concentration", col = "#FF5733", ylim = c(0, 1))
lines(conc, F(conc, 0.09, 0.5, 1, 0.08, 0.9), col = "#F2A61C")
lines(conc, F(conc, 0.5, 0.5, 1, 0.08, 0.9), col = "#1CADF2")
lines(conc, F(conc, 0.7, 1.5, 0.5, 0.1, .7), col = "#1F1CF2")
legend("topleft", "(B)", bty = "n")

## ----message=FALSE, echo=FALSE, fig.width=7,fig.height=5, fig.cap="Currently recommended default distributions."----
library(ssdtools)
library(ggplot2)

# theme_set(theme_bw())

set.seed(7)

ssd_plot_cdf(ssd_match_moments(meanlog = 2, sdlog = 2)) +
  scale_color_ssd()

## ----echo=FALSE,fig.align='center',fig.width=9,fig.height=5,fig.cap="Sample lognormal probability density (A) and cumulative probability (B) functions."----
par(mfrow = c(1, 2))

conc <- seq(0, 10, by = 0.005)
m1 <- 1
s1 <- .2
m2 <- 1.8
s2 <- 1.5
p <- 0.25
plot(conc, dlnorm(conc, m1, s1), type = "l", ylab = "Probability density", xlab = "Concentration", col = "#FF5733", ylim = c(0, 1))
lines(conc, dlnorm(conc, 0.4, 2), col = "#F2A61C")
lines(conc, dlnorm(conc, m1 * 2, s1), col = "#1CADF2")
lines(conc, dlnorm(conc, 0.9, 1.5), col = "#1F1CF2")
legend("topleft", "(A)", bty = "n")

conc <- seq(0, 10, by = 0.005)
m1 <- 1
s1 <- .2
m2 <- 1.8
s2 <- 1.5
p <- 0.25
plot(conc, plnorm(conc, m1, s1), type = "l", ylab = "Cumulative probability", xlab = "Concentration", col = "#FF5733", ylim = c(0, 1))
lines(conc, plnorm(conc, 0.4, 2), col = "#F2A61C")
lines(conc, plnorm(conc, m1 * 2, s1), col = "#1CADF2")
lines(conc, plnorm(conc, 0.9, 1.5), col = "#1F1CF2")
legend("topleft", "(B)", bty = "n")

## ----echo=FALSE,fig.align='center',fig.width=9,fig.height=5,fig.cap="Sample Log logistic probability density (A) and cumulative probability (B)  functions."----
par(mfrow = c(1, 2))

f <- function(x, a, b) {
  z1 <- (x / a)^(b - 1)
  z2 <- (x / a)^b
  y <- (b / a) * z1 / (1 + z2)^2
  return(y)
}

conc <- seq(0, 10, by = 0.005)
plot(conc, f(conc, 3.2, 3.5), type = "l", ylab = "Probability density", xlab = "Concentration", col = "#FF5733", ylim = c(0, 1.1))
lines(conc, f(conc, 1.5, 1.5), col = "#F2A61C")
lines(conc, f(conc, 1, 1), col = "#1CADF2")
lines(conc, f(conc, 1, 4), col = "#1F1CF2")
legend("topleft", "(A)", bty = "n")

F <- function(x, a, b) {
  z2 <- (x / a)^(-b)
  y <- 1 / (1 + z2)
  return(y)
}
conc <- seq(0, 10, by = 0.005)
plot(conc, F(conc, 3.2, 3.5), type = "l", ylab = "Cumulative probability", xlab = "Concentration", col = "#FF5733", ylim = c(0, 1.1))
lines(conc, F(conc, 1.5, 1.5), col = "#F2A61C")
lines(conc, F(conc, 1, 1), col = "#1CADF2")
lines(conc, F(conc, 1, 4), col = "#1F1CF2")
legend("topleft", "(B)", bty = "n")

## ----echo=FALSE,fig.align='center',fig.width=9,fig.height=5,fig.cap="Sample gamma probability density (A) and cumulative probability (B) functions."----
par(mfrow = c(1, 2))

conc <- seq(0, 10, by = 0.005)
plot(conc, dgamma(conc, 5, 5), type = "l", ylab = "Probability density", xlab = "Concentration", col = "#FF5733", ylim = c(0, 1.1))
lines(conc, dgamma(conc, 4, 1), col = "#F2A61C")
lines(conc, dgamma(conc, 0.9, 1), col = "#1CADF2")
lines(conc, dgamma(conc, 2, 1.), col = "#1F1CF2")
legend("topleft", "(A)", bty = "n")

conc <- seq(0, 10, by = 0.005)
plot(conc, pgamma(conc, 5, 5), type = "l", ylab = "Cumulative probability", xlab = "Concentration", col = "#FF5733", ylim = c(0, 1.1))
lines(conc, pgamma(conc, 4, 1), col = "#F2A61C")
lines(conc, pgamma(conc, 0.9, 1), col = "#1CADF2")
lines(conc, pgamma(conc, 2, 1.), col = "#1F1CF2")
legend("topleft", "(B)", bty = "n")

## ----echo=FALSE,fig.align='center',fig.width=9,fig.height=5,fig.cap="Sample Log-Gumbel probability density (A) and cumulative probability (B) functions."----
par(mfrow = c(1, 2))

f <- function(x, a, b) {
  y <- b * exp(-(a * x)^(-b)) / (a^b * x^(b + 1))
  return(y)
}

conc <- seq(0, 10, by = 0.005)
plot(conc, f(conc, 0.2, 5), type = "l", ylab = "Probability density", xlab = "Concentration", col = "#FF5733", ylim = c(0, 1.1))
lines(conc, f(conc, 0.5, 1.5), col = "#F2A61C")
lines(conc, f(conc, 1, 2), col = "#1CADF2")
lines(conc, f(conc, 10, .5), col = "#1F1CF2")
legend("topleft", "(A)", bty = "n")

F <- function(x, a, b) {
  y <- exp(-(a * x)^(-b))
  return(y)
}

conc <- seq(0, 10, by = 0.005)
plot(conc, F(conc, 0.2, 5), type = "l", ylab = "Cumulative probability", xlab = "Concentration", col = "#FF5733", ylim = c(0, 1.1))
lines(conc, F(conc, 0.5, 1.5), col = "#F2A61C")
lines(conc, F(conc, 1, 2), col = "#1CADF2")
lines(conc, F(conc, 10, .5), col = "#1F1CF2")
legend("topleft", "(B)", bty = "n")

## ----echo=FALSE,fig.align='center',fig.width=9,fig.height=5,fig.cap="Sample Gompertz probability density (A) and cumulative probability (B) functions."----
par(mfrow = c(1, 2))

f <- function(x, n, b) {
  y <- n * b * exp(n + b * x - n * exp(b * x))
  return(y)
}

conc <- seq(0, 10, by = 0.005)
plot(conc, f(conc, 0.089, 1.25), type = "l", ylab = "Probability density", xlab = "Concentration", col = "#FF5733", ylim = c(0, 2))
lines(conc, f(conc, 0.001, 3.5), col = "#F2A61C")
lines(conc, f(conc, 0.0005, 1.1), col = "#1CADF2")
lines(conc, f(conc, 0.01, 5), col = "#1F1CF2")
legend("topleft", "(A)", bty = "n")

F <- function(x, n, b) {
  y <- 1 - exp(-n * exp(b * x - 1))
  return(y)
}

conc <- seq(0, 10, by = 0.005)
plot(conc, F(conc, 0.089, 1.25), type = "l", ylab = "Cumulative probability", xlab = "Concentration", col = "#FF5733", ylim = c(0, 1))
lines(conc, F(conc, 0.001, 3.5), col = "#F2A61C")
lines(conc, F(conc, 0.0005, 1.1), col = "#1CADF2")
lines(conc, F(conc, 0.01, 5), col = "#1F1CF2")
legend("topleft", "(B)", bty = "n")

## ----echo=FALSE,fig.align='center',fig.width=9,fig.height=5,fig.cap="Sample Weibull probability density (A) and cumulative probability (B) functions."----
par(mfrow = c(1, 2))

conc <- seq(0, 10, by = 0.005)
plot(conc, dweibull(conc, 4.321, 4.949), type = "l", ylab = "Probability density", xlab = "Concentration", col = "#FF5733", ylim = c(0, 1))
lines(conc, dweibull(conc, 0.838, 0.911), col = "#F2A61C")
lines(conc, dweibull(conc, 1, 1.546), col = "#1CADF2")
lines(conc, dweibull(conc, 17.267, 7.219), col = "#1F1CF2")
legend("topleft", "(A)", bty = "n")

conc <- seq(0, 10, by = 0.005)
plot(conc, pweibull(conc, 4.321, 4.949), type = "l", ylab = "Cumulative probability", xlab = "Concentration", col = "#FF5733", ylim = c(0, 1))
lines(conc, pweibull(conc, 0.838, 0.911), col = "#F2A61C")
lines(conc, pweibull(conc, 1, 1.546), col = "#1CADF2")
lines(conc, pweibull(conc, 17.267, 7.219), col = "#1F1CF2")
legend("topleft", "(B)", bty = "n")

## ----echo=FALSE,fig.align='center',fig.width=9,fig.height=5,fig.cap="Sample North American Pareto probability density (A) and cumulative probability (B) functions."----
par(mfrow = c(1, 2))

conc <- seq(0, 10, by = 0.005)
plot(conc, extraDistr::dpareto(conc, 3, 2), type = "l", ylab = "Probability density", xlab = "Concentration", col = "#FF5733", ylim = c(0, 1.5))
lines(conc, extraDistr::dpareto(conc, 0.838, 0.911), col = "#F2A61C")
lines(conc, extraDistr::dpareto(conc, 4, 4), col = "#1CADF2")
lines(conc, extraDistr::dpareto(conc, 10, 7), col = "#1F1CF2")
legend("topleft", "(A)", bty = "n")

conc <- seq(0, 10, by = 0.005)
plot(conc, extraDistr::ppareto(conc, 3, 2), type = "l", ylab = "Cumulative probability", xlab = "Concentration", col = "#FF5733", ylim = c(0, 1))
lines(conc, extraDistr::ppareto(conc, 0.838, 0.911), col = "#F2A61C")
lines(conc, extraDistr::ppareto(conc, 4, 4), col = "#1CADF2")
lines(conc, extraDistr::ppareto(conc, 10, 7), col = "#1F1CF2")
legend("topleft", "(B)", bty = "n")

conc <- seq(0, 10, by = 0.005)
plot(conc, extraDistr::ppareto(conc, 3, 2), type = "l", ylab = "Cumulative probability", xlab = "Concentration", col = "#FF5733", ylim = c(0, 1))
lines(conc, extraDistr::ppareto(conc, 0.838, 0.911), col = "#F2A61C")
lines(conc, extraDistr::ppareto(conc, 4, 4), col = "#1CADF2")
lines(conc, extraDistr::ppareto(conc, 10, 7), col = "#1F1CF2")

## ----echo=FALSE,fig.align='center',fig.width=9,fig.height=5,fig.cap="Sample Sample North American inverse Pareto probability density (A) and cumulative probability (B) functions."----
par(mfrow = c(1, 2))

f <- function(x, a, b) {
  y <- a * (b^a) * x^(a - 1)
  return(y)
}

conc <- seq(0, 10, by = 0.001)
plot(conc, f(conc, 5, 0.1), type = "l", ylab = "Probability density", xlab = "Concentration", col = "#FF5733", ylim = c(0, 0.5))
lines(conc, f(conc, 3, 0.1), col = "#F2A61C")
lines(conc, f(conc, 0.5, 0.1), col = "#1CADF2")
lines(conc, f(conc, 0.1, 0.1), col = "#1F1CF2")
legend("topleft", "(A)", bty = "n")

F <- function(x, a, b) {
  y <- (b * x)^a
  return(y)
}

conc <- seq(0, 10, by = 0.001)
plot(conc, F(conc, 5, 0.1), type = "l", ylab = "Probability density", xlab = "Concentration", col = "#FF5733", ylim = c(0, 1))
lines(conc, F(conc, 3, 0.1), col = "#F2A61C")
lines(conc, F(conc, 0.5, 0.1), col = "#1CADF2")
lines(conc, F(conc, 0.1, 0.1), col = "#1F1CF2")
legend("topleft", "(B)", bty = "n")

## ----echo=FALSE,fig.align='center',fig.width=9,fig.height=5,fig.cap="Sample European Pareto probability density (A) and cumulative probability (B) functions."----
par(mfrow = c(1, 2))

conc <- seq(0, 10, by = 0.005)
plot(conc, actuar::dpareto(conc, 1, 1), type = "l", ylab = "Probability density", xlab = "Concentration", col = "#FF5733", ylim = c(0, 1))
lines(conc, actuar::dpareto(conc, 2, 3), col = "#F2A61C")
lines(conc, actuar::dpareto(conc, 0.5, 1), col = "#1CADF2")
lines(conc, actuar::dpareto(conc, 10.5, 6.5), col = "#1F1CF2")
legend("topleft", "(A)", bty = "n")

conc <- seq(0, 10, by = 0.005)
plot(conc, actuar::ppareto(conc, 1, 1), type = "l", ylab = "Cumulative probability", xlab = "Concentration", col = "#FF5733", ylim = c(0, 1))
lines(conc, actuar::ppareto(conc, 2, 3), col = "#F2A61C")
lines(conc, actuar::ppareto(conc, 0.5, 1), col = "#1CADF2")
lines(conc, actuar::ppareto(conc, 10.5, 6.5), col = "#1F1CF2")
legend("topleft", "(B)", bty = "n")

## ----echo=FALSE,fig.align='center',fig.width=9,fig.height=5,fig.cap="Sample European inverse Pareto probability density (A) and cumulative probability (B)  functions."----
par(mfrow = c(1, 2))

conc <- seq(0, 10, by = 0.001)
plot(conc, actuar::dinvpareto(conc, 1, 1), type = "l", ylab = "Probability density", xlab = "Concentration", col = "#FF5733", ylim = c(0, 0.8))
lines(conc, actuar::dinvpareto(conc, 1, 3), col = "#F2A61C")
lines(conc, actuar::dinvpareto(conc, 10, 0.1), col = "#1CADF2")
lines(conc, actuar::dinvpareto(conc, 2.045, 0.98), col = "#1F1CF2")
legend("topleft", "(A)", bty = "n")

conc <- seq(0, 10, by = 0.001)
plot(conc, actuar::pinvpareto(conc, 1, 1), type = "l", ylab = "Probability density", xlab = "Concentration", col = "#FF5733", ylim = c(0, 1))
lines(conc, actuar::pinvpareto(conc, 1, 3), col = "#F2A61C")
lines(conc, actuar::pinvpareto(conc, 10, 0.1), col = "#1CADF2")
lines(conc, actuar::pinvpareto(conc, 2.045, 0.98), col = "#1F1CF2")

## ----results = "asis", echo = FALSE-------------------------------------------
cat(ssdtools::ssd_licensing_md())

