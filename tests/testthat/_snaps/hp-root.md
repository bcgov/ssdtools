# hp multi_ci lnorm

    Code
      hp_multi
    Output
      # A tibble: 1 x 13
        dist   conc   est    se   lcl   ucl    wt est_method ci_method method    nboot
        <chr> <dbl> <dbl> <dbl> <dbl> <dbl> <dbl> <chr>      <chr>     <chr>     <int>
      1 lnorm     1  1.95    NA    NA    NA     1 cdf        <NA>      parametr~     0
      # i 2 more variables: pboot <dbl>, samples <I<list>>

# hp multi_ci all

    Code
      hp_multi
    Output
      # A tibble: 1 x 13
        dist     conc   est    se   lcl   ucl    wt est_method ci_method method nboot
        <chr>   <dbl> <dbl> <dbl> <dbl> <dbl> <dbl> <chr>      <chr>     <chr>  <int>
      1 average     1  3.90    NA    NA    NA     1 cdf        <NA>      <NA>       0
      # i 2 more variables: pboot <dbl>, samples <I<list>>

# hp multi_ci lnorm ci

    Code
      hp_average
    Output
      # A tibble: 1 x 13
        dist   conc   est    se   lcl   ucl    wt est_method ci_method method    nboot
        <chr> <dbl> <dbl> <dbl> <dbl> <dbl> <dbl> <chr>      <chr>     <chr>     <dbl>
      1 lnorm     1  1.95  1.63 0.349  5.38     1 cdf        quantiles parametr~   100
      # i 2 more variables: pboot <dbl>, samples <I<list>>

---

    Code
      hp_multi
    Output
      # A tibble: 1 x 13
        dist   conc   est    se   lcl   ucl    wt est_method ci_method method    nboot
        <chr> <dbl> <dbl> <dbl> <dbl> <dbl> <dbl> <chr>      <chr>     <chr>     <dbl>
      1 lnorm     1  1.95  1.63 0.349  5.38     1 cdf        quantiles parametr~   100
      # i 2 more variables: pboot <dbl>, samples <I<list>>

