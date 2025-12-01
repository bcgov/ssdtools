# Is Computable Standard Errors

Generic function to test if all parameters have numerically computable
standard errors.

## Usage

``` r
ssd_computable(x, ...)

# S3 method for class 'tmbfit'
ssd_computable(x, ...)

# S3 method for class 'fitdists'
ssd_computable(x, ...)
```

## Arguments

- x:

  The object.

- ...:

  Unused.

## Value

A flag for each distribution indicating if all parameters have
numerically computable standard errors.

A flag indicating if all parameters have numerically computable standard
errors.

A logical vector for each distribution indicating if all parameters have
numerically computable standard errors.

## Methods (by class)

- `ssd_computable(tmbfit)`: Is Computable Standard for tmbfit Object

- `ssd_computable(fitdists)`: Is At Boundary for fitdists Object

## Examples

``` r
fits <- ssd_fit_dists(ssddata::ccme_boron,
  dists = c("lnorm", "lnorm_lnorm", "burrIII3")
)
ssd_computable(fits$lnorm)
#> [1] TRUE
ssd_computable(fits$lnorm_lnorm)
#> [1] TRUE
ssd_computable(fits$burrIII3)
#> [1] FALSE

fits <- ssd_fit_dists(ssddata::ccme_boron,
  dists = c("lnorm", "lnorm_lnorm", "burrIII3")
)
ssd_computable(fits)
#>       lnorm lnorm_lnorm    burrIII3 
#>        TRUE        TRUE       FALSE 
```
