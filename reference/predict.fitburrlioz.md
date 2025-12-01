# Predict Hazard Concentrations of fitburrlioz Object

A wrapper on
[`ssd_hc()`](https://bcgov.github.io/ssdtools/reference/ssd_hc.md) that
by default calculates all hazard concentrations from 1 to 99%.

## Usage

``` r
# S3 method for class 'fitburrlioz'
predict(
  object,
  percent,
  proportion = 1:99/100,
  ...,
  ci = FALSE,
  level = 0.95,
  nboot = 1000,
  min_pboot = 0.95,
  parametric = TRUE
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

## Details

It is useful for plotting purposes.

## See also

[`ssd_hc()`](https://bcgov.github.io/ssdtools/reference/ssd_hc.md) and
[`ssd_plot()`](https://bcgov.github.io/ssdtools/reference/ssd_plot.md)

## Examples

``` r
fits <- ssd_fit_burrlioz(ssddata::ccme_boron)
predict(fits)
#> # A tibble: 99 × 15
#>    dist     proportion    est    se   lcl   ucl    wt level est_method ci_method
#>    <chr>         <dbl>  <dbl> <dbl> <dbl> <dbl> <dbl> <dbl> <chr>      <chr>    
#>  1 invpare…       0.01 0.0228    NA    NA    NA     1  0.95 cdf        percenti…
#>  2 invpare…       0.02 0.0772    NA    NA    NA     1  0.95 cdf        percenti…
#>  3 invpare…       0.03 0.158     NA    NA    NA     1  0.95 cdf        percenti…
#>  4 invpare…       0.04 0.261     NA    NA    NA     1  0.95 cdf        percenti…
#>  5 invpare…       0.05 0.387     NA    NA    NA     1  0.95 cdf        percenti…
#>  6 invpare…       0.06 0.533     NA    NA    NA     1  0.95 cdf        percenti…
#>  7 invpare…       0.07 0.699     NA    NA    NA     1  0.95 cdf        percenti…
#>  8 invpare…       0.08 0.885     NA    NA    NA     1  0.95 cdf        percenti…
#>  9 invpare…       0.09 1.09      NA    NA    NA     1  0.95 cdf        percenti…
#> 10 invpare…       0.1  1.31      NA    NA    NA     1  0.95 cdf        percenti…
#> # ℹ 89 more rows
#> # ℹ 5 more variables: boot_method <chr>, nboot <int>, pboot <dbl>,
#> #   dists <list>, samples <list>
```
