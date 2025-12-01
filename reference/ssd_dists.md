# Species Sensitivity Distributions

Gets a character vector of the names of the available distributions.

## Usage

``` r
ssd_dists(bcanz = NULL, ..., tails = NULL, npars = 2:5, valid = TRUE)
```

## Arguments

- bcanz:

  A flag or NULL specifying whether to only include distributions in the
  set that is approved by BC, Canada, Australia and New Zealand for
  official guidelines.

- ...:

  Unused.

- tails:

  A flag or NULL specifying whether to only include distributions with
  both tails.

- npars:

  A whole numeric vector specifying which distributions to include based
  on the number of parameters.

- valid:

  A flag or NULL specifying whether to include distributions with valid
  likelihoods that allows them to be fit with other distributions for
  modeling averaging.

## Value

A unique, sorted character vector of the distributions.

## See also

Other dists:
[`dist_data`](https://bcgov.github.io/ssdtools/reference/dist_data.md),
[`ssd_dists_all()`](https://bcgov.github.io/ssdtools/reference/ssd_dists_all.md),
[`ssd_dists_shiny()`](https://bcgov.github.io/ssdtools/reference/ssd_dists_shiny.md)

## Examples

``` r
ssd_dists()
#> [1] "burrIII3"      "gamma"         "gompertz"      "lgumbel"      
#> [5] "llogis"        "llogis_llogis" "lnorm"         "lnorm_lnorm"  
#> [9] "weibull"      
ssd_dists(bcanz = TRUE)
#> [1] "gamma"       "lgumbel"     "llogis"      "lnorm"       "lnorm_lnorm"
#> [6] "weibull"    
ssd_dists(tails = FALSE)
#> character(0)
ssd_dists(npars = 5)
#> [1] "llogis_llogis" "lnorm_lnorm"  
```
