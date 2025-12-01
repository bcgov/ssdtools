# Augmented Data from fitdists Object

Get a tibble of the original data with augmentation.

## Usage

``` r
# S3 method for class 'fitdists'
augment(x, ...)
```

## Arguments

- x:

  The object.

- ...:

  Unused.

## Value

A tibble of the agumented data.

## See also

[`ssd_data()`](https://bcgov.github.io/ssdtools/reference/ssd_data.md)

Other generics:
[`glance.fitdists()`](https://bcgov.github.io/ssdtools/reference/glance.fitdists.md),
[`tidy.fitdists()`](https://bcgov.github.io/ssdtools/reference/tidy.fitdists.md)

## Examples

``` r
fits <- ssd_fit_dists(ssddata::ccme_boron)
augment(fits)
#> # A tibble: 28 × 5
#>    Chemical Species                  Conc Group        Units
#>    <chr>    <chr>                   <dbl> <fct>        <chr>
#>  1 Boron    Oncorhynchus mykiss       2.1 Fish         mg/L 
#>  2 Boron    Ictalurus punctatus       2.4 Fish         mg/L 
#>  3 Boron    Micropterus salmoides     4.1 Fish         mg/L 
#>  4 Boron    Brachydanio rerio        10   Fish         mg/L 
#>  5 Boron    Carassius auratus        15.6 Fish         mg/L 
#>  6 Boron    Pimephales promelas      18.3 Fish         mg/L 
#>  7 Boron    Daphnia magna             6   Invertebrate mg/L 
#>  8 Boron    Opercularia bimarginata  10   Invertebrate mg/L 
#>  9 Boron    Ceriodaphnia dubia       13.4 Invertebrate mg/L 
#> 10 Boron    Entosiphon sulcatum      15   Invertebrate mg/L 
#> # ℹ 18 more rows
```
