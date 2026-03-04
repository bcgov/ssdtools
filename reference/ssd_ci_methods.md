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
#>  [1] "GMACL"              "GMAW1"              "GMAW2"             
#>  [4] "MACL"               "MAW1"               "MAW2"              
#>  [7] "arithmetic_samples" "geometric_samples"  "multi_fixed"       
#> [10] "multi_free"         "weighted_samples"  
```
