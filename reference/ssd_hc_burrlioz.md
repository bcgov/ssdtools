# Hazard Concentrations for Burrlioz Fit **\[deprecated\]**

Deprecated for
[`ssd_hc()`](https://bcgov.github.io/ssdtools/reference/ssd_hc.md).

## Usage

``` r
ssd_hc_burrlioz(
  x,
  percent,
  proportion = 0.05,
  ci = FALSE,
  level = 0.95,
  nboot = 1000,
  min_pboot = 0.95,
  parametric = FALSE
)
```

## Arguments

- x:

  The object.

- percent:

  A numeric vector of percent values to estimate hazard concentrations
  for. Deprecated for `proportion = 0.05`. **\[deprecated\]**

- proportion:

  A numeric vector of proportion values to estimate hazard
  concentrations for.

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

- parametric:

  A flag specifying whether to perform parametric bootstrapping as
  opposed to non-parametrically resampling the original data with
  replacement.

## Value

A tibble of corresponding hazard concentrations.
