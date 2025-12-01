# Predict Hazard Concentrations of fitdists Object

A wrapper on
[`ssd_hc()`](https://bcgov.github.io/ssdtools/reference/ssd_hc.md) that
by default calculates all hazard concentrations from 1 to 99%.

## Usage

``` r
# S3 method for class 'fitdists'
predict(
  object,
  percent,
  proportion = 1:99/100,
  ...,
  average = TRUE,
  ci = FALSE,
  level = 0.95,
  nboot = 1000,
  min_pboot = 0.95,
  est_method = "multi",
  ci_method = "weighted_samples",
  parametric = TRUE,
  delta = 9.21,
  control = NULL
)
```

## Arguments

- object:

  The object.

- percent:

  A numeric vector of percent values to estimate hazard concentrations
  for. Deprecated for `proportion = 0.05`. **\[deprecated\]**

- proportion:

  A numeric vector of proportion values to estimate hazard
  concentrations for.

- ...:

  Unused.

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

- control:

  A list of control parameters passed to
  [`stats::optim()`](https://rdrr.io/r/stats/optim.html).

## Details

It is useful for plotting purposes.

## See also

[`ssd_hc()`](https://bcgov.github.io/ssdtools/reference/ssd_hc.md) and
[`ssd_plot()`](https://bcgov.github.io/ssdtools/reference/ssd_plot.md)

## Examples

``` r
fits <- ssd_fit_dists(ssddata::ccme_boron)
predict(fits)
#> # A tibble: 99 × 15
#>    dist    proportion   est    se   lcl   ucl    wt level est_method ci_method  
#>    <chr>        <dbl> <dbl> <dbl> <dbl> <dbl> <dbl> <dbl> <chr>      <chr>      
#>  1 average       0.01 0.267    NA    NA    NA     1  0.95 multi      weighted_s…
#>  2 average       0.02 0.531    NA    NA    NA     1  0.95 multi      weighted_s…
#>  3 average       0.03 0.783    NA    NA    NA     1  0.95 multi      weighted_s…
#>  4 average       0.04 1.02     NA    NA    NA     1  0.95 multi      weighted_s…
#>  5 average       0.05 1.26     NA    NA    NA     1  0.95 multi      weighted_s…
#>  6 average       0.06 1.48     NA    NA    NA     1  0.95 multi      weighted_s…
#>  7 average       0.07 1.71     NA    NA    NA     1  0.95 multi      weighted_s…
#>  8 average       0.08 1.93     NA    NA    NA     1  0.95 multi      weighted_s…
#>  9 average       0.09 2.16     NA    NA    NA     1  0.95 multi      weighted_s…
#> 10 average       0.1  2.38     NA    NA    NA     1  0.95 multi      weighted_s…
#> # ℹ 89 more rows
#> # ℹ 5 more variables: boot_method <chr>, nboot <int>, pboot <dbl>,
#> #   dists <list>, samples <list>
```
