# Hazard Concentrations for Species Sensitivity Distributions

Calculates concentration(s) with bootstrap confidence intervals that
protect specified proportion(s) of species for individual or
model-averaged distributions using parametric or non-parametric
bootstrapping.

## Usage

``` r
ssd_hc(x, ...)

# S3 method for class 'list'
ssd_hc(x, percent, proportion = 0.05, ...)

# S3 method for class 'fitdists'
ssd_hc(
  x,
  percent = deprecated(),
  proportion = 0.05,
  ...,
  average = TRUE,
  ci = FALSE,
  level = 0.95,
  nboot = 1000,
  min_pboot = 0.95,
  multi_est = deprecated(),
  est_method = "multi",
  ci_method = "weighted_samples",
  parametric = TRUE,
  delta = 9.21,
  samples = FALSE,
  save_to = NULL,
  control = NULL
)

# S3 method for class 'fitburrlioz'
ssd_hc(
  x,
  percent,
  proportion = 0.05,
  ...,
  ci = FALSE,
  level = 0.95,
  nboot = 1000,
  min_pboot = 0.95,
  parametric = FALSE,
  samples = FALSE,
  save_to = NULL
)
```

## Arguments

- x:

  The object.

- ...:

  Unused.

- percent:

  A numeric vector of percent values to estimate hazard concentrations
  for. Deprecated for `proportion = 0.05`. **\[deprecated\]**

- proportion:

  A numeric vector of proportion values to estimate hazard
  concentrations for.

- average:

  A flag specifying whether to provide model averaged values as opposed
  to a value for each distribution.

- ci:

  A flag specifying whether to estimate confidence intervals (by
  bootstrapping).

- level:

  A number between 0 and 1 of the confidence level of the interval.

- nboot:

  A count of the number of bootstrap samples to use to estimate the
  confidence limits. A value of 10,000 is recommended for official
  guidelines.

- min_pboot:

  A number between 0 and 1 of the minimum proportion of bootstrap
  samples that must successfully fit (return a likelihood) to report the
  confidence intervals.

- multi_est:

  A flag specifying whether to estimate directly from the model-averaged
  cumulative distribution function (`multi_est = TRUE`) or to take the
  arithmetic mean of the estimates from the individual cumulative
  distribution functions weighted by the AICc derived weights
  (`multi_est = FALSE`).

- est_method:

  A string specifying whether to estimate directly from the
  model-averaged cumulative distribution function
  (`est_method = 'multi'`) or to take the arithmetic mean of the
  estimates from the individual cumulative distribution functions
  weighted by the AICc derived weights (`est_method = 'arithmetic'`) or
  or to use the geometric mean instead (`est_method = 'geometric'`).

- ci_method:

  A string specifying which method to use for estimating the standard
  error and confidence limits from the bootstrap samples. The default
  and recommended value is still `ci_method = "weighted_samples"` which
  takes bootstrap samples from each distribution proportional to its
  AICc based weights and calculates the confidence limits (and SE) from
  this single set. `ci_method = "multi_fixed"` and
  `ci_method = "multi_free"` generate the bootstrap samples using the
  model-averaged cumulative distribution function but differ in whether
  the model weights are fixed at the values for the original dataset or
  re-estimated for each bootstrap sample dataset. The value
  `ci_method = "MACL"` (was `ci_method = "weighted_arithmetic"`), which
  is only included for historical reasons, takes the weighted arithmetic
  mean of the confidence limits while `ci_method = GMACL` which takes
  the weighted geometric mean of the confidence limits was added for
  completeness but is also not recommended. Finally
  `ci_method = "arithmetic_samples"` and
  `ci_method = "geometric_samples"` take the weighted arithmetic or
  geometric mean of the values for each bootstrap iteration across all
  the distributions and then calculate the confidence limits (and SE)
  from the single set of samples.

- parametric:

  A flag specifying whether to perform parametric bootstrapping as
  opposed to non-parametrically resampling the original data with
  replacement.

