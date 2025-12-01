# Label numbers with significant digits and comma. If `hc_value` is present in breaks, put on new line and make bold.

Label numbers with significant digits and comma. If `hc_value` is
present in breaks, put on new line and make bold.

## Usage

``` r
ssd_label_comma_hc(
  hc_value,
  digits = 3,
  ...,
  big.mark = ",",
  decimal.mark = getOption("OutDec", ".")
)
```

## Arguments

- hc_value:

  A number of the hazard concentration value to offset.

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
  ggplot2::scale_x_log10(labels = ssd_label_comma_hc(1.26))
```
