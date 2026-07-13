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

[`ssd_data()`](https://bcgov.github.io/ssdtools/dev/reference/ssd_data.md)

Other generics:
[`glance.fitdists()`](https://bcgov.github.io/ssdtools/dev/reference/glance.fitdists.md),
[`tidy.fitdists()`](https://bcgov.github.io/ssdtools/dev/reference/tidy.fitdists.md)

## Examples

``` r
fits <- ssd_fit_dists(ssddata::ccme_boron)
augment(fits)
#> # A tibble: 28 × 6
#>    Chemical Species                  Conc Group        Units Medium    
#>    <chr>    <chr>                   <dbl> <fct>        <chr> <chr>     
#>  1 Boron    Oncorhynchus mykiss       2.1 Fish         mg/L  Freshwater
#>  2 Boron    Ictalurus punctatus       2.4 Fish         mg/L  Freshwater
#>  3 Boron    Micropterus salmoides     4.1 Fish         mg/L  Freshwater
#>  4 Boron    Brachydanio rerio        10   Fish         mg/L  Freshwater
#>  5 Boron    Carassius auratus        15.6 Fish         mg/L  Freshwater
#>  6 Boron    Pimephales promelas      18.3 Fish         mg/L  Freshwater
#>  7 Boron    Daphnia magna             6   Invertebrate mg/L  Freshwater
#>  8 Boron    Opercularia bimarginata  10   Invertebrate mg/L  Freshwater
#>  9 Boron    Ceriodaphnia dubia       13.4 Invertebrate mg/L  Freshwater
#> 10 Boron    Entosiphon sulcatum      15   Invertebrate mg/L  Freshwater
#> # ℹ 18 more rows
```
