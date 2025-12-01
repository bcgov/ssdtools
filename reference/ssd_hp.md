# Hazard Proportion

Calculates proportion of species affected at specified concentration(s)
with quantile based bootstrap confidence intervals for individual or
model-averaged distributions using parametric or non-parametric
bootstrapping. For more information see the inverse function
[`ssd_hc()`](https://bcgov.github.io/ssdtools/reference/ssd_hc.md).

## Usage

``` r
ssd_hp(x, ...)

# S3 method for class 'fitdists'
ssd_hp(
  x,
  conc = 1,
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
  proportion = FALSE,
  samples = FALSE,
  save_to = NULL,
  control = NULL
)

# S3 method for class 'fitburrlioz'
ssd_hp(
  x,
  conc = 1,
  ...,
  ci = FALSE,
  level = 0.95,
  nboot = 1000,
  min_pboot = 0.95,
  parametric = FALSE,
  proportion = FALSE,
  samples = FALSE,
  save_to = NULL
)
```

## Arguments

- x:

  The object.

- ...:

  Unused.

- conc:

  A numeric vector of concentrations to calculate the hazard proportions
  for.

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

- proportion:

  A flag specifying whether to return hazard proportions
  (`proportion = TRUE`) or hazard percentages (`proportion = FALSE`). To
  not break existing code the default value is `FALSE` but will be
  switching the default to `TRUE` in a future version. The user is
  recommended to manually set to `TRUE` now to avoid unexpected changes
  in future versions.

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

A tibble of corresponding hazard proportions.

## Methods (by class)

- `ssd_hp(fitdists)`: Hazard Proportions for fitdists Object

- `ssd_hp(fitburrlioz)`: Hazard Proportions for fitburrlioz Object

## See also

[`ssd_hc()`](https://bcgov.github.io/ssdtools/reference/ssd_hc.md)

## Examples

``` r
fits <- ssd_fit_dists(ssddata::ccme_boron)
ssd_hp(fits, conc = 1)
#> Warning: ssd_hp(proportion = FALSE) was deprecated in ssdtools 2.3.1.
#> ℹ Please use ssd_hp(proportion = TRUE) instead.
#> ℹ Please set the `proportion` argument to `ssd_hp()` to be TRUE which will
#>   cause it to return hazard proportions instead of percentages then update your
#>   downstream code accordingly.
#> # A tibble: 1 × 15
#>   dist     conc   est    se   lcl   ucl    wt level est_method ci_method       
#>   <chr>   <dbl> <dbl> <dbl> <dbl> <dbl> <dbl> <dbl> <chr>      <chr>           
#> 1 average     1  3.90    NA    NA    NA     1  0.95 multi      weighted_samples
#> # ℹ 5 more variables: boot_method <chr>, nboot <int>, pboot <dbl>,
#> #   dists <list>, samples <list>

fit <- ssd_fit_burrlioz(ssddata::ccme_boron)
ssd_hp(fit)
#> # A tibble: 1 × 15
#>   dist       conc   est    se   lcl   ucl    wt level est_method ci_method 
#>   <chr>     <dbl> <dbl> <dbl> <dbl> <dbl> <dbl> <dbl> <chr>      <chr>     
#> 1 invpareto     1  8.58    NA    NA    NA     1  0.95 cdf        percentile
#> # ℹ 5 more variables: boot_method <chr>, nboot <int>, pboot <dbl>,
#> #   dists <list>, samples <list>
```
