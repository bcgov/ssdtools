# Label numbers with significant digits and comma

Label numbers with significant digits and comma

## Usage

``` r
ssd_label_comma(
  digits = 3,
  ...,
  big.mark = ",",
  decimal.mark = getOption("OutDec", ".")
)
```

## Arguments

- digits:

  A whole number specifying the number of significant figures.

- ...:

  Unused.

- big.mark:

  A string specifying the thousands separator.

- decimal.mark:

  A string specifying the numeric decimal point.

## Value

A "labelling" function that takes a vector x and returns a character
vector of `length(x)` giving a label for each input value.

## See also

[`scales::label_comma()`](https://scales.r-lib.org/reference/label_number.html)

## Examples

``` r
ggplot2::ggplot(data = ssddata::anon_e, ggplot2::aes(x = Conc / 10)) +
  geom_ssdpoint() +
  ggplot2::scale_x_log10(labels = ssd_label_comma())
```
