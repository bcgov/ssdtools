# Turn a fitdists Object into a Tidy Tibble

A wrapper on
[`tidy.fitdists()`](https://bcgov.github.io/ssdtools/reference/tidy.fitdists.md).

## Usage

``` r
# S3 method for class 'fitdists'
coef(object, ...)
```

## Arguments

- object:

  The object.

- ...:

  Unused.

## See also

[`tidy.fitdists()`](https://bcgov.github.io/ssdtools/reference/tidy.fitdists.md)

## Examples

``` r
fits <- ssd_fit_dists(ssddata::ccme_boron)
coef(fits)
#> # A tibble: 15 × 4
#>    dist        term           est    se
#>    <chr>       <chr>        <dbl> <dbl>
#>  1 gamma       scale       25.1   7.64 
#>  2 gamma       shape        0.950 0.223
#>  3 lgumbel     locationlog  1.92  0.247
#>  4 lgumbel     scalelog     1.23  0.173
#>  5 llogis      locationlog  2.63  0.248
#>  6 llogis      scalelog     0.740 0.114
#>  7 lnorm       meanlog      2.56  0.235
#>  8 lnorm       sdlog        1.24  0.166
#>  9 lnorm_lnorm meanlog1     0.949 0.318
#> 10 lnorm_lnorm meanlog2     3.20  0.253
#> 11 lnorm_lnorm pmix         0.284 0.123
#> 12 lnorm_lnorm sdlog1       0.554 0.212
#> 13 lnorm_lnorm sdlog2       0.769 0.194
#> 14 weibull     scale       23.5   4.86 
#> 15 weibull     shape        0.966 0.145
```
