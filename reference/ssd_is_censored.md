# Is Censored

Tests if an object has censored data.

Test if a data frame is censored.

Test if a fitdists object is censored.

## Usage

``` r
ssd_is_censored(x, ...)

# S3 method for class 'data.frame'
ssd_is_censored(x, left = "Conc", right = left, ...)

# S3 method for class 'fitdists'
ssd_is_censored(x, ...)
```

## Arguments

- x:

  The object.

- ...:

  Unused.

- left:

  A string of the column in data with the concentrations.

- right:

  A string of the column in data with the right concentration values.

## Value

A flag indicating whether an object is censored.

## Examples

``` r
ssd_is_censored(ssddata::ccme_boron)
#> [1] FALSE
ssd_is_censored(data.frame(Conc = 1, right = 2), right = "right")
#> [1] TRUE

fits <- ssd_fit_dists(ssddata::ccme_boron)
ssd_is_censored(fits)
#> [1] FALSE
```
