# hc multi_ci lnorm

    Code
      hc_multi
    Output
      # A tibble: 1 x 11
        dist    proportion   est    se   lcl   ucl    wt method    nboot pboot samples
        <chr>        <dbl> <dbl> <dbl> <dbl> <dbl> <dbl> <chr>     <int> <dbl> <I<lis>
      1 average       0.05  1.68    NA    NA    NA     1 parametr~     0    NA <dbl>  

# hc multi_ci all

    Code
      hc_multi
    Output
      # A tibble: 1 x 11
        dist    proportion   est    se   lcl   ucl    wt method    nboot pboot samples
        <chr>        <dbl> <dbl> <dbl> <dbl> <dbl> <dbl> <chr>     <int> <dbl> <I<lis>
      1 average       0.05  1.26    NA    NA    NA     1 parametr~     0    NA <dbl>  

# hc multi_ci all multiple hcs

    Code
      hc_multi
    Output
      # A tibble: 2 x 11
        dist    proportion   est    se   lcl   ucl    wt method    nboot pboot samples
        <chr>        <dbl> <dbl> <dbl> <dbl> <dbl> <dbl> <chr>     <int> <dbl> <I<lis>
      1 average       0.05  1.26    NA    NA    NA     1 parametr~     0    NA <dbl>  
      2 average       0.1   2.38    NA    NA    NA     1 parametr~     0    NA <dbl>  

# hc multi_ci all multiple hcs cis

    Code
      hc_multi
    Output
      # A tibble: 2 x 11
        dist    proportion   est    se   lcl   ucl    wt method    nboot pboot samples
        <chr>        <dbl> <dbl> <dbl> <dbl> <dbl> <dbl> <chr>     <dbl> <dbl> <I<lis>
      1 average       0.05  1.26 0.623 0.492  2.13     1 parametr~    10     1 <dbl>  
      2 average       0.1   2.38 0.928 1.17   3.59     1 parametr~    10     1 <dbl>  

# hc multi_ci lnorm ci

    Code
      hc_average
    Output
      # A tibble: 1 x 11
        dist    proportion   est    se   lcl   ucl    wt method    nboot pboot samples
        <chr>        <dbl> <dbl> <dbl> <dbl> <dbl> <dbl> <chr>     <dbl> <dbl> <I<lis>
      1 average       0.05  1.68 0.529 0.948  2.76     1 parametr~   100     1 <dbl>  

---

    Code
      hc_multi
    Output
      # A tibble: 1 x 11
        dist    proportion   est    se   lcl   ucl    wt method    nboot pboot samples
        <chr>        <dbl> <dbl> <dbl> <dbl> <dbl> <dbl> <chr>     <dbl> <dbl> <I<lis>
      1 average       0.05  1.68 0.535 0.979  2.99     1 parametr~   100     1 <dbl>  

