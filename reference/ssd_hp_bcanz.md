# BCANZ Hazard Proportion

Gets proportion of species affected at specified concentration(s) using
settings adopted by BC, Canada, Australia and New Zealand for official
guidelines. This function can take several minutes to run with
recommended 10,000 iterations.

## Usage

``` r
ssd_hp_bcanz(
  x,
  conc = 1,
  ...,
  nboot = 10000,
  min_pboot = 0.95,
  proportion = FALSE
)
```

## Arguments

- x:

  The object.

- conc:

  A numeric vector of concentrations to calculate the hazard proportions
  for.

- ...:

  Unused.

- nboot:

  A count of the number of bootstrap samples to use to estimate the
  confidence limits. A value of 10,000 is recommended for official
  guidelines.

- min_pboot:

  A number between 0 and 1 of the minimum proportion of bootstrap
  samples that must successfully fit (return a likelihood) to report the
  confidence intervals.

- proportion:

  A numeric vector of proportion values to estimate hazard
  concentrations for.

## Value

A tibble of corresponding hazard concentrations.

## See also

[`ssd_hp()`](https://bcgov.github.io/ssdtools/reference/ssd_hp.md).

Other BCANZ:
[`ssd_fit_bcanz()`](https://bcgov.github.io/ssdtools/reference/ssd_fit_bcanz.md),
[`ssd_hc_bcanz()`](https://bcgov.github.io/ssdtools/reference/ssd_hc_bcanz.md)

## Examples

``` r
fits <- ssd_fit_bcanz(ssddata::ccme_boron)
ssd_hp_bcanz(fits, nboot = 100)
#> Warning: ssd_hp(proportion = FALSE) was deprecated in ssdtools 2.3.1.
#> ℹ Please use ssd_hp(proportion = TRUE) instead.
#> ℹ Please set the `proportion` argument to `ssd_hp_bcanz()` to be TRUE which
#>   will cause it to return hazard proportions instead of percentages then update
#>   your downstream code accordingly.
#> # A tibble: 1 × 15
#>   dist     conc   est    se   lcl   ucl    wt level est_method ci_method       
#>   <chr>   <dbl> <dbl> <dbl> <dbl> <dbl> <dbl> <dbl> <chr>      <chr>           
#> 1 average     1  3.90  2.21 0.123  7.83     1  0.95 multi      weighted_samples
#> # ℹ 5 more variables: boot_method <chr>, nboot <dbl>, pboot <dbl>,
#> #   dists <list>, samples <list>
```
