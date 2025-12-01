# Fit Burrlioz Distributions

Fits 'burrIII3' distribution. If shape1 parameter is at boundary returns
'lgumbel' (which is equivalent to inverse Weibull). Else if shape2
parameter is at a boundary returns 'invpareto'. Otherwise returns
'burrIII3'

## Usage

``` r
ssd_fit_burrlioz(
  data,
  left = "Conc",
  ...,
  rescale = FALSE,
  control = list(),
  silent = FALSE
)
```

## Arguments

- data:

  A data frame.

- left:

  A string of the column in data with the concentrations.

- ...:

  Unused.

- rescale:

  A flag specifying whether to leave the values unchanged (FALSE) or to
  rescale concentration values by dividing by the geometric mean of the
  minimum and maximum positive finite values (TRUE) or a string
  specifying whether to leave the values unchanged ("no") or to rescale
  concentration values by dividing by the geometric mean of the minimum
  and maximum positive finite values ("geomean") or to logistically
  transform ("odds").

- control:

  A list of control parameters passed to
  [`stats::optim()`](https://rdrr.io/r/stats/optim.html).

- silent:

  A flag indicating whether fits should fail silently.

## Value

An object of class fitdists.

## See also

[`ssd_fit_dists()`](https://bcgov.github.io/ssdtools/reference/ssd_fit_dists.md)

## Examples

``` r
ssd_fit_burrlioz(ssddata::ccme_boron)
#> Distribution 'invpareto'
#>   scale 75.2608
#>   shape 0.568403
#> 
#> Parameters estimated from 28 rows of data.
```
