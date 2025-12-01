# BCANZ Distributions

Gets a character vector of the names of the distributions adopted by BC,
Canada, Australia and New Zealand for official guidelines.

## Usage

``` r
ssd_dists_bcanz(npars = c(2L, 5L))
```

## Arguments

- npars:

  A whole numeric vector specifying which distributions to include based
  on the number of parameters.

## Value

A unique, sorted character vector of the distributions.

## See also

[`ssd_dists()`](https://bcgov.github.io/ssdtools/reference/ssd_dists.md)

## Examples

``` r
ssd_dists_bcanz()
#> [1] "gamma"       "lgumbel"     "llogis"      "lnorm"       "lnorm_lnorm"
#> [6] "weibull"    
ssd_dists_bcanz(npars = 2)
#> [1] "gamma"   "lgumbel" "llogis"  "lnorm"   "weibull"
```
