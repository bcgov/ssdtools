# Sort Species Sensitivity Data

Sorts Species Sensitivity Data by empirical cumulative density (ECD).

## Usage

``` r
ssd_sort_data(data, left = "Conc", right = left)
```

## Arguments

- data:

  A data frame.

- left:

  A string of the column in data with the concentrations.

- right:

  A string of the column in data with the right concentration values.

## Value

data sorted by the empirical cumulative density.

## Details

Useful for sorting data before using
[`geom_ssdpoint()`](https://bcgov.github.io/ssdtools/reference/geom_ssdpoint.md)
and
[`geom_ssdsegment()`](https://bcgov.github.io/ssdtools/reference/geom_ssdsegment.md)
to construct plots for censored data with `stat = identity` to ensure
order is the same for the various components.

## See also

[`ssd_ecd_data()`](https://bcgov.github.io/ssdtools/reference/ssd_ecd_data.md)
and
[`ssd_data()`](https://bcgov.github.io/ssdtools/reference/ssd_data.md)

## Examples

``` r
ssd_sort_data(ssddata::ccme_boron)
#> # A tibble: 28 × 5
#>    Chemical Species                Conc Group        Units
#>    <chr>    <chr>                 <dbl> <fct>        <chr>
#>  1 Boron    Elodea canadensis       1   Plant        mg/L 
#>  2 Boron    Spirodella polyrrhiza   1.8 Plant        mg/L 
#>  3 Boron    Chlorella pyrenoidosa   2   Plant        mg/L 
#>  4 Boron    Oncorhynchus mykiss     2.1 Fish         mg/L 
#>  5 Boron    Ictalurus punctatus     2.4 Fish         mg/L 
#>  6 Boron    Phragmites australis    4   Plant        mg/L 
#>  7 Boron    Micropterus salmoides   4.1 Fish         mg/L 
#>  8 Boron    Chlorella vulgaris      5.2 Plant        mg/L 
#>  9 Boron    Daphnia magna           6   Invertebrate mg/L 
#> 10 Boron    Brachydanio rerio      10   Fish         mg/L 
#> # ℹ 18 more rows
```
