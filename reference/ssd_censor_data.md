# Censor Data

Censors data to a specified range based on the `censoring` argument. The
function is useful for creating test data sets.

## Usage

``` r
ssd_censor_data(data, left = "Conc", ..., right = left, censoring = c(0, Inf))
```

## Arguments

- data:

  A data frame.

- left:

  A string of the column in data with the concentrations.

- ...:

  Unused.

- right:

  A string of the column in data with the right concentration values.

- censoring:

  A numeric vector of the left and right censoring values.

## Value

A tibble of the censored data.

## Examples

``` r
ssd_censor_data(ssddata::ccme_boron, censoring = c(2.5, Inf))
#> # A tibble: 28 × 7
#>    Chemical Species                  Conc Group        Units Medium     right
#>    <chr>    <chr>                   <dbl> <fct>        <chr> <chr>      <dbl>
#>  1 Boron    Oncorhynchus mykiss       0   Fish         mg/L  Freshwater   2.5
#>  2 Boron    Ictalurus punctatus       0   Fish         mg/L  Freshwater   2.5
#>  3 Boron    Micropterus salmoides     4.1 Fish         mg/L  Freshwater   4.1
#>  4 Boron    Brachydanio rerio        10   Fish         mg/L  Freshwater  10  
#>  5 Boron    Carassius auratus        15.6 Fish         mg/L  Freshwater  15.6
#>  6 Boron    Pimephales promelas      18.3 Fish         mg/L  Freshwater  18.3
#>  7 Boron    Daphnia magna             6   Invertebrate mg/L  Freshwater   6  
#>  8 Boron    Opercularia bimarginata  10   Invertebrate mg/L  Freshwater  10  
#>  9 Boron    Ceriodaphnia dubia       13.4 Invertebrate mg/L  Freshwater  13.4
#> 10 Boron    Entosiphon sulcatum      15   Invertebrate mg/L  Freshwater  15  
#> # ℹ 18 more rows
```
