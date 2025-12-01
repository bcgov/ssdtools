# Get a tibble summarizing each distribution

Gets a tibble with a single row for each distribution.

## Usage

``` r
# S3 method for class 'fitdists'
glance(x, ..., wt = FALSE)
```

## Arguments

- x:

  The object.

- ...:

  Unused.

- wt:

  A flag specifying whether to return the Akaike weight as "wt" instead
  of "weight".

## Value

A tidy tibble of the distributions.

## See also

[`ssd_gof()`](https://bcgov.github.io/ssdtools/reference/ssd_gof.md)

Other generics:
[`augment.fitdists()`](https://bcgov.github.io/ssdtools/reference/augment.fitdists.md),
[`tidy.fitdists()`](https://bcgov.github.io/ssdtools/reference/tidy.fitdists.md)

## Examples

``` r
fits <- ssd_fit_dists(ssddata::ccme_boron)
glance(fits, wt = TRUE)
#> # A tibble: 6 × 8
#>   dist        npars  nobs log_lik   aic  aicc   delta     wt
#>   <chr>       <int> <int>   <dbl> <dbl> <dbl>   <dbl>  <dbl>
#> 1 gamma           2    28   -117.  238.  238. 0.00503 0.357 
#> 2 lgumbel         2    28   -120.  244.  245. 6.56    0.0134
#> 3 llogis          2    28   -119.  241.  241. 3.39    0.0656
#> 4 lnorm           2    28   -118.  239.  240. 1.40    0.177 
#> 5 lnorm_lnorm     5    28   -115.  240.  243. 4.98    0.0296
#> 6 weibull         2    28   -117.  238.  238. 0       0.357 
```
