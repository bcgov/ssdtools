# Turn a fitdists Object into a Tibble

Turns a fitdists object into a tidy tibble of the estimates (est) and
standard errors (se) by the terms (term) and distributions (dist).

## Usage

``` r
# S3 method for class 'fitdists'
tidy(x, all = FALSE, ...)
```

## Arguments

- x:

  The object.

- all:

  A flag specifying whether to also return transformed parameters.

- ...:

  Unused.

## Value

A tidy tibble of the estimates and standard errors.

## See also

[`coef.fitdists()`](https://bcgov.github.io/ssdtools/reference/coef.fitdists.md)

Other generics:
[`augment.fitdists()`](https://bcgov.github.io/ssdtools/reference/augment.fitdists.md),
[`glance.fitdists()`](https://bcgov.github.io/ssdtools/reference/glance.fitdists.md)

## Examples

``` r
fits <- ssd_fit_dists(ssddata::ccme_boron)
tidy(fits)
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
tidy(fits, all = TRUE)
#> # A tibble: 24 × 4
#>    dist    term             est    se
#>    <chr>   <chr>          <dbl> <dbl>
#>  1 gamma   log_scale     3.22   0.304
#>  2 gamma   log_shape    -0.0511 0.234
#>  3 gamma   scale        25.1    7.64 
#>  4 gamma   shape         0.950  0.223
#>  5 lgumbel locationlog   1.92   0.247
#>  6 lgumbel log_scalelog  0.209  0.140
#>  7 lgumbel scalelog      1.23   0.173
#>  8 llogis  locationlog   2.63   0.248
#>  9 llogis  log_scalelog -0.301  0.154
#> 10 llogis  scalelog      0.740  0.114
#> # ℹ 14 more rows
```
