# Customising Plots

## Plotting the cumulative distributions

The `ssdtools` package plots the cumulative distribution functions using
[`ssd_plot_cdf()`](https://bcgov.github.io/ssdtools/reference/ssd_plot_cdf.md).

For example, consider the CCME boron data from the
[`ssddata`](https://github.com/open-AIMS/ssddata) package. We can fit,
and then plot the cdfs as follows.

``` r
library(ssdtools)
library(ggplot2)

fits <- ssd_fit_dists(ssddata::ccme_boron)
ssd_plot_cdf(fits)
```

![A plot of the CCME boron data with the six default
distributions.](customising-plots_files/figure-html/unnamed-chunk-2-1.png)

This graphic is a [ggplot](https://ggplot2.tidyverse.org) object and so
can be customized in the usual way.

For example, we can add the model-averaged cdf by setting
`average = NA`, change the string used to separate thousands using
`big.mark`, customize the color scale with
[`scale_color_manual()`](https://ggplot2.tidyverse.org/reference/scale_manual.html)
and change the theme.

``` r
ssd_plot_cdf(fits, average = NA, big.mark = " ") +
  scale_color_manual(name = "Distribution", breaks = c("average", names(fits)), values = 1:7) +
  theme_bw()
```

![A plot of the CCME boron data with the model average distribution and
the six default
distributions.](customising-plots_files/figure-html/unnamed-chunk-3-1.png)

## ggplot Geoms

The `ssdtools` package provides four ggplot geoms to allow you construct
your own plots.

### `geom_ssdpoint()`

The first is
[`geom_ssdpoint()`](https://bcgov.github.io/ssdtools/reference/geom_ssdpoint.md)
which plots species sensitivity data

``` r
ggplot(ssddata::ccme_boron) +
  geom_ssdpoint(aes(x = Conc)) +
  ylab("Probability density") +
  xlab("Concentration")
```

![A plot of the CCME boron
data.](customising-plots_files/figure-html/unnamed-chunk-4-1.png)

### `geom_ssdsegments()`

The second is `geom_ssdsegments()` which plots the ranges of censored
species sensitivity data

``` r
ggplot(ssddata::ccme_boron) +
  geom_ssdsegment(aes(x = Conc, xend = Conc * 4)) +
  ylab("Probability density") +
  xlab("Concenration")
```

![A plot of CCME boron data with the ranges of the censored data
indicated by horizontal
lines.](customising-plots_files/figure-html/unnamed-chunk-5-1.png)

### `geom_xribbon()`

The third is
[`geom_xribbon()`](https://bcgov.github.io/ssdtools/reference/geom_xribbon.md)
which plots species sensitivity confidence intervals

``` r
ggplot(boron_pred) +
  geom_xribbon(aes(xmin = lcl, xmax = ucl, y = proportion)) +
  ylab("Probability density") +
  xlab("Concenration")
```

![A plot of the confidence intervals for the CCME boron
data.](customising-plots_files/figure-html/unnamed-chunk-6-1.png)

### `geom_hcintersect()`

And the fourth is
[`geom_hcintersect()`](https://bcgov.github.io/ssdtools/reference/geom_hcintersect.md)
which plots hazard concentrations

``` r
ggplot() +
  geom_hcintersect(xintercept = c(1, 2, 3), yintercept = c(0.05, 0.1, 0.2)) +
  ylab("Probability density") +
  xlab("Concenration")
```

![A plot of hazard concentrations as dotted
lines.](customising-plots_files/figure-html/unnamed-chunk-7-1.png)

### Putting it together

Geoms can be combined as follows

``` r
gp <- ggplot(boron_pred, aes(x = est)) +
  geom_xribbon(aes(xmin = lcl, xmax = ucl, y = proportion), alpha = 0.2) +
  geom_line(aes(y = proportion)) +
  geom_ssdsegment(data = ssddata::ccme_boron, aes(x = Conc / 2, xend = Conc * 2)) +
  geom_ssdpoint(data = ssddata::ccme_boron, aes(x = Conc / 2)) +
  geom_ssdpoint(data = ssddata::ccme_boron, aes(x = Conc * 2)) +
  scale_y_continuous("Species Affected (%)", labels = scales::percent) +
  xlab("Concentration (mg/L)") +
  expand_limits(y = c(0, 1))

gp
```

![A plot of censored CCME boron data with confidence
intervals](customising-plots_files/figure-html/unnamed-chunk-8-1.png)

To log the x-axis and include mathematical notation and add the HC5
value use the following code.

``` r
gp +
  scale_x_log10(
    latex2exp::TeX("Boron $(\\mu g$/L)$")
  ) +
  geom_hcintersect(xintercept = ssd_hc(fits)$est, yintercept = 0.05)
```

![A plot of censored CCME boron data on log scale with confidence
intervals, mathematical and the 5% hazard
concentration.](customising-plots_files/figure-html/unnamed-chunk-9-1.png)

## Saving plots

The most recent plot can be saved as a file using
[`ggsave()`](https://ggplot2.tidyverse.org/reference/ggsave.html), which
also allows the user to set the resolution.

``` r
ggsave("file_name.png", dpi = 300)
```

## Licensing

Copyright 2015-2023 Province of British Columbia  
Copyright 2021 Environment and Climate Change Canada  
Copyright 2023-2025 Australian Government Department of Climate Change,
Energy, the Environment and Water

The documentation is released under the [CC BY 4.0
License](https://creativecommons.org/licenses/by/4.0/)

The code is released under the [Apache License
2.0](https://www.apache.org/licenses/LICENSE-2.0)
