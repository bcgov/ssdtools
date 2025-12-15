# Color-blind Palette for SSD Plots

Color-blind Palette for SSD Plots

## Usage

``` r
ssd_pal()
```

## Value

A character vector of a color blind palette with 8 colors.

## See also

Other ggplot:
[`geom_hcintersect()`](https://bcgov.github.io/ssdtools/reference/geom_hcintersect.md),
[`geom_ssdpoint()`](https://bcgov.github.io/ssdtools/reference/geom_ssdpoint.md),
[`geom_ssdsegment()`](https://bcgov.github.io/ssdtools/reference/geom_ssdsegment.md),
[`geom_xribbon()`](https://bcgov.github.io/ssdtools/reference/geom_xribbon.md),
[`scale_colour_ssd()`](https://bcgov.github.io/ssdtools/reference/scale_colour_ssd.md)

## Examples

``` r
ssd_pal()
#> function (n) 
#> {
#>     n_values <- length(values)
#>     if (n > n_values) {
#>         cli::cli_warn("This manual palette can handle a maximum of {n_values} values. You have supplied {n}")
#>     }
#>     unname(values[seq_len(n)])
#> }
#> <bytecode: 0x562f8e971b80>
#> <environment: 0x562fa228f308>
#> attr(,"class")
#> [1] "pal_discrete" "scales_pal"   "function"    
#> attr(,"type")
#> [1] "colour"
#> attr(,"nlevels")
#> [1] 8
#> attr(,"max_n")
#> [1] 8
```
