# Empirical Cumulative Density

Empirical Cumulative Density

## Usage

``` r
ssd_ecd(x, ties.method = "first")
```

## Arguments

- x:

  a numeric, complex, character or logical vector.

- ties.method:

  a character string specifying how ties are treated, see ‘Details’; can
  be abbreviated.

## Value

A numeric vector of the empirical cumulative density.

## Examples

``` r
ssd_ecd(1:10)
#>  [1] 0.06097561 0.15853659 0.25609756 0.35365854 0.45121951 0.54878049
#>  [7] 0.64634146 0.74390244 0.84146341 0.93902439
```
