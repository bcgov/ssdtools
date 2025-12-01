# Discrete color-blind scale for SSD Plots

The functions were designed for coloring different groups in a plot of
SSD data.

## Usage

``` r
scale_colour_ssd(...)

scale_color_ssd(...)

scale_fill_ssd(...)
```

## Arguments

- ...:

  Arguments passed to
  [`ggplot2::discrete_scale()`](https://ggplot2.tidyverse.org/reference/discrete_scale.html).

## Functions

- `scale_color_ssd()`: Discrete color-blind scale for SSD Plots

- `scale_fill_ssd()`: Discrete color-blind scale for SSD Plots

## See also

Other ggplot:
[`geom_hcintersect()`](https://bcgov.github.io/ssdtools/reference/geom_hcintersect.md),
[`geom_ssdpoint()`](https://bcgov.github.io/ssdtools/reference/geom_ssdpoint.md),
[`geom_ssdsegment()`](https://bcgov.github.io/ssdtools/reference/geom_ssdsegment.md),
[`geom_xribbon()`](https://bcgov.github.io/ssdtools/reference/geom_xribbon.md),
[`ssd_pal()`](https://bcgov.github.io/ssdtools/reference/ssd_pal.md)

## Examples

``` r
# Use the color-blind palette for a SSD plot
ssd_plot(ssddata::ccme_boron, boron_pred, shape = "Group", color = "Group") +
  scale_colour_ssd()

# Use the color-blind palette for a histogram of concentrations
ggplot2::ggplot(ssddata::ccme_boron, ggplot2::aes(x = Species, y = Conc, fill = Group)) +
  ggplot2::geom_col() +
  scale_fill_ssd() +
  ggplot2::theme(axis.text.x = ggplot2::element_text(angle = 90, vjust = 0.5, hjust = 1))
```
