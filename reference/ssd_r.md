# Random Number Generation

Random Number Generation

## Usage

``` r
ssd_rburrIII3(n, shape1 = 1, shape2 = 1, scale = 1, chk = TRUE)

ssd_rgamma(n, shape = 1, scale = 1, chk = TRUE)

ssd_rgompertz(n, location = 1, shape = 1, chk = TRUE)

ssd_rinvpareto(n, shape = 3, scale = 1, chk = TRUE)

ssd_rlgumbel(n, locationlog = 0, scalelog = 1, chk = TRUE)

ssd_rllogis_llogis(
  n,
  locationlog1 = 0,
  scalelog1 = 1,
  locationlog2 = 1,
  scalelog2 = 1,
  pmix = 0.5,
  chk = TRUE
)

ssd_rllogis(n, locationlog = 0, scalelog = 1, chk = TRUE)

ssd_rlnorm_lnorm(
  n,
  meanlog1 = 0,
  sdlog1 = 1,
  meanlog2 = 1,
  sdlog2 = 1,
  pmix = 0.5,
  chk = TRUE
)

ssd_rlnorm(n, meanlog = 0, sdlog = 1, chk = TRUE)

ssd_rmulti(
  n,
  burrIII3.weight = 0,
  burrIII3.shape1 = 1,
  burrIII3.shape2 = 1,
  burrIII3.scale = 1,
  gamma.weight = 0,
  gamma.shape = 1,
  gamma.scale = 1,
  gompertz.weight = 0,
  gompertz.location = 1,
  gompertz.shape = 1,
  lgumbel.weight = 0,
  lgumbel.locationlog = 0,
  lgumbel.scalelog = 1,
  llogis.weight = 0,
  llogis.locationlog = 0,
  llogis.scalelog = 1,
  llogis_llogis.weight = 0,
  llogis_llogis.locationlog1 = 0,
  llogis_llogis.scalelog1 = 1,
  llogis_llogis.locationlog2 = 1,
  llogis_llogis.scalelog2 = 1,
  llogis_llogis.pmix = 0.5,
  lnorm.weight = 0,
  lnorm.meanlog = 0,
  lnorm.sdlog = 1,
  lnorm_lnorm.weight = 0,
  lnorm_lnorm.meanlog1 = 0,
  lnorm_lnorm.sdlog1 = 1,
  lnorm_lnorm.meanlog2 = 1,
  lnorm_lnorm.sdlog2 = 1,
  lnorm_lnorm.pmix = 0.5,
  weibull.weight = 0,
  weibull.shape = 1,
  weibull.scale = 1,
  chk = TRUE
)

ssd_rmulti_fitdists(n, fitdists, chk = TRUE)

ssd_rweibull(n, shape = 1, scale = 1, chk = TRUE)
```

## Arguments

- n:

  positive number of observations.

- shape1:

  shape1 parameter.

- shape2:

  shape2 parameter.

- scale:

  scale parameter.

- chk:

  A flag specifying whether to check the arguments.

- shape:

  shape parameter.

- location:

  location parameter.

- locationlog:

  location on the log scale parameter.

- scalelog:

  scale on log scale parameter.

- locationlog1:

  locationlog1 parameter.

- scalelog1:

  scalelog1 parameter.

- locationlog2:

  locationlog2 parameter.

- scalelog2:

  scalelog2 parameter.

- pmix:

  Proportion mixture parameter.

- meanlog1:

  mean on log scale parameter.

- sdlog1:

  standard deviation on log scale parameter.

- meanlog2:

  mean on log scale parameter.

- sdlog2:

  standard deviation on log scale parameter.

- meanlog:

  mean on log scale parameter.

- sdlog:

  standard deviation on log scale parameter.

- burrIII3.weight:

  weight parameter for the Burr III distribution.

- burrIII3.shape1:

  shape1 parameter for the Burr III distribution.

- burrIII3.shape2:

  shape2 parameter for the Burr III distribution.

- burrIII3.scale:

  scale parameter for the Burr III distribution.

- gamma.weight:

  weight parameter for the gamma distribution.

- gamma.shape:

  shape parameter for the gamma distribution.

- gamma.scale:

  scale parameter for the gamma distribution.

- gompertz.weight:

  weight parameter for the Gompertz distribution.

- gompertz.location:

  location parameter for the Gompertz distribution.

- gompertz.shape:

  shape parameter for the Gompertz distribution.

- lgumbel.weight:

  weight parameter for the log-Gumbel distribution.

- lgumbel.locationlog:

  location parameter for the log-Gumbel distribution.

- lgumbel.scalelog:

  scale parameter for the log-Gumbel distribution.

- llogis.weight:

  weight parameter for the log-logistic distribution.

