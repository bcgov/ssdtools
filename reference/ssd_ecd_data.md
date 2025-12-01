# Empirical Cumulative Density for Species Sensitivity Data

Empirical Cumulative Density for Species Sensitivity Data

## Usage

``` r
ssd_ecd_data(
  data,
  left = "Conc",
  right = left,
  ...,
  bounds = c(left = 1, right = 1)
)
```

## Arguments

- data:

  A data frame.

- left:

  A string of the column in data with the concentrations.

- right:

  A string of the column in data with the right concentration values.

- ...:

  Unused.

- bounds:

  A named non-negative numeric vector of the left and right bounds for
  uncensored missing (0 and Inf) data in terms of the orders of
  magnitude relative to the extremes for non-missing values.

## Value

A numeric vector of the empirical cumulative density for the rows in
data.

## See also

[`ssd_ecd()`](https://bcgov.github.io/ssdtools/reference/ssd_ecd.md) and
[`ssd_data()`](https://bcgov.github.io/ssdtools/reference/ssd_data.md)

## Examples

``` r
ssd_ecd_data(ssddata::ccme_boron)
#>  [1] 0.12500000 0.16071429 0.23214286 0.33928571 0.51785714 0.55357143
#>  [7] 0.30357143 0.37500000 0.44642857 0.48214286 0.58928571 0.62500000
#> [13] 0.66071429 0.76785714 0.80357143 0.91071429 0.94642857 0.98214286
#> [19] 0.01785714 0.05357143 0.08928571 0.19642857 0.26785714 0.41071429
#> [25] 0.69642857 0.73214286 0.83928571 0.87500000
```