- delta:

  A non-negative number specifying the maximum absolute AIC difference
  cutoff. Distributions with an absolute AIC difference greater than
  delta are excluded from the calculations.

- samples:

  A flag specfying whether to include a numeric vector of the bootstrap
  samples as a list column in the output.

- save_to:

  NULL or a string specifying a directory to save where the bootstrap
  datasets and parameter estimates (when successfully converged) to.

- control:

  A list of control parameters passed to
  [`stats::optim()`](https://rdrr.io/r/stats/optim.html).

## Value

A tibble of corresponding hazard concentrations.

## Details

Model-averaged estimates and/or confidence intervals (including standard
error) can be calculated by treating the distributions as constituting a
single mixture distribution versus 'taking the mean'. When calculating
the model averaged estimates treating the distributions as constituting
a single mixture distribution ensures that `ssd_hc()` is the inverse of
[`ssd_hp()`](https://bcgov.github.io/ssdtools/reference/ssd_hp.md).

Distributions with an absolute AIC difference greater than a delta of by
default 7 have considerably less support (wt \< 0.01) and are excluded
prior to calculation of the hazard concentrations to reduce the run
time.

## Methods (by class)

- `ssd_hc(list)`: Hazard Concentrations for Distributional Estimates

- `ssd_hc(fitdists)`: Hazard Concentrations for fitdists Object

- `ssd_hc(fitburrlioz)`: Hazard Concentrations for fitburrlioz Object

## References

Burnham, K.P., and Anderson, D.R. 2002. Model Selection and Multimodel
Inference. Springer New York, New York, NY. doi:10.1007/b97636.

## See also

[`predict.fitdists()`](https://bcgov.github.io/ssdtools/reference/predict.fitdists.md)
and [`ssd_hp()`](https://bcgov.github.io/ssdtools/reference/ssd_hp.md).

## Examples

``` r
ssd_hc(ssd_match_moments())
#> # A tibble: 6 × 9
#>   dist        proportion   est    se   lcl   ucl    wt nboot pboot
#>   <chr>            <dbl> <dbl> <dbl> <dbl> <dbl> <dbl> <int> <dbl>
#> 1 gamma             0.05 0.439    NA    NA    NA     1     0    NA
#> 2 lgumbel           0.05 0.739    NA    NA    NA     1     0    NA
#> 3 llogis            0.05 0.562    NA    NA    NA     1     0    NA
#> 4 lnorm             0.05 0.558    NA    NA    NA     1     0    NA
#> 5 lnorm_lnorm       0.05 0.489    NA    NA    NA     1     0    NA
#> 6 weibull           0.05 0.501    NA    NA    NA     1     0    NA

fits <- ssd_fit_dists(ssddata::ccme_boron)
ssd_hc(fits)
#> # A tibble: 1 × 15
#>   dist    proportion   est    se   lcl   ucl    wt level est_method ci_method   
#>   <chr>        <dbl> <dbl> <dbl> <dbl> <dbl> <dbl> <dbl> <chr>      <chr>       
#> 1 average       0.05  1.26    NA    NA    NA     1  0.95 multi      weighted_sa…
#> # ℹ 5 more variables: boot_method <chr>, nboot <int>, pboot <dbl>,
#> #   dists <list>, samples <list>

fit <- ssd_fit_burrlioz(ssddata::ccme_boron)
ssd_hc(fit)
#> # A tibble: 1 × 15
#>   dist      proportion   est    se   lcl   ucl    wt level est_method ci_method 
#>   <chr>          <dbl> <dbl> <dbl> <dbl> <dbl> <dbl> <dbl> <chr>      <chr>     
#> 1 invpareto       0.05 0.387    NA    NA    NA     1  0.95 cdf        percentile
#> # ℹ 5 more variables: boot_method <chr>, nboot <int>, pboot <dbl>,
#> #   dists <list>, samples <list>
```
