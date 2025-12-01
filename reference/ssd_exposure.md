# Proportion Exposure

Calculates average proportion exposed based on log-normal distribution
of concentrations.

## Usage

``` r
ssd_exposure(x, meanlog = 0, sdlog = 1, ..., nboot = 1000)
```

## Arguments

- x:

  The object.

- meanlog:

  The mean of the exposure concentrations on the log scale.

- sdlog:

  The standard deviation of the exposure concentrations on the log
  scale.

- ...:

  Unused.

- nboot:

  The number of samples to use to calculate the exposure.

## Value

The proportion exposed.

## Examples

``` r
if (FALSE) { # \dontrun{
fits <- ssd_fit_dists(ssddata::ccme_boron, dists = "lnorm")
withr::with_seed(50, {
  ssd_exposure(fits)
  ssd_exposure(fits, meanlog = 1)
  ssd_exposure(fits, meanlog = 1, sdlog = 1)
})
} # }
```
