# hc multi_ci lnorm

    Code
      hc_multi
    Output
      # A tibble: 1 x 13
        dist  proportion   est    se   lcl   ucl    wt est_method ci_method method    
        <chr>      <dbl> <dbl> <dbl> <dbl> <dbl> <dbl> <chr>      <chr>     <chr>     
      1 lnorm       0.05  1.68    NA    NA    NA     1 cdf        <NA>      parametric
      # i 3 more variables: nboot <int>, pboot <dbl>, samples <I<list>>

# hc multi_ci all

    Code
      hc_multi
    Output
      # A tibble: 1 x 13
        dist    proportion   est    se   lcl   ucl    wt est_method ci_method method
        <chr>        <dbl> <dbl> <dbl> <dbl> <dbl> <dbl> <chr>      <chr>     <chr> 
      1 average       0.05  1.26    NA    NA    NA     1 cdf        <NA>      <NA>  
      # i 3 more variables: nboot <int>, pboot <dbl>, samples <I<list>>

# hc multi_ci all multiple hcs

    Code
      hc_multi
    Output
      # A tibble: 2 x 13
        dist    proportion   est    se   lcl   ucl    wt est_method ci_method method
        <chr>        <dbl> <dbl> <dbl> <dbl> <dbl> <dbl> <chr>      <chr>     <chr> 
      1 average       0.05  1.26    NA    NA    NA     1 cdf        <NA>      <NA>  
      2 average       0.1   2.38    NA    NA    NA     1 cdf        <NA>      <NA>  
      # i 3 more variables: nboot <int>, pboot <dbl>, samples <I<list>>

# hc multi_ci all multiple hcs cis

    Code
      hc_multi
    Output
      # A tibble: 2 x 13
        dist    proportion   est    se   lcl   ucl    wt est_method ci_method   method
        <chr>        <dbl> <dbl> <dbl> <dbl> <dbl> <dbl> <chr>      <chr>       <chr> 
      1 average       0.05  1.26 0.622 0.492  2.13     1 multi      multi_fixed param~
      2 average       0.1   2.38 0.926 1.17   3.58     1 multi      multi_fixed param~
      # i 3 more variables: nboot <dbl>, pboot <dbl>, samples <I<list>>

# hc multi_ci lnorm ci

    Code
      hc_average
    Output
      # A tibble: 1 x 13
        dist  proportion   est    se   lcl   ucl    wt est_method ci_method method    
        <chr>      <dbl> <dbl> <dbl> <dbl> <dbl> <dbl> <chr>      <chr>     <chr>     
      1 lnorm       0.05  1.68 0.529 0.948  2.76     1 cdf        quantiles parametric
      # i 3 more variables: nboot <dbl>, pboot <dbl>, samples <I<list>>

---

    Code
      hc_multi
    Output
      # A tibble: 1 x 13
        dist  proportion   est    se   lcl   ucl    wt est_method ci_method method    
        <chr>      <dbl> <dbl> <dbl> <dbl> <dbl> <dbl> <chr>      <chr>     <chr>     
      1 lnorm       0.05  1.68 0.529 0.948  2.76     1 cdf        quantiles parametric
      # i 3 more variables: nboot <dbl>, pboot <dbl>, samples <I<list>>

