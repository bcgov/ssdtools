# Match Moments

Gets a named list of the values that produce the moment values (meanlog
and sdlog) by distribution and term.

## Usage

``` r
ssd_match_moments(
  dists = ssd_dists_bcanz(),
  meanlog = 1,
  sdlog = 1,
  ...,
  nsim = 1e+05
)
```

## Arguments

- dists:

  A character vector of the distribution names.

- meanlog:

  The mean on the log scale.

- sdlog:

  The standard deviation on the log scale.

- ...:

  Unused.

- nsim:

  A positive whole number of the number of simulations to generate.

## Value

a named list of the values that produce the moment values by
distribution and term.

## See also

[`estimates.fitdists()`](https://bcgov.github.io/ssdtools/reference/estimates.fitdists.md),
[`ssd_hc()`](https://bcgov.github.io/ssdtools/reference/ssd_hc.md) and
[`ssd_plot_cdf()`](https://bcgov.github.io/ssdtools/reference/ssd_plot_cdf.md)

## Examples

``` r
moments <- ssd_match_moments()
print(moments)
#> $gamma
#>   shape   scale 
#> 1.62135 2.27616 
#> 
#> $lgumbel
#> locationlog    scalelog 
#>    0.534375    0.762500 
#> 
#> $llogis
#> locationlog    scalelog 
#>     0.96875     0.52500 
#> 
#> $lnorm
#>  meanlog    sdlog 
#> 1.091455 1.004492 
#> 
#> $lnorm_lnorm
#>  meanlog1    sdlog1  meanlog2    sdlog2      pmix 
#> 0.1409856 1.0659456 1.1849856 0.9799296 0.1487680 
#> 
#> $weibull
#>    shape    scale 
#> 1.352319 4.502075 
#> 
ssd_hc(moments)
#> # A tibble: 6 × 9
#>   dist        proportion   est    se   lcl   ucl    wt nboot pboot
#>   <chr>            <dbl> <dbl> <dbl> <dbl> <dbl> <dbl> <int> <dbl>
#> 1 gamma             0.05 0.490    NA    NA    NA     1     0    NA
#> 2 lgumbel           0.05 0.739    NA    NA    NA     1     0    NA
#> 3 llogis            0.05 0.562    NA    NA    NA     1     0    NA
#> 4 lnorm             0.05 0.571    NA    NA    NA     1     0    NA
#> 5 lnorm_lnorm       0.05 0.469    NA    NA    NA     1     0    NA
#> 6 weibull           0.05 0.501    NA    NA    NA     1     0    NA
ssd_plot_cdf(moments)
```