- llogis.locationlog:

  location parameter for the log-logistic distribution.

- llogis.scalelog:

  scale parameter for the log-logistic distribution.

- llogis_llogis.weight:

  weight parameter for the log-logistic log-logistic mixture
  distribution.

- llogis_llogis.locationlog1:

  locationlog1 parameter for the log-logistic log-logistic mixture
  distribution.

- llogis_llogis.scalelog1:

  scalelog1 parameter for the log-logistic log-logistic mixture
  distribution.

- llogis_llogis.locationlog2:

  locationlog2 parameter for the log-logistic log-logistic mixture
  distribution.

- llogis_llogis.scalelog2:

  scalelog2 parameter for the log-logistic log-logistic mixture
  distribution.

- llogis_llogis.pmix:

  pmix parameter for the log-logistic log-logistic mixture distribution.

- lnorm.weight:

  weight parameter for the log-normal distribution.

- lnorm.meanlog:

  meanlog parameter for the log-normal distribution.

- lnorm.sdlog:

  sdlog parameter for the log-normal distribution.

- lnorm_lnorm.weight:

  weight parameter for the log-normal log-normal mixture distribution.

- lnorm_lnorm.meanlog1:

  meanlog1 parameter for the log-normal log-normal mixture distribution.

- lnorm_lnorm.sdlog1:

  sdlog1 parameter for the log-normal log-normal mixture distribution.

- lnorm_lnorm.meanlog2:

  meanlog2 parameter for the log-normal log-normal mixture distribution.

- lnorm_lnorm.sdlog2:

  sdlog2 parameter for the log-normal log-normal mixture distribution.

- lnorm_lnorm.pmix:

  pmix parameter for the log-normal log-normal mixture distribution.

- weibull.weight:

  weight parameter for the Weibull distribution.

- weibull.shape:

  shape parameter for the Weibull distribution.

- weibull.scale:

  scale parameter for the Weibull distribution.

- fitdists:

  An object of class fitdists.

## Functions

- `ssd_rburrIII3()`: Random Generation for BurrIII Distribution

- `ssd_rgamma()`: Random Generation for Gamma Distribution

- `ssd_rgompertz()`: Random Generation for Gompertz Distribution

- `ssd_rinvpareto()`: Random Generation for Inverse Pareto Distribution

- `ssd_rlgumbel()`: Random Generation for log-Gumbel Distribution

- `ssd_rllogis_llogis()`: Random Generation for
  Log-Logistic/Log-Logistic Mixture Distribution

- `ssd_rllogis()`: Random Generation for Log-Logistic Distribution

- `ssd_rlnorm_lnorm()`: Random Generation for Log-Normal/Log-Normal
  Mixture Distribution

- `ssd_rlnorm()`: Random Generation for Log-Normal Distribution

- `ssd_rmulti()`: Random Generation for Multiple Distributions

- `ssd_rmulti_fitdists()`: Random Generation for Multiple Distributions

- `ssd_rweibull()`: Random Generation for Weibull Distribution

## See also

[`ssd_p`](https://bcgov.github.io/ssdtools/reference/ssd_p.md) and
[`ssd_q`](https://bcgov.github.io/ssdtools/reference/ssd_q.md)

## Examples

``` r
withr::with_seed(50, {
  x <- ssd_rburrIII3(10000)
})
hist(x, breaks = 1000)


withr::with_seed(50, {
  x <- ssd_rgamma(10000)
})
hist(x, breaks = 1000)


withr::with_seed(50, {
  x <- ssd_rgompertz(10000)
})
hist(x, breaks = 1000)


withr::with_seed(50, {
  x <- ssd_rinvpareto(10000)
})
hist(x, breaks = 1000)


withr::with_seed(50, {
  x <- ssd_rlgumbel(10000)
})
hist(x, breaks = 1000)


withr::with_seed(50, {
  x <- ssd_rllogis_llogis(10000)
})
hist(x, breaks = 1000)


withr::with_seed(50, {
  x <- ssd_rllogis(10000)
})
hist(x, breaks = 1000)


withr::with_seed(50, {
  x <- ssd_rlnorm_lnorm(10000)
})
hist(x, breaks = 1000)


withr::with_seed(50, {
  x <- ssd_rlnorm(10000)
})
hist(x, breaks = 1000)


withr::with_seed(50, {
  x <- ssd_rmulti(1000, gamma.weight = 0.5, lnorm.weight = 0.5)
})
hist(x, breaks = 100)


# multi fitdists
fit <- ssd_fit_dists(ssddata::ccme_boron)
ssd_rmulti_fitdists(2, fit)
#> [1] 0.9414309 7.3397086

withr::with_seed(50, {
  x <- ssd_rweibull(10000)
})
hist(x, breaks = 1000)
```
