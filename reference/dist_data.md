# Distribution Data

A data frame of information on the implemented distributions.

## Usage

``` r
dist_data
```

## Format

An object of class `tbl_df` (inherits from `tbl`, `data.frame`) with 10
rows and 6 columns.

## Details

- dist:

  The distribution (chr).

- bcanz:

  Whether the distribution belongs to the set of distributions approved
  by BC, Canada, Australia and New Zealand for official guidelines
  (flag).

- tails:

  Whether the distribution has both tails (flag).

- npars:

  The number of parameters (int).

- valid:

  Whether the distribution has a valid likelihood that allows it to be
  fit with other distributions for modeling averaging (flag).

- bound:

  Whether one or more parameters have boundaries (flag).

## See also

Other dists:
[`ssd_dists()`](https://bcgov.github.io/ssdtools/reference/ssd_dists.md),
[`ssd_dists_all()`](https://bcgov.github.io/ssdtools/reference/ssd_dists_all.md),
[`ssd_dists_shiny()`](https://bcgov.github.io/ssdtools/reference/ssd_dists_shiny.md)

## Examples

``` r
dist_data
#> # A tibble: 10 × 6
#>    dist          bcanz tails npars valid bound
#>    <chr>         <lgl> <lgl> <int> <lgl> <lgl>
#>  1 burrIII3      FALSE TRUE      3 TRUE  TRUE 
#>  2 gamma         TRUE  TRUE      2 TRUE  FALSE
#>  3 gompertz      FALSE TRUE      2 TRUE  FALSE
#>  4 invpareto     FALSE FALSE     2 FALSE FALSE
#>  5 lgumbel       TRUE  TRUE      2 TRUE  FALSE
#>  6 llogis        TRUE  TRUE      2 TRUE  FALSE
#>  7 llogis_llogis FALSE TRUE      5 TRUE  TRUE 
#>  8 lnorm         TRUE  TRUE      2 TRUE  FALSE
#>  9 lnorm_lnorm   TRUE  TRUE      5 TRUE  TRUE 
#> 10 weibull       TRUE  TRUE      2 TRUE  FALSE
```
