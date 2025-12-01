# Plot a fitdists Object

A wrapper on
[`ssd_plot_cdf()`](https://bcgov.github.io/ssdtools/reference/ssd_plot_cdf.md).

## Usage

``` r
# S3 method for class 'fitdists'
autoplot(object, ...)
```

## Arguments

- object:

  The object.

- ...:

  Unused.

## Value

A ggplot object.

## See also

[`ssd_plot_cdf()`](https://bcgov.github.io/ssdtools/reference/ssd_plot_cdf.md)

## Examples

``` r
fits <- ssd_fit_dists(ssddata::ccme_boron)
autoplot(fits)
```
