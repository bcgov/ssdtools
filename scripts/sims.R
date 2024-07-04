library(ssddata)
library(ssdtools)
library(purrr)
library(stringr)
library(future.apply)

rm(list = ls())

plan("multisession")

nsims <- 200
ndata <- 1024
dists <- c("lnorm", "lgumbel")

fit <- ssd_fit_dists(ssddata::ccme_glyphosate, dists = dists)
ssd_plot_cdf(fit)
true <- ssd_hc(fit)$est
true_ave <- ssd_hc(fit, multi_est = FALSE)$est
ssd_hc(fit, average = FALSE)

estimates <- estimates(fit, all_estimates = TRUE)

set.seed(42)
data <- do.call("ssd_rmulti", c(n = nsims * ndata, estimates))
data <- matrix(data, ncol = nsims)

e5 <- future_apply(data, MARGIN = 2, function(x) quantile(x, 0.05))
hist(e5)
e1 <- future_apply(data, MARGIN = 2, function(x) quantile(x, 0.01))
hist(e1)
e20 <- future_apply(data, MARGIN = 2, function(x) quantile(x, 0.2))
hist(e20)
emax <- future_apply(data, MARGIN = 2, function(x) max(x))
hist(log(emax))

log(max(ssd_rlgumbel(round(204800 * 0.719), locationlog = 8.357433, scalelog = 1.223079)))

ssd_plot_data(data.frame(Conc = data[,10]))

fits <- future_apply(data, MARGIN = 2, function(x) ssd_fit_dists(data.frame(Conc = x), dists = dists))

hc5s <- vapply(fits, function(x) { ssd_hc(x, delta = Inf)$est }, 1)

props <- (hc5s - true) / true
hist(props)

which_biased <- which.min(props)
fit_biased <- fits[[which_biased]]
ssd_hc(fit_biased, average = FALSE, delta = Inf)
ssd_plot_cdf(fit_biased, average = FALSE, delta = Inf)

which_not_biased <- which.min(abs(props-0))
fit_not_biased <- fits[[which_not_biased]]
ssd_hc(fit_not_biased, average = FALSE, delta = Inf)
ssd_plot_cdf(fit_not_biased, average = FALSE, delta = Inf)

