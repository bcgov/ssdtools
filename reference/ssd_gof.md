# Goodness of Fit

Returns a tbl data frame with the following columns

- dist:

  The distribution name (chr)

- aic:

  Akaike's Information Criterion (dbl)

- bic:

  Bayesian Information Criterion (dbl)

- at_bound:

  Parameter(s) at boundary (lgl)

- computable:

  All parameter have computable standard errors (lgl)

and if the data are non-censored

- aicc:

  Akaike's Information Criterion corrected for sample size (dbl)

and if there are 8 or more samples

- ad:

  Anderson-Darling statistic (dbl)

- ks:

  Kolmogorov-Smirnov statistic (dbl)

- cvm:

  Cramer-von Mises statistic (dbl)

In the case of an object of class fitdists the function also returns

- delta:

  The Information Criterion differences (dbl)

- wt:

  The Information Criterion weights (dbl)

where `delta` and `wt` are based on `aic` for censored data and `aicc`
for non-censored data.

## Usage

``` r
ssd_gof(x, ...)

# S3 method for class 'fitdists'
ssd_gof(x, ..., pvalue = FALSE, wt = FALSE)
```

## Arguments

- x:

  The object.

- ...:

  Unused.

- pvalue:

  A flag specifying whether to return p-values or the statistics
  (default) for the various tests.

- wt:

  A flag specifying whether to return the Akaike weight as "wt" instead
  of "weight".

## Value

A tbl data frame of the gof statistics.

## Methods (by class)

- `ssd_gof(fitdists)`: Goodness of Fit

## See also

[`glance.fitdists()`](https://bcgov.github.io/ssdtools/reference/glance.fitdists.md)

## Examples

``` r
fits <- ssd_fit_dists(ssddata::ccme_boron)
ssd_gof(fits, wt = TRUE)
#> # A tibble: 6 × 14
#>   dist     npars  nobs log_lik   aic  aicc delta    wt   bic    ad     ks    cvm
#>   <chr>    <int> <int>   <dbl> <dbl> <dbl> <dbl> <dbl> <dbl> <dbl>  <dbl>  <dbl>
#> 1 gamma        2    28   -117.  238.  238. 0.005 0.357  240. 0.440 0.117  0.0554
#> 2 lgumbel      2    28   -120.  244.  245. 6.56  0.013  247. 0.829 0.158  0.134 
#> 3 llogis       2    28   -119.  241.  241. 3.39  0.066  244. 0.487 0.0994 0.0595
#> 4 lnorm        2    28   -118.  239.  240. 1.40  0.177  242. 0.507 0.107  0.0703
#> 5 lnorm_l…     5    28   -115.  240.  243. 4.98  0.03   247. 0.320 0.116  0.0414
#> 6 weibull      2    28   -117.  238.  238. 0     0.357  240. 0.434 0.117  0.0542
#> # ℹ 2 more variables: at_bound <lgl>, computable <lgl>
ssd_gof(fits, pvalue = TRUE, wt = TRUE)
#> # A tibble: 6 × 14
#>   dist       npars  nobs log_lik   aic  aicc delta    wt   bic    ad    ks   cvm
#>   <chr>      <int> <int>   <dbl> <dbl> <dbl> <dbl> <dbl> <dbl> <dbl> <dbl> <dbl>
#> 1 gamma          2    28   -117.  238.  238. 0.005 0.357  240. 0.807 0.839 0.847
#> 2 lgumbel        2    28   -120.  244.  245. 6.56  0.013  247. 0.460 0.485 0.445
#> 3 llogis         2    28   -119.  241.  241. 3.39  0.066  244. 0.759 0.945 0.821
#> 4 lnorm          2    28   -118.  239.  240. 1.40  0.177  242. 0.738 0.908 0.754
#> 5 lnorm_lno…     5    28   -115.  240.  243. 4.98  0.03   247. 0.922 0.846 0.929
#> 6 weibull        2    28   -117.  238.  238. 0     0.357  240. 0.813 0.839 0.854
#> # ℹ 2 more variables: at_bound <lgl>, computable <lgl>
```
