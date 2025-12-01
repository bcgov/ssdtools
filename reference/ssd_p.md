# Cumulative Distribution Function

Cumulative Distribution Function

## Usage

``` r
ssd_pburrIII3(
  q,
  shape1 = 1,
  shape2 = 1,
  scale = 1,
  lower.tail = TRUE,
  log.p = FALSE
)

ssd_pgamma(q, shape = 1, scale = 1, lower.tail = TRUE, log.p = FALSE)

ssd_pgompertz(q, location = 1, shape = 1, lower.tail = TRUE, log.p = FALSE)

ssd_pinvpareto(q, shape = 3, scale = 1, lower.tail = TRUE, log.p = FALSE)

ssd_plgumbel(
  q,
  locationlog = 0,
  scalelog = 1,
  lower.tail = TRUE,
  log.p = FALSE
)

ssd_pllogis_llogis(
  q,
  locationlog1 = 0,
  scalelog1 = 1,
  locationlog2 = 1,
  scalelog2 = 1,
  pmix = 0.5,
  lower.tail = TRUE,
  log.p = FALSE
)

ssd_pllogis(q, locationlog = 0, scalelog = 1, lower.tail = TRUE, log.p = FALSE)

ssd_plnorm_lnorm(
  q,
  meanlog1 = 0,
  sdlog1 = 1,
  meanlog2 = 1,
  sdlog2 = 1,
  pmix = 0.5,
  lower.tail = TRUE,
  log.p = FALSE
)

ssd_plnorm(q, meanlog = 0, sdlog = 1, lower.tail = TRUE, log.p = FALSE)

ssd_pmulti(
  q,
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
  lower.tail = TRUE,
  log.p = FALSE
)

ssd_pmulti_fitdists(q, fitdists, lower.tail = TRUE, log.p = FALSE)

ssd_pweibull(q, shape = 1, scale = 1, lower.tail = TRUE, log.p = FALSE)
```

## Arguments

- q:

  vector of quantiles.

- shape1:

  shape1 parameter.

- shape2:

  shape2 parameter.

- scale:

  scale parameter.

- lower.tail:

  logical; if TRUE (default), probabilities are `P[X <= x]`, otherwise,
  `P[X > x]`.

- log.p:

  logical; if TRUE, probabilities p are given as log(p).

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

- `ssd_pburrIII3()`: Cumulative Distribution Function for BurrIII
  Distribution

- `ssd_pgamma()`: Cumulative Distribution Function for Gamma
  Distribution

- `ssd_pgompertz()`: Cumulative Distribution Function for Gompertz
  Distribution

- `ssd_pinvpareto()`: Cumulative Distribution Function for Inverse
  Pareto Distribution

- `ssd_plgumbel()`: Cumulative Distribution Function for Log-Gumbel
  Distribution

- `ssd_pllogis_llogis()`: Cumulative Distribution Function for
  Log-Logistic/Log-Logistic Mixture Distribution

- `ssd_pllogis()`: Cumulative Distribution Function for Log-Logistic
  Distribution

- `ssd_plnorm_lnorm()`: Cumulative Distribution Function for
  Log-Normal/Log-Normal Mixture Distribution

- `ssd_plnorm()`: Cumulative Distribution Function for Log-Normal
  Distribution

- `ssd_pmulti()`: Cumulative Distribution Function for Multiple
  Distributions

- `ssd_pmulti_fitdists()`: Cumulative Distribution Function for Multiple
  Distributions

- `ssd_pweibull()`: Cumulative Distribution Function for Weibull
  Distribution

## See also

[`ssd_q`](https://bcgov.github.io/ssdtools/reference/ssd_q.md) and
[`ssd_r`](https://bcgov.github.io/ssdtools/reference/ssd_r.md)

## Examples

``` r
ssd_pburrIII3(1)
#> [1] 0.5

ssd_pgamma(1)
#> [1] 0.6321206

ssd_pgompertz(1)
#> [1] 0.8206259

ssd_pinvpareto(1)
#> [1] 1

ssd_plgumbel(1)
#> [1] 0.3678794

ssd_pllogis_llogis(1)
#> [1] 0.3844707

ssd_pllogis(1)
#> [1] 0.5

ssd_plnorm_lnorm(1)
#> [1] 0.3293276

ssd_plnorm(1)
#> [1] 0.5

# multi
ssd_pmulti(1, gamma.weight = 0.5, lnorm.weight = 0.5)
#> [1] 0.5660603

# multi fitdists
fit <- ssd_fit_dists(ssddata::ccme_boron)
ssd_pmulti_fitdists(1, fit)
#> [1] 0.03898781

ssd_pweibull(1)
#> [1] 0.6321206
```
