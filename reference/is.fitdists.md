# Is fitdists Object

Tests whether x is a fitdists Object.

## Usage

``` r
is.fitdists(x)
```

## Arguments

- x:

  The object.

## Value

A flag specifying whether x is a fitdists Object.

## Examples

``` r
fits <- ssd_fit_dists(ssddata::ccme_boron)
is.fitdists(fits)
#> [1] TRUE
```
