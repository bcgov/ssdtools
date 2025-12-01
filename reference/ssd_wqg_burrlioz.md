# Water Quality Guideline for Burrlioz **\[deprecated\]**

Calculates the 5% Hazard Concentration using
[`ssd_fit_burrlioz()`](https://bcgov.github.io/ssdtools/reference/ssd_fit_burrlioz.md)
and [`ssd_hc()`](https://bcgov.github.io/ssdtools/reference/ssd_hc.md).

## Usage

``` r
ssd_wqg_burrlioz(data, left = "Conc")
```

## Arguments

- data:

  A data frame.

- left:

  A string of the column in data with the concentrations.

## Value

A tibble of the 5% hazard concentration with 95% confidence intervals.

## See also

[`ssd_fit_burrlioz()`](https://bcgov.github.io/ssdtools/reference/ssd_fit_burrlioz.md)
and [`ssd_hc()`](https://bcgov.github.io/ssdtools/reference/ssd_hc.md)

Other wqg:
[`ssd_wqg_bc()`](https://bcgov.github.io/ssdtools/reference/ssd_wqg_bc.md)

## Examples

``` r
if (FALSE) { # \dontrun{
ssd_wqg_burrlioz(ssddata::ccme_boron)
} # }
```
