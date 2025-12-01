# Estimates for fitdists Object

Gets a named list of the estimated weights and parameters.

## Usage

``` r
# S3 method for class 'fitdists'
estimates(x, all_estimates = FALSE, ...)
```

## Arguments

- x:

  The object.

- all_estimates:

  A flag specifying whether to calculate estimates for all implemented
  distributions.

- ...:

  Unused.

## Value

A named list of the estimates.

## See also

[`tidy.fitdists()`](https://bcgov.github.io/ssdtools/reference/tidy.fitdists.md),
[`ssd_match_moments()`](https://bcgov.github.io/ssdtools/reference/ssd_match_moments.md),
[`ssd_hc()`](https://bcgov.github.io/ssdtools/reference/ssd_hc.md) and
[`ssd_plot_cdf()`](https://bcgov.github.io/ssdtools/reference/ssd_plot_cdf.md)

## Examples

``` r
fits <- ssd_fit_dists(ssddata::ccme_boron)
estimates(fits)
#> $gamma.weight
#> [1] 0.3565737
#> 
#> $gamma.scale
#> [1] 25.12683
#> 
#> $gamma.shape
#> [1] 0.9501795
#> 
#> $lgumbel.weight
#> [1] 0.01344657
#> 
#> $lgumbel.locationlog
#> [1] 1.922631
#> 
#> $lgumbel.scalelog
#> [1] 1.232239
#> 
#> $llogis.weight
#> [1] 0.06564519
#> 
#> $llogis.locationlog
#> [1] 2.626276
#> 
#> $llogis.scalelog
#> [1] 0.7404264
#> 
#> $lnorm.weight
#> [1] 0.1772362
#> 
#> $lnorm.meanlog
#> [1] 2.561646
#> 
#> $lnorm.sdlog
#> [1] 1.241541
#> 
#> $lnorm_lnorm.weight
#> [1] 0.02962678
#> 
#> $lnorm_lnorm.meanlog1
#> [1] 0.9494834
#> 
#> $lnorm_lnorm.meanlog2
#> [1] 3.201021
#> 
#> $lnorm_lnorm.pmix
#> [1] 0.2839679
#> 
#> $lnorm_lnorm.sdlog1
#> [1] 0.5544649
#> 
#> $lnorm_lnorm.sdlog2
#> [1] 0.7688617
#> 
#> $weibull.weight
#> [1] 0.3574716
#> 
#> $weibull.scale
#> [1] 23.51397
#> 
#> $weibull.shape
#> [1] 0.9660997
#> 
```
