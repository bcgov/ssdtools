# hc multi lnorm

    Code
      hc_multi
    Output
      # A tibble: 1 x 11
        dist    percent   est    se   lcl   ucl    wt method     nboot pboot samples  
        <chr>     <dbl> <dbl> <dbl> <dbl> <dbl> <dbl> <chr>      <int> <dbl> <I<list>>
      1 average       5  1.68    NA    NA    NA     1 parametric     0    NA <dbl [0]>

# hc multi all

    Code
      hc_multi
    Output
      # A tibble: 1 x 11
        dist    percent   est    se   lcl   ucl    wt method     nboot pboot samples  
        <chr>     <dbl> <dbl> <dbl> <dbl> <dbl> <dbl> <chr>      <int> <dbl> <I<list>>
      1 average       5  1.26    NA    NA    NA     1 parametric     0    NA <dbl [0]>

# hc multi all multiple hcs

    Code
      hc_multi
    Output
      # A tibble: 2 x 11
        dist    percent   est    se   lcl   ucl    wt method     nboot pboot samples  
        <chr>     <dbl> <dbl> <dbl> <dbl> <dbl> <dbl> <chr>      <int> <dbl> <I<list>>
      1 average       5  1.26    NA    NA    NA     1 parametric     0    NA <dbl [0]>
      2 average      10  2.38    NA    NA    NA     1 parametric     0    NA <dbl [0]>

# hc multi all multiple hcs cis

    Code
      hc_multi
    Output
      # A tibble: 2 x 11
        dist    percent   est    se   lcl   ucl    wt method     nboot pboot samples  
        <chr>     <dbl> <dbl> <dbl> <dbl> <dbl> <dbl> <chr>      <dbl> <dbl> <I<list>>
      1 average       5  1.26 0.621 0.492  2.12     1 parametric    10     1 <dbl [0]>
      2 average      10  2.38 0.930 1.17   3.60     1 parametric    10     1 <dbl [0]>

# hc multi lnorm ci

    Code
      hc_average
    Output
      # A tibble: 1 x 11
        dist    percent   est    se   lcl   ucl    wt method     nboot pboot samples  
        <chr>     <dbl> <dbl> <dbl> <dbl> <dbl> <dbl> <chr>      <dbl> <dbl> <I<list>>
      1 average       5  1.68 0.529 0.948  2.76     1 parametric   100     1 <dbl [0]>

---

    Code
      hc_multi
    Output
      # A tibble: 1 x 11
        dist    percent   est    se   lcl   ucl    wt method     nboot pboot samples  
        <chr>     <dbl> <dbl> <dbl> <dbl> <dbl> <dbl> <chr>      <dbl> <dbl> <I<list>>
      1 average       5  1.68 0.535 0.979  2.99     1 parametric   100     1 <dbl [0]>

