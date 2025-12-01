# Calculate Minimum Proportion in Mixture Models

Calculate Minimum Proportion in Mixture Models

## Usage

``` r
ssd_min_pmix(n)
```

## Arguments

- n:

  positive number of observations.

## Value

A number between 0 and 0.5 of the minimum proportion in mixture models.

## See also

[`ssd_fit_dists()`](https://bcgov.github.io/ssdtools/reference/ssd_fit_dists.md)

## Examples

``` r
ssd_min_pmix(6)
#> [1] 0.5
ssd_min_pmix(50)
#> [1] 0.1
```
