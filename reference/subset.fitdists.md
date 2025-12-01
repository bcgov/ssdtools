# Subset fitdists Object

Select a subset of distributions from a fitdists object. The Akaike
Information-theoretic Criterion differences are calculated after
selecting the distributions named in select.

## Usage

``` r
# S3 method for class 'fitdists'
subset(x, select = names(x), ..., delta = Inf, strict = TRUE)
```

## Arguments

- x:

  The object.

- select:

  A character vector of the distributions to select.

- ...:

  Unused.

- delta:

  A non-negative number specifying the maximum absolute AIC difference
  cutoff. Distributions with an absolute AIC difference greater than
  delta are excluded from the calculations.

- strict:

  A flag indicating whether all elements of select must be present.

## Examples

``` r
fits <- ssd_fit_dists(ssddata::ccme_boron)
subset(fits, c("gamma", "lnorm"))
#> Distribution 'gamma'
#>   scale 25.1268
#>   shape 0.950179
#> 
#> Distribution 'lnorm'
#>   meanlog 2.56165
#>   sdlog 1.24154
#> 
#> Parameters estimated from 28 rows of data.
```
