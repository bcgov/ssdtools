# Fit BCANZ Distributions

Fits distributions using settings adopted by BC, Canada, Australia and
New Zealand for official guidelines.

## Usage

``` r
ssd_fit_bcanz(data, left = "Conc", ..., dists = ssd_dists_bcanz())
```

## Arguments

- data:

  A data frame.

- left:

  A string of the column in data with the concentrations.

- ...:

  Unused.

- dists:

  A character vector of the distribution names.

## Value

An object of class fitdists.

## See also

[`ssd_fit_dists()`](https://bcgov.github.io/ssdtools/reference/ssd_fit_dists.md)

Other BCANZ:
[`ssd_hc_bcanz()`](https://bcgov.github.io/ssdtools/reference/ssd_hc_bcanz.md),
[`ssd_hp_bcanz()`](https://bcgov.github.io/ssdtools/reference/ssd_hp_bcanz.md)

## Examples

``` r
ssd_fit_bcanz(ssddata::ccme_boron)
#> Distribution 'gamma'
#>   scale 25.1268
#>   shape 0.950179
#> 
#> Distribution 'lgumbel'
#>   locationlog 1.92263
#>   scalelog 1.23224
#> 
#> Distribution 'llogis'
#>   locationlog 2.62628
#>   scalelog 0.740426
#> 
#> Distribution 'lnorm'
#>   meanlog 2.56165
#>   sdlog 1.24154
#> 
#> Distribution 'lnorm_lnorm'
#>   meanlog1 0.949483
#>   meanlog2 3.20102
#>   pmix 0.283968
#>   sdlog1 0.554465
#>   sdlog2 0.768862
#> 
#> Distribution 'weibull'
#>   scale 23.514
#>   shape 0.9661
#> 
#> Parameters estimated from 28 rows of data.
```
