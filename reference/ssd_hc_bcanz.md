# BCANZ Hazard Concentrations

Gets hazard concentrations with confidence intervals that protect 1, 5,
10 and 20% of species using settings adopted by BC, Canada, Australia
and New Zealand for official guidelines. This function can take several
minutes to run with recommended 10,000 iterations.

## Usage

``` r
ssd_hc_bcanz(x, ..., nboot = 10000, min_pboot = 0.95)
```

## Arguments

- x:

  The object.

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

## Value

A tibble of corresponding hazard concentrations.

## See also

[`ssd_hc()`](https://bcgov.github.io/ssdtools/reference/ssd_hc.md).

Other BCANZ:
[`ssd_fit_bcanz()`](https://bcgov.github.io/ssdtools/reference/ssd_fit_bcanz.md),
[`ssd_hp_bcanz()`](https://bcgov.github.io/ssdtools/reference/ssd_hp_bcanz.md)

## Examples

``` r
fits <- ssd_fit_bcanz(ssddata::ccme_boron)
ssd_hc_bcanz(fits, nboot = 100)
#> # A tibble: 4 × 15
#>   dist    proportion   est    se    lcl   ucl    wt level est_method ci_method  
#>   <chr>        <dbl> <dbl> <dbl>  <dbl> <dbl> <dbl> <dbl> <chr>      <chr>      
#> 1 average       0.01 0.267 0.322 0.0466  1.04     1  0.95 multi      weighted_s…
#> 2 average       0.05 1.26  0.681 0.424   2.87     1  0.95 multi      weighted_s…
#> 3 average       0.1  2.38  1.04  1.03    4.59     1  0.95 multi      weighted_s…
#> 4 average       0.2  4.81  1.71  2.60    8.72     1  0.95 multi      weighted_s…
#> # ℹ 5 more variables: boot_method <chr>, nboot <dbl>, pboot <dbl>,
#> #   dists <list>, samples <list>
```
