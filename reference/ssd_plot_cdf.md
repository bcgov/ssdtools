# Plot Cumulative Distribution Function (CDF)

Generic function to plots the cumulative distribution function (CDF).

## Usage

``` r
ssd_plot_cdf(x, ...)

# S3 method for class 'fitdists'
ssd_plot_cdf(x, average = FALSE, delta = 9.21, ...)

# S3 method for class 'list'
ssd_plot_cdf(x, ...)
```

## Arguments

- x:

  The object.

- ...:

  Additional arguments passed to
  [`ssd_plot()`](https://bcgov.github.io/ssdtools/reference/ssd_plot.md).

- average:

  A flag specifying whether to provide model averaged values as opposed
  to a value for each distribution or if NA provides model averaged and
  individual values.

- delta:

  A non-negative number specifying the maximum absolute AIC difference
  cutoff. Distributions with an absolute AIC difference greater than
  delta are excluded from the calculations.

## Methods (by class)

- `ssd_plot_cdf(fitdists)`: Plot CDF for fitdists object

- `ssd_plot_cdf(list)`: Plot CDF for named list of distributional
  parameter values

## See also

[`ssd_plot()`](https://bcgov.github.io/ssdtools/reference/ssd_plot.md)

[`estimates.fitdists()`](https://bcgov.github.io/ssdtools/reference/estimates.fitdists.md)
and
[`ssd_match_moments()`](https://bcgov.github.io/ssdtools/reference/ssd_match_moments.md)

## Examples

``` r
fits <- ssd_fit_dists(ssddata::ccme_boron)
ssd_plot_cdf(fits)

ssd_plot_cdf(fits, average = NA)


ssd_plot_cdf(list(
  llogis = c(locationlog = 2, scalelog = 1),
  lnorm = c(meanlog = 2, sdlog = 2)
))
```
