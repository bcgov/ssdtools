# Confidence Interval Methods for SSDs

Returns a character vector of the available non-deprecated methods for
getting the model averaged confidence limits for two or more
distributions.

## Usage

``` r
ssd_ci_methods()
```

## Value

A character vector of the available methods.

## Examples

``` r
ssd_ci_methods()
#> [1] "GMACL"              "MACL"               "arithmetic_samples"
#> [4] "geometric_samples"  "multi_fixed"        "multi_free"        
#> [7] "weighted_samples"  
```
