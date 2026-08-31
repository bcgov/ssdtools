# Theme Element for Hazard Concentration Axis Labels

A
[`ggplot2::element_text()`](https://ggplot2.tidyverse.org/reference/element.html)
that draws multi-line labels in bold. It is required to make the hazard
concentration label produced by
[`ssd_label_comma_hc()`](https://bcgov.github.io/ssdtools/reference/ssd_label_comma_hc.md)
bold.

## Usage

``` r
ssd_element_text_hc(...)
```

## Arguments

- ...:

  Arguments passed to
  [`ggplot2::element_text()`](https://ggplot2.tidyverse.org/reference/element.html).

## Value

An object of class `element_text_hc`.

## See also

[`ssd_label_comma_hc()`](https://bcgov.github.io/ssdtools/reference/ssd_label_comma_hc.md)

## Examples

``` r
ggplot2::ggplot(data = ssddata::anon_e, ggplot2::aes(x = Conc / 10)) +
  geom_ssdpoint() +
  ggplot2::scale_x_log10(labels = ssd_label_comma_hc(1.26)) +
  ggplot2::theme(axis.text.x = ssd_element_text_hc())
```
