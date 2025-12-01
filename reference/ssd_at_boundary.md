# Is At Boundary

Generic function to test if one or more parameters is at boundary.

## Usage

``` r
ssd_at_boundary(x, ...)

# S3 method for class 'tmbfit'
ssd_at_boundary(x, ...)

# S3 method for class 'fitdists'
ssd_at_boundary(x, ...)
```

## Arguments

- x:

  The object.

- ...:

  Unused.

## Value

A flag for each distribution indicating if one or more parameters at
boundary.

A flag indicating if one or more parameters at boundary.

A logical vector for each distribution indicating if one or more
parameters at boundary.

## Methods (by class)

- `ssd_at_boundary(tmbfit)`: Is At Boundary for tmbfit Object

- `ssd_at_boundary(fitdists)`: Is At Boundary for fitdists Object

## Examples

``` r
fits <- ssd_fit_dists(ssddata::ccme_boron,
  dists = c("lnorm", "lnorm_lnorm", "burrIII3")
)
ssd_at_boundary(fits$lnorm)
#> [1] FALSE
ssd_at_boundary(fits$lnorm_lnorm)
#> [1] FALSE
ssd_at_boundary(fits$burrIII3)
#> [1] TRUE

fits <- ssd_fit_dists(ssddata::ccme_boron,
  dists = c("lnorm", "lnorm_lnorm", "burrIII3")
)
ssd_at_boundary(fits)
#>       lnorm lnorm_lnorm    burrIII3 
#>       FALSE       FALSE        TRUE 
```
