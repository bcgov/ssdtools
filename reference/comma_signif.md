# Comma and Significance Formatter **\[deprecated\]**

Deprecated for
[`ssd_label_comma()`](https://bcgov.github.io/ssdtools/reference/ssd_label_comma.md)

## Usage

``` r
comma_signif(x, digits = 3, ..., big.mark = ",")
```

## Arguments

- x:

  A numeric vector to format.

- digits:

  A whole number specifying the number of significant figures.

- ...:

  Unused.

- big.mark:

  A string specifying the thousands separator.

## Value

A character vector.

## See also

[`ssd_label_comma()`](https://bcgov.github.io/ssdtools/reference/ssd_label_comma.md)

## Examples

``` r
if (FALSE) { # \dontrun{
comma_signif(c(0.1, 1, 10, 1000, 10000))
} # }
```
