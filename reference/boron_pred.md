# Model Averaged Predictions for CCME Boron Data

A data frame of the predictions based on 1,000 bootstrap iterations.

## Usage

``` r
boron_pred
```

## Format

An object of class `tbl_df` (inherits from `tbl`, `data.frame`) with 99
rows and 15 columns.

## Details

- proportion:

  The proportion of species affected (int).

- est:

  The estimated concentration (dbl).

- se:

  The standard error of the estimate (dbl).

- lcl:

  The lower confidence limit (dbl).

- se:

  The upper confidence limit (dbl).

- dist:

  The distribution (chr).

## Examples

``` r
if (FALSE) { # \dontrun{
fits <- ssd_fit_dists(ssddata::ccme_boron)
withr::with_seed(50, {
  boron_pred <- predict(fits, ci = TRUE)
})
head(boron_pred)
} # }
```
