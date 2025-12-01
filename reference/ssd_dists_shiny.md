# All Shiny Species Sensitivity Distributions

Gets a character vector of the names of all the available distributions
in the shinyssdtools.

## Usage

``` r
ssd_dists_shiny()
```

## Value

A unique, sorted character vector of the distributions.

## See also

Other dists:
[`dist_data`](https://bcgov.github.io/ssdtools/reference/dist_data.md),
[`ssd_dists()`](https://bcgov.github.io/ssdtools/reference/ssd_dists.md),
[`ssd_dists_all()`](https://bcgov.github.io/ssdtools/reference/ssd_dists_all.md)

## Examples

``` r
ssd_dists_shiny()
#> Warning: `ssd_dists_shiny()` was deprecated in ssdtools 2.3.0.
#> ℹ Use `ssd_dists(tails = TRUE)` instead.
#> [1] "burrIII3"      "gamma"         "gompertz"      "lgumbel"      
#> [5] "llogis"        "llogis_llogis" "lnorm"         "lnorm_lnorm"  
#> [9] "weibull"      
```
