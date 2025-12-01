# All Species Sensitivity Distributions

Gets a character vector of the names of all the available distributions.

## Usage

``` r
ssd_dists_all(valid = TRUE)
```

## Arguments

- valid:

  A flag or NULL specifying whether to include distributions with valid
  likelihoods that allows them to be fit with other distributions for
  modeling averaging.

## Value

A unique, sorted character vector of the distributions.

## See also

Other dists:
[`dist_data`](https://bcgov.github.io/ssdtools/reference/dist_data.md),
[`ssd_dists()`](https://bcgov.github.io/ssdtools/reference/ssd_dists.md),
[`ssd_dists_shiny()`](https://bcgov.github.io/ssdtools/reference/ssd_dists_shiny.md)

## Examples

``` r
ssd_dists_all()
#> [1] "burrIII3"      "gamma"         "gompertz"      "lgumbel"      
#> [5] "llogis"        "llogis_llogis" "lnorm"         "lnorm_lnorm"  
#> [9] "weibull"      
```
